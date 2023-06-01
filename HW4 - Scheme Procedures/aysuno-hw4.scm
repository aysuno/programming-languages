(define main-procedure
    (lambda (tripleList)
        (if (or (null? tripleList) (not (list? tripleList)))
            (error "ERROR305: the input should be a list full of triples")
            (if (check-triple? tripleList)
                (sort-area (filter-pythagorean (filter-triangle (sort-all-triples tripleList))))
                (error "ERROR305: the input should be a list full of triples")
            )
        )
    )
)

;check if item contains only 3 elements and they are integers
(define input-correct?
  (lambda (iList)
    (and (= (length iList) 3) (integer? (car iList)) (integer? (cadr iList)) (integer? (caddr iList)))
  )
)

;check if triples satisfy the correct input format
(define check-triple?
    (lambda (tripleList)
        (if (null? tripleList) 
            #t
            (if (not (input-correct? (car tripleList))) 
                #f
                (check-triple? (cdr tripleList)))
        )
    )
)

;check if length equal to count given
(define check-length?
  (lambda (inTriple count)
    (if (= (length inTriple) count)
        #t
        #f
    )
  )
)

;check if sides are integer and greater than zero
(define check-sides?
    (lambda (inTriple)
        (if (or (not (integer? (car inTriple))) (not (integer? (cadr inTriple))) (not (integer? (caddr inTriple))))
            #f
            (if (or (<= (car inTriple) 0)  (<= (cadr inTriple) 0) (<= (caddr inTriple) 0))
                #f
                #t
            )     
        )
    )
)

;sort the triples by value
(define sort-triple
  (lambda (inTriple)
    (if (> (car inTriple) (cadr inTriple))
        (if (> (car inTriple) (caddr inTriple))
            (if (> (cadr inTriple) (caddr inTriple))
                (list (caddr inTriple) (cadr inTriple) (car inTriple))
                (list (cadr inTriple) (caddr inTriple) (car inTriple))
            )
            (list (cadr inTriple) (car inTriple) (caddr inTriple))
        )
        (if (> (car inTriple) (caddr inTriple))
            (list (caddr inTriple) (car inTriple) (cadr inTriple))
            (if (> (cadr inTriple) (caddr inTriple))
                (list (car inTriple) (caddr inTriple) (cadr inTriple))
                (list (car inTriple) (cadr inTriple) (caddr inTriple))
            )
        )
    )
  )
)

;sort more than one triples
(define sort-all-triples
  (lambda (tripleList)
    (if (null? tripleList)
        '()
        (cons (sort-triple (car tripleList)) (sort-all-triples (cdr tripleList)))
    )
  )
)

;check if input satisfy the triangle rule
(define triangle?
  (lambda (triple)
    (if (and (> (+ (car triple) (cadr triple)) (caddr triple)) (> (+ (car triple) (caddr triple)) (cadr triple)) (> (+ (cadr triple) (caddr triple)) (car triple)))
        #t
        #f
    )
  )       
)

;check if given triples are real triangles
(define filter-triangle
  (lambda (tripleList)
    (if (null? tripleList)
        '()
        (if (triangle? (car tripleList))
            (cons (car tripleList) (filter-triangle (cdr tripleList)))
            (filter-triangle (cdr tripleList))
        )
    )
  )
)

;check if input satisfy the pythagorean rule
(define pythagorean-triangle?
    (lambda (triple)
        (if (= (+ (* (car triple) (car triple)) (* (cadr triple) (cadr triple))) (* (caddr triple) (caddr triple)))
            #t
            #f
        )
    )
)

;check if it is a pythagorean
(define filter-pythagorean
  (lambda (tripleList)
    (if (null? tripleList)
        '()
        (if (pythagorean-triangle? (car tripleList))
            (cons (car tripleList) (filter-pythagorean (cdr tripleList)))
            (filter-pythagorean (cdr tripleList))
        )
    )
  )
)

;find the area of the triple
(define get-area
    (lambda (triple)
        (/ (* (car triple) (cadr triple)) 2)
    )
)

;find the smallest area in the triple list
(define smallArea
  (lambda (tripleList)
    (if (not(null? (cdr tripleList)))
        (if (< (get-area(car tripleList)) (get-area(smallArea (cdr tripleList))))
            (car tripleList)
            (smallArea (cdr tripleList))
        )
        (car tripleList)
    )
  )
)

;remove the current triple
(define pop
  (lambda (tripleList triple)
    (if (null? tripleList)
      '()
      (if (equal? (car tripleList) triple)
        (cdr tripleList)
        (cons (car tripleList) (pop (cdr tripleList) triple))
      )
    )
  )
)

;sort the area of the triples by finding smallest area and then removing it to move on with next smallest area
;it provides ascending areas
(define sort-area
  (lambda (tripleList)
    (if (null? tripleList)
        '()
        (cons (smallArea tripleList) (sort-area(pop tripleList (smallArea tripleList))))
    )
  )
) 