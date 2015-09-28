
;;Saahil Claypool Individual Project

;; Graphics language to do animation
(require "world-cs1102.rkt")



;; addShape ('name shape)
;; a shape is either
;; - (make-circleObject 'name radius posn )
;; - (make-rectangleObject 'name width height posn )

;; circleObject is (make-circleObject symbol int posn  
(define-struct circleObject (name radius posn ))

;; rectangle is a (make-rectangleObject symbol int int posn)  
(define-struct rectangleObject (name width height posn ))
;; an animation is a (make-animation list[cmd]
;; takes in a list of commands, creates an animation from this list
(define-struct animation (listCmd))

;; velocity is a (make-vel int int)
;; creats an x y velocity
(define-struct vel(x y))
;; posn is (make-posn int int)
;; creates x y position (pre defined)



;; -------------------------------------------------
;; COMMANDS


#|a cmd is either a
    (make-addShape symbol shape)
    (make-deleteShape symbol)
    (make-setVel symbol vel)
    (make-jump symbol)
    (make-stop symbol)
    (make-horzBounce symbol)
    (make-vertBounce symbol)
    (make-addCollisionEvent symbol symbol cmd)
    (make-repeat cmd)
    (make-stopAll )
    


|#

;; addShape (make-addShape  shape), adds to 'world'

(define-struct addShape( shape))

;; deleteShape: (make-deleteShape symbol)
;; takes in a shape name, deletes that shape
(define-struct deleteShape(name))

;; move: (make-move symbol vel)
;;takes name of shape, changes its velocity TODO
(define-struct move(name vel))


;; jump: (make-jump name)
;; takes in a shape name and makes a command for that shape to jump to random locations
(define-struct jump(name))

;; stop: (make-stop symbol)
;; reverts vel of shape to (make-vel 0 0)
(define-struct stop(name))

;; horizantalBounce: (make-horzBounce shape)
;; reverses x vel of shape
(define-struct horizantalBounce (name))
;; verticalBounce: (make-vertBounce shape)
;; reverses y vel of shape
(define-struct verticalBounce (name))



;; addCollisionEvent: (make-addCollisionEvent collision list[cmd])
;; takes in two objects, executes list of events of what should happen when
;; the two given objects collide

(define-struct addCollisionEvent (collision listofcommand))


;; collision: (make-collision symbol symbol)
;; represents the collision of two objects
;; An object can either be the name of a shape or
;;'lWall (left wall) , 'rWall (right wall) , 'tWall (top wall) , 'bWall (bottom wall)
;; this creates event for objects hitting edges
(define-struct collision (object1 object2))
;; (make-repeat cmd collision)
;; adds a command to a list of commands to be executed every 'tick' until a collision (note: could be extended to take other events)
(define-struct repeatUntil(command a-collision))


;; stopAll: (make-stopAll )
;; ends animation
(define-struct stopAll())




;; ~~~~~~~~~~~~~~~~~~~~~~~EXAMPLES

(define animationA
  (let ([circle1 (make-circleObject  'circ 10
                                    (make-posn 10 5)
                                    
                                   )]
        [rect1 (make-rectangleObject 'rect 5 100
                                     (make-posn 100 5)
                                     )])
    (make-animation (list
                     (make-addShape  circle1)
                     (make-addShape  rect1)
                     (make-repeatUntil (make-move 'circ (make-vel 5 1)) (make-collision 'circ 'rect))
                     
                     (make-addCollisionEvent (make-collision 'circ 'rect)
                                             (list (make-deleteShape 'rect)
                                                   (make-repeatUntil (make-move 'circ (make-vel -5 1))
                                                                     (make-collision 'circ 'lwall))))))))

(define animationB
  (let ([circ1 (make-circleObject 'circ1 10 (make-posn 100 100) )])
    (make-animation (list
                     (make-addShape circ1)
                     (make-repeatUntil (make-jump 'circ1) (make-collision 'circ1 'twall))))))




(define animationC
  (let ([circ1 (make-circleObject 'circ1 7 (make-posn 20 20))]
        [rect1 (make-rectangleObject 'rect  100 10 (make-posn 5 100) )])
    (make-animation (list
                     (make-addShape circ1)
                     (make-addShape rect1)
                     (make-repeatUntil (make-move 'circ1  (make-vel 5 5 )) (make-collision 'circ1 'rect1))
                     (make-addCollisionEvent (make-collision 'circ1 'rect1)
                                             (list (make-addShape (make-rectangleObject 'newRect 10 50 (make-posn 80 10) ))
                                                   (make-repeatUntil (make-move 'circ1  (make-vel 5 0 )) (make-collision 'circ1 'newRect))))
                     (make-addCollisionEvent (make-collision 'circ1 'newRect)
                                             (list (make-jump 'circ1)
                                                   (make-stopAll)))))))
                     






