
;;Saahil Claypool Individual Project

;; Graphics language to do animation
(require "world-cs1102.rkt")


(circle 5 "solid" "red")
(rectangle 40 80 "solid" "green")



;; addShape ('name shape)
;; a shape is a (make-shape symbol posn image)
(define-struct shape(name posn image))

;; an animation is a (make-animation list[cmd]
;; takes in a list of commands, creates an animation from this list
(define-struct animation (listCmd))

;; velocity is a (make-vel int int)
;; creats an x y velocity
(define-struct vel(x y))
;; posn is (make-posn int int)
;; creates x y position (pre defined)

;;collision is a (make-collision symbol sybol)
;; represents the collision of two objects
(define-struct collision (shapeName1 shapeName2))


;; -------------------------------------------------
;; COMMANDS


#|a cmd is either a
    (make-addShape shape)
    (make-removeShape shapeName)
    (make-jump shapeName)
    (make-move shapeName vel)
    (make-stop shapeName)
    (make-collisionEvent collision cmd)


|#

;; addShape: is (make-addShape shape) 
(define-struct addShape (shape))

;; removeShape is (make-removeShape symbol)
(define-struct removeShape(shapeName))

;; jump is (make-jump symbol)
(define-struct jump (shapeName))

;; jumpOnce is (make-jumpOnce symbol)
(define-struct jumpOnce (shapeName))
;; move is (make-move symbol vel
(define-struct move (shapeName vel))

;; stop is (make-stop symbol)
(define-struct stop (shapeName))

;; collisionEvent is (make-collisionEvent collision cmd
(define-struct collisionEvent (collision cmd))

;; collision is (make-collision symbol sybol)
;; a symbol is either a shape name or 'lEdge 'rEdge 'tEdge 'bEdge where each symbol corresponds with the appropriate Edge of the animation


;; ~~~~~~~~~~~~~~~~~~~~~~~EXAMPLES

(define animationA
  (let ([circ (make-shape 'circ (make-posn 10 5) (circle 5 "solid" "blue"))]
        [rect (make-shape 'rect (make-posn 5 100)(rectangle 5 100 "solid" "green"))]
        [collision (make-collision 'circ 'rect)]
        )
    (make-animation (list
                     (make-addShape circ)
                     (make-addShape rect)
                     (make-move 'circ (make-vel 5 1))
                     (make-collisionEvent collision (make-removeShape 'rect))
                     (make-collisionEvent collision (make-move 'circ (make-vel -5 1)))
                     (make-collisionEvent (make-collision 'lEdge 'circ) (make-stop 'circ))))))



(define animationB
  (let ([circ (make-shape 'circ (make-posn 100 100) (circle 5 "solid" "blue"))]
        )
    (make-animation (list
                     (make-addShape circ)
                     (make-jump 'circ)
                     (make-collisionEvent (make-collision 'circ 'tEdge)
                                          (make-stop 'circ))))))





(define animationC
  (let ([circ (make-shape 'circ (make-posn 20 20 ) (circle 7 "solid" "red"))]
        [rect (make-shape 'rect (make-posn 5 100 ) (rectangle 100 10 "solid" "blue"))]
        [newRect (make-shape 'newRect (make-posn 80 10 ) (rectangle 10 50 "solid" "orange"))]
        )
    (make-animation (list
                     (make-addShape circ)
                     (make-addShape rect)
                     (make-move 'circ (make-vel 5 5))
                     (make-collisionEvent (make-collision 'circ 'rect)
                                          (make-addShape newRect))
                     (make-collisionEvent (make-collision 'circ 'rect)
                                          (make-addShape newRect))
                     (make-collisionEvent (make-collision 'circ 'rect)
                                          (make-move 'circ (make-vel 5 0)))
                     (make-collisionEvent (make-collision 'circ 'newRect)
                                          (make-jumpOnce 'circ))))))





;;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ INTERPRETER

