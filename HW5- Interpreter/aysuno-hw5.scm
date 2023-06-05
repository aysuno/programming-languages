;; check if the operator is defined by interpreter, if yes return the operator
(define get-operator (lambda (op-symbol)
    (cond
        ((eq? op-symbol '+) +)
        ((eq? op-symbol '*) *)
        ((eq? op-symbol '-) -)
        ((eq? op-symbol '/) /)
        (else #f)
    )
  )
)

;;check if the structure of the let* is correct
(define letstar? (lambda (e)
    (if (and (list? e) (= (length e) 3) (eq? (car e) 'let*))
        #t
        #f
    )
  )
)

;; check if the if structure is correct
(define if? (lambda (e)
    (if(and (list? e) (= (length e) 4) (eq? (car e) 'if))
        #t  
        #f
    )
  )
)


;;check if the parameters are correct
(define correctparam? (lambda (e)
    (if (and (list? e)  (= (length (car e)) 2) (list? (car e)) (symbol? (caar e)))
        (if (null? (cdr e))
            #t
            (correctparam? (cdr e)))
        #f)
    )
)

;; check if let structure is correct
(define let? (lambda (e)
    (if (and (list? e) (= (length e) 3) (eq? (car e) 'let) (if (eq? '() (cadr e)) #t (correctparam? (cadr e))))
        #t
        #f
    )
  )
)

;; check if else is the final element for condition
(define elsefin? (lambda (e)
      (if (equal? (car (car(reverse e))) 'else)
          #t
          #f
      )
   )
)

;; check if there is only one else for the condition
(define elseone?
  (lambda (e)
    (cond 
        ((and (eq? (caar e) 'else) (null? (cdr e))) #t)
        ((and (eq? (caar e) 'else) (not (null? (cdr e)))) #f)
        (else (elseone? (cdr e)))
    )
  )
)

;; check if it is a correct structure for the condition
(define cond? (lambda (e)
    (if (and (> (length e) 2) (eq? (car e) 'cond) (list? (cadr e)) (elsefin? e) (elseone? (cdr e)))
        #t
        #f
    )
  )
)

;; check if the structure is correct for the else part of the condition
(define isCondElse? (lambda (e)
    (if (and (eq? (length e) 2) (list? (cadr e))  (eq? (caadr e) 'else))
        #t
        #f
    )
  )
)

(define get-value (lambda (var env)
    (cond 
       ( (null? env) (display "cs305: ERROR\n\n") (repl env))
       ( (eq? var (caar env)) (cdar env))
       ( else (get-value var (cdr env)))
    )
  )
)

(define extend-env (lambda (var val old-env)
        (cons (cons var val) old-env)))

(define define-expr? (lambda (e)
         (and (list? e) (= (length e) 3) (eq? (car e) 'define) (symbol?(cadr e)))))

(define s6 (lambda (e env)
   (cond

    ;; input is number
    ((number? e) e)

    ;; input is symbol
    ((symbol? e) (get-value e env))

    ;; if not a list
     ((not (list? e)) (display "cs305: ERROR\n\n") (repl env))

    ;; if
    ((if? e) 
        (if (not(eq? (s6 (cadr e) env) 0 ))
        (s6 (caddr e) env)
        (s6 (cadddr e) env))
    )

    ;; condition
    ((cond? e)
        (if(not(eq? (s6 (caadr e) env) 0))
        (s6 (cadadr e) env)
        (s6 (cons 'cond (cddr e)) env))
    )

    ;; else of the condition
    ((isCondElse? e)
        (s6 (cadadr e) env)
    )

    ;; let
    ((let? e)
    (let*
        ((parameter (map s6 (map cadr (cadr e)) 
        (make-list (length (map cadr (cadr e))) env)))
        (newenv (append ( map cons (map car (cadr e)) parameter) env)))
        (s6 (caddr e) newenv))
    )

    ;; let*
    ((letstar? e)
        (if (eq? (length (cadr e)) 0)
            (s6 (list 'let '() (caddr e)) env)
            (if (eq? (length (cadr e)) 1)
                  (s6 (list 'let (cadr e) (caddr e)) env)
                    (let*
                        ((parameter (s6 (car (cdaadr e)) env))
                        (newenv (cons (cons (caaadr e) parameter) env)))
                        (s6 (list 'let* (cdadr e) (caddr e)) newenv)
                    )
            )
        )
    )

    ;; operation
    ((get-operator(car e))
      (let ((operands (map s6 (cdr e) (make-list (length (cdr e)) env))) 
      (operator (get-operator (car e))))
      (apply operator operands))
    )
      (else 
          (display "cs305: ERROR\n\n") (repl env)
      )
    )          
  )            
)

(define repl (lambda (env)
   (let* (
           (dummy1 (display "cs305> "))
           (expr (read))
           (new-env (if (define-expr? expr) 
                        (extend-env (cadr expr) (s6 (caddr expr) env) env)
                        env
                    ))
           (val (if (define-expr? expr)
                    (cadr expr)
                    (s6 expr env)
                ))
           (dummy2 (display "cs305: "))
           (dummy3 (display val))
           (dummy4 (newline))
           (dummy5 (newline))
          )
          (repl new-env))))
(define cs305 (lambda () (repl '())))