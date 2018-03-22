#| ===== HELPER DEFINTIONS ===== |#

#| ATOM? |#
(define (atom? x) (not (or (pair? x) (null? x)))) ; returns true for atoms

#| GET-DIFF LISTDIFF |#
(define (get-diff listdiff)
	(cond
		[(null-ld? listdiff) '()] ; end recursion
		[(or (list? (cdr-ld listdiff)) (listdiff? (cdr-ld listdiff))) ; listdiff still has elements?
			(cons (car-ld listdiff) (get-diff (cdr-ld listdiff)))] ; recursively build
		[else listdiff]) 
)

#| ====== IMPLEMENTATION  ======|#

#| NULL-LD? |#
(define (null-ld? obj)
	(cond
		[(null? obj) #t] ; empty list
		[(equal? (car obj) '()) #t] ; cons '() ils
		[(eq? (car obj) (cdr obj)) #t] ; same object
		[else #f])
)

#| LISTDIFF? |#
(define (listdiff? obj)
	(cond
		[(atom? obj) #f]  ; singleton
		[(atom? (car obj)) #f] ; exit case
		[(pair? obj)
			(cond
				[(null? (car obj)) #f] ; exit case
				[(null? (cdr obj)) #t] ; exit case
				[(eq? (car obj) (cdr obj)) #t] ; cons ils ils
				[else (listdiff? (cons (cdar obj) (cdr obj)))])]) ; recursively build
)

#| CONS-LD |#
(define (cons-ld obj listdiff)
	(if (listdiff? listdiff) ; listdiff must be a valid listdiff
		(cons obj listdiff)
		(display error))
)

#| CAR-LD |#
(define (car-ld listdiff)
		(if (or (atom? (car listdiff)) (listdiff? (car listdiff)))
			(car listdiff)
			(caar listdiff))
)

#| CDR-LD |#
(define (cdr-ld listdiff)
	(cond 
		[(and (null? (cdr listdiff)) (atom? (car listdiff))) (car listdiff)] ; singleton
		[(null? (cdr listdiff)) (cdar listdiff)] ; ils '()
		[(list? listdiff) (cdr listdiff)] 
		[else (cons (cdar listdiff) (cdr listdiff))])
)

#| LISTDIFF |#
(define (listdiff obj . stuff)
	(list (cons obj stuff))
)

#| LENGTH-LD |#
(define (length-ld listdiff)
	(cond
		[(null? listdiff) 0] ; exit case
		[(atom? listdiff) 0] ; exit case
		[(eq? (car listdiff) (cdr listdiff)) 0] ; cons ils ils
		[(null? (car listdiff)) 0] ; empty
		[(or (pair? listdiff) (atom? (car-ld listdiff)))
				(+ 1 (length-ld (cdr-ld listdiff)))]) ; recursion
) 

#| APPEND-LD |#
(define (append-ld listdiff . stuff)
	(define (build-ld listdiff stuff) ; build list
		(if (null? stuff) ; exit case
			(car listdiff)
			(append (get-diff listdiff) (build-ld (car stuff) (cdr stuff)))))

	(cons (build-ld listdiff stuff) '()) ; convert to listdiff
) 


#| ASSQ-LD |#
(define (assq-ld obj alistdiff)
	(let [(head ; value to return
			(if (null? (cdr alistdiff))
				 	(car-ld alistdiff)
				 	(car alistdiff)))
		(findThis ; car of valid ld
				(if (null? (cdr alistdiff))
				 	(car (car-ld alistdiff))
				 	(car (car alistdiff))))
		  (remaining (cdr-ld alistdiff))] ; rest of the lds
	(cond
		[(null? findThis) #f]; end of list
		[(eq? obj findThis) head] ; found match
		[else (assq-ld obj remaining)])) ; continue searching
)

#| LIST->LISTDIFF |#
(define (list->listdiff list)
	(cons (get-diff list) '())
)

#| LISTDIFF->LIST |#
(define (listdiff->list listdiff)
	(cond
		[(and (list? (car listdiff)) (null? (cdr listdiff))) (car listdiff)]
		[(list? listdiff) listdiff]
		[else (get-diff listdiff)]
		)
)

#| EXPR-RETURNING |#
(define (expr-returning listdiff)
	(let [(lst (listdiff->list listdiff))]
		(define (parse lst)
			(cond
				[(null? lst) (quasiquote '())] ; exit case
				[(null? (cdr lst)) (quasiquote (cons '(unquote (car lst)) '()))] ; exit case
				[else (quasiquote (cons '(unquote (car lst)) (unquote (parse (cdr-ld lst)))))] ; keep building
				)
			)
	(parse lst)
	)
)

#| ====== GIVEN TESTS  ======|#

(define ils (append '(a e i o u) 'y))
(define d1 (cons ils (cdr (cdr ils))))
(define d2 (cons ils ils))
(define d3 (cons ils (append '(a e i o u) 'y)))
(define d4 (cons '() ils))
(define d5 0)
(define d6 (listdiff ils d1 37))
(define d7 (append-ld d1 d2 d6))
(define kv1 (cons d1 'a))
(define kv2 (cons d2 'b))
(define kv3 (cons d3 'c))
(define kv4 (cons d1 'd))
(define d8 (listdiff kv1 kv2 kv3 kv4))
(define e1 (expr-returning d1))
(define e2 (expr-returning d2))
(define e6 (expr-returning d6))
(define e7 (expr-returning d7))
(define e8 (expr-returning d8))


