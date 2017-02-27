;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname |Programming II Final|) (read-case-sensitive #t) (teachpacks ((lib "universe.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #t #t none #f ((lib "universe.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp")) #f)))
;VECTOR CONSTANTS
(define masterVector (make-vector 30 (void)))
(define (build-vectors)
  (local[(define(vect-help num index)
           (cond[(>= num 15000)(void)]
                [else (begin(vector-set! masterVector index (build-vector num (lambda(b)(random num))))
                            (vect-help (+ 500 num)(+ 1 index)))]))]
    (vect-help 500 0)))
(build-vectors)


;CHECK-EXPECT VECTOR
(define v (vector 34 2 6 57))

;;; QUICK SORT ;;;
; qs-in-place!: (vectorof number) -> (void)
; Purpose: To sort the array in non-decreasing order.
; Effect: The elements of the array are rearranged in place.
(define (quick-sort! V)
  (local [; qs-aux!: 0<= natnum < |V| 0<= natnum < |V| -> (void)
          ; Purpose: To sort V[left..right] in non-decreasing order
          ; Effect: The elements of V[left..right] are rearranged in place
          (define (qs-aux! left right)
            (cond [(< right left) (void)]
                  [else
                   (local [(define pivot-pos (partition! left right))]
                     (begin
                       (qs-aux! left (sub1 pivot-pos))
                       (qs-aux! (add1 pivot-pos) right)))]))
          
          ; partition!: natnum < |V| natnum < |V| -> number
          ; Purpose: Partition V by placing the pivot, V[i], in its final sorted position.
          ; Effect: Mutate V so that all elements before the pivot are <= pivot and all elements
          ; after the pivot are > pivot.
          (define (partition! i j)
            (local [
              ; separate!: i <= natnum <= j -> i <= natnum <= j
              ; Purpose: To separate the elements <= the pivot from the elements > the pivot
              ; Effect: In V move elements <= pivot before elements > pivot.
              (define (separate! left right)
                (local [(define s-index (smaller=-index right))
                        (define l-index (larger-index left))]
                  (cond [(< s-index l-index) s-index]
                        [else
                         (begin
                           (swap s-index l-index)
                           (separate! l-index s-index))])))

              ; smaller=-index: i <= natnum <= j -> i <= natnum <= j
              ; Purpose: Find the rightmost index, k, in V such that V[k] <= V[i]
              (define (smaller=-index b)
                (cond [(= b i) i]
                      [(<= (vector-ref V b) (vector-ref V i)) b]
                      [else (smaller=-index (sub1 b))]))

              ; larger-index: i <= natnum <= j -> i <= natnum <= j
              ; Purpose: Find the leftmost index, k, in V such that V[k] > V[i]
              ; if it exists else return |V|
              (define (larger-index a)
                (cond [(= a (vector-length V)) a]
                      [(> (vector-ref V a) (vector-ref V i)) a]
                      [else (larger-index (add1 a))]))]

              
              (begin
                (local [(define pivot-pos (separate! i j))]
                  (begin
                    (swap i pivot-pos)
                    pivot-pos)))))
          
          ; swap: natnum <= (vector-length V) natnum <= (vector-length V) -> (void)
          ; Purpose: To swap V[i] and V[j]
          ; Effect: To modify V[i] to contain the value of V[j] and vice versa
          (define (swap i j)
            (local [(define temp (vector-ref V i))]
              (begin
                (vector-set! V i (vector-ref V j))
                (vector-set! V j temp))))]
    
    (qs-aux! 0 (sub1 (vector-length V)))))

(check-expect (begin
                (quick-sort! v)
                v)
              (vector 2 6 34 57))


;;; SELECTION SORT ;;;
;selection-sort! : (vectorof num) -> (void)
;Purpose : sort the given vector in non-decreasing order
;Effect : the elements of the vector are put into non-decereasing order
;Assumption : the given vector is in non-decreasing order
(define (selection-sort! V)
  (local [;natnum -> natnum
          ;Purpose: To find the index of the maximum element in V [0...i]
          (define (find-index-of-max i)
            (cond [(= i 0) i]
                  [else
                   (local [(define index-max-of-rest (find-index-of-max (sub1 i)))]
                     (cond [(> (vector-ref V i) (vector-ref V index-max-of-rest)) i]
                           [else index-max-of-rest]))]))

          ;natnum -> (void)
          ;Purpose: To sort V in non-decreasing order
          ;Effect: The elements of V are rearragned to be in non-decreasing order
          (define (sorter! max-index-of-unsorted)
            (cond [(= max-index-of-unsorted 0) (void)]
                  [else
                   (begin
                     (swap max-index-of-unsorted (find-index-of-max max-index-of-unsorted))
                     (sorter! (sub1 max-index-of-unsorted)))]))

          ;natnum natnum -> (void)
          ;Purpose: swap V(i) and V(j)
          ;Effect: V(i) is changed to have the value of V(j) and vice versa
          (define (swap i j)
            (local [(define temp (vector-ref V i))]
              (begin
                (vector-set! V i (vector-ref V j))
                (vector-set! V j temp))))]
    
    (sorter! (sub1 (vector-length V)))))

(check-expect (begin
                (selection-sort! v)
                v)
              (vector 2 6 34 57))

;;; INSERTION SORT ;;;

;sort-in-place! : (vectorof number) -> (void)
;Purpose : sort a vector
;Effect : modify given vector so that it contains the original elements in nondecreasing order
(define (insertion-sort! V)
  (local [(define (sort-aux i)
            (cond [(zero? i)(void)]
                  [else (begin
                          (sort-aux(sub1 i))
                          (insert (sub1 i)))]))
          
          ; insert: natnum <= (vector-length V) -> (void)
          ; Purpose: To insert V[i] in V[0..i-1] to make V[0..i] sorted
          ; Effect: To modify V[0..i] to contains its original elements sorted
          (define (insert i)
            (cond [(zero? i) (void)]
                  [else
                   (cond [(< (vector-ref V i) (vector-ref V (sub1 i)))
                          (begin
                            (swap i (sub1 i))
                            (insert (sub1 i)))]
                         [else (void)])]))

          ; swap : natnum <= (vector-length V) natnum <= (vector-length V) -> (void)
          ; Purpose : To swap V[i] and V[j]
          ; Effect : To modify V[i] to contain the value of V[j] and vice versa
          (define (swap i j)
            (local [(define temp (vector-ref V i))]
              (begin
                (vector-set! V i (vector-ref V j))
                (vector-set! V j temp))))]
    
    (sort-aux (vector-length V))))

(check-expect (begin
                (insertion-sort! v)
                v)
              (vector 2 6 34 57))

;;; RADIX-SORT ;;;

;(max-i vect) >> num
;Purpose: To find the largest value in the list by comparing indexes in the given vector
;Termination: End will continue to increase by 1 every call. Therefore, at some point in time it will equal the length of the vector.
(define(maxi vect)
  ;max? vect num num >> num
  ;Purpose: find max value in vect
  (local[(define(max? vect start end)
           (cond[(eq? end (vector-length vect))(vector-ref vect start)]
                [else(cond[(<(vector-ref vect start)(vector-ref vect end))(max? vect end (add1 end))]
                          [else(max? vect start(add1 end))])]))]
    (cond[(zero? (vector-length vect))false]
         [(= 1 (vector-length vect))(vector-ref vect 0)]
         [else(max? vect 0 1)])))

;how-many-digits : num -> num
;Purpose: determines how many digits are in a number
(define (how-many-digits num)
  (local[(define(digits num accum)
           (cond[(> 1 num)accum]
                [else(digits (/ num 10)(+ 1 accum))]))]
    (digits num 0)))

(check-expect(maxi(vector 30 2134 154 123487 1234 45 123 435 92 5342 43 1 21341))123487)
(check-expect(maxi(vector 1))1)
(check-expect(maxi(vector))false)
(check-expect (how-many-digits 9999999)7)

;make-bucket:number --> bucket
;purpose: to make a bucket of the given size
(define (make-bucket n)
  (local[
         (define i 0)
         ;(vector of number)
         ;purpose: to hold the numbers in the bucket
         (define V (build-vector n (lambda (i) (void))))
         
         ;natnum -> void
         ;purpose: to add the given number to the bucket
         ;effect: V[i] ets the value of n and i is increased
         (define (add! n)
           (begin
             (vector-set! V i n)
             (set! i(add1 i))))
         
         ;(vectorof number) natnum -> void
         ;purpose: to put all the elemenets of the bucket in the given vector starting at the given index
         ;effect: i made 0; all bucket elems made void; D[j..bucketsize-1]=bucketelems
         (define (dump! D j)
           (local [(define (helper k l) ; k is index into D and l is index into the bucket
                     (cond [(= i l)(void)]
                           [else
                            (begin
                              (vector-set! D k (vector-ref V l))
                              (vector-set! V l(void))
                              (helper (add1 k)(add1 l)))]))]
             (begin
               (helper j 0)
               (set! i 0))))
         
         (define (service-manager m)
           (cond[(eq? m 'add) add!]
                [(eq? m 'dump) dump!]
                [(eq? m 'size) i]
                [(eq? m 'elems) V]
                [else (error 'bucket "Unknown message.")]))]
    service-manager))

(define (bucket-add! B v)((B 'add) v))
(define (bucket-dump! B D i)((B 'dump) D i))
(define (bucket-size B)(B 'size))
(define (bucket-elems B)(B 'elems))

(define (radix-sort! V)
  (local[;buckets : a vector containing 10 buckets
         (define buckets(build-vector 10 (lambda(x)(make-bucket (vector-length V)))))

    
         (define (bucket-helper maxNum index)
           (cond[(= index maxNum)(void)]
                [else (begin
                        (add-all-to-buckets 0 index)
                        (dump-all-buckets 0 0)
                        (bucket-helper maxNum (add1 index)))]))

         ;add-all-to-buckets : num num -> (void)
         ;Purpose : adds the elements of the vector to the approriate bucket
         ;Effect : The elements are put into buckets [0...9] by the appropriate digit
         (define (add-all-to-buckets index maxNum)
           (cond[(= index (vector-length V))(void)]
                [else (begin
                        (bucket-add! (vector-ref buckets(quotient(modulo (vector-ref V index) (expt 10 (+ 1 maxNum)))(expt 10 maxNum))) (vector-ref V index))
                        (add-all-to-buckets (add1 index) maxNum))]))
         
         ;dump-all-buckets : num num -> (void)
         ;Purpose : takes the elements in buckets [0...9] and puts it back into the given vector in order by the appropriate digit
         ;Effect : buckets are emptied out and vector is filled with the elements in order by digit
         (define (dump-all-buckets vectIndex bucketIndex)          
           (cond[(= bucketIndex (vector-length buckets))(void)]
                [else (local[(define indexIncrease (+ vectIndex (bucket-size (vector-ref buckets bucketIndex))))]
                        (begin
                          (bucket-dump! (vector-ref buckets bucketIndex) V vectIndex)
                          (dump-all-buckets indexIncrease (add1 bucketIndex))))]))]                 
    (bucket-helper (how-many-digits(maxi V)) 0 )))

(check-expect (begin
                (radix-sort! v)
                v)
              (vector 2 6 34 57))
              

(define (time-test)
  (local[(define (test-help index)
         (cond[(>= index 30)(void)]
          [else (begin
                  (display (string-append(string-append "Time at position " (number->string index)) ": "))
                  (time(quick-sort! (vector-ref masterVector index)))
                 ;(display(time(insertion-sort! (vector-ref masterVector index))))
                  ;(display(time(selection-sort! (vector-ref masterVector index))))
                   ;(display(time(radix-sort! (vector-ref masterVector index))))
                   (test-help (add1 index)))]))]
    (test-help 0)))