#lang racket

(struct kill-gen (kills gens))

(define/contract (kills/gens instr)
  (-> list? kill-gen?)
  (match instr
    [`(,x <- (mem ,y ,n)) (kill-gen '(x) '(y))]
    [`((mem ,y ,n) <- ,s) ]
    [`(eax <- (allocate ,t1 ,t2)) ]
    [`(eax <- (array-error ,t1 ,t2)) ]
    [`(,x <- ,s) ]
    [`(,x ,op ,t) ]
    [`(,cx <- ,t1 ,cop, ,t2) ]
    [(? symbol?) ]
    [`(goto ,label) ]
    [`(cjump ,t1 ,cop ,t2 ,label1 ,label2) ]
    [`(call ,u) ]
    [`(tail-call ,u) ]
    [`(return) ]
    [`(eax <- (print ,t)) ]
    [else (error 'parse "Expression didn't conform to L1 grammar")]))
#;
(define/contract (killed? instr x)
  (-> list? symbol? bool?)
  (kill-gen-kills (kills/gens instr)))
    
(define/contract (label? x)
  (-> (or/c symbol? number?) bool?)
  (regexp-match #rx"^:[a-zA-Z_][a-zA-Z_0-9]*$" x))