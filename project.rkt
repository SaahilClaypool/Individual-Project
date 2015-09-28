
;;Saahil Claypool Individual Project

;; Graphics language to do animation
(require "world-cs1102.rkt")



;; addShape ('name shape)
;; a shape is either
;; - (make-circle 'name radius posn vel)
;; - (make-rectangle 'name width height posn vel)

;; circle is (make-circleObject symbol int posn vel 
(define-struct circleObject (name radius posn vel))

;; rectangle is a (make-rectangleObject symbol int int posn vel 
(define-struct rectangleObject (name width height posn vel))
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
;;takes name of shape, changes its velocity
(define-struct setVel(name vel))


;; jump: (make-jump name)
;; takes in a shape name and makes a command for that shape to jump to random locations
(define-struct jump(name))

;; stop: (make-stop symbol)
;; reverts vel of shape to (make-vel 0 0)
(define-struct stop(name))

;; horzBounce: (make-horzBounce shape)
;; reverses x vel of shape
(define-struct horzBounce (name))
;; horzBounce: (make-vertBounce shape)
;; reverses y vel of shape
(define-struct vertBounce (name))



;; addCollisionEvent: (make-addCollisionEvent symbol symbol list[cmd])
;; takes in two objects, executes list of events of what should happen when
;; the two given objects collide
;; either object can be Symbol 'lWall (left wall) 'rWall (right wall) 'tWall (top wall) or 'bWall (bottom wall) this creates event for objects hitting edges
(define-struct addCollisionEvent (object1 object2  listofcommand))

;; (make-repeat cmd)
;; adds a command to a list of commands to be executed every 'tick'
(define-struct repeat(command))


;; stopAll: (make-stopAll )
;; ends animation
(define-struct stopAll())






(define animationA
  (let ([circle1 (make-circleObject  'rect 10
                                    (make-posn 10 5)
                                    (make-vel 5 1)
                                   )]
        [rect1 (make-rectangleObject 'circ 5 100
                                     (make-posn 100 5)
                                     (make-vel 0 0 ))])
    (make-animation (list
                     (make-addShape  circle1)
                     (make-addShape  rect1)
                     
                     
                     (make-addCollisionEvent 'circ 'rect1
                                             (list (make-deleteShape 'rect)
                                                   (make-horzBounce 'circ)))
                     (make-addCollisionEvent circle1 'lWall
                                             (list (make-stopAll)))))))

(define animationB
  (let ([circ1 (make-circleObject 'circ1 10 (make-posn 100 100) (make-vel 0 0))])
    (make-animation (list
                     (make-addShape circ1)
                     (make-repeat (make-jump 'circ1))
                     (make-addCollisionEvent 'circ1 'tWall
                                             (list (make-stop 'circ1)
                                                   (make-stopAll)))))))
(define animationC
  (let ([circ1 (make-circleObject 'circ1 7 (make-posn 20 20) (make-vel 5 5 ))]
        [rect1 (make-rectangleObject 'rect  100 10 (make-posn 5 100) (make-vel 0 0 ))])
    (make-animation (list
                     (make-addShape circ1)
                     (make-addShape rect1)
                     
                     (make-addCollisionEvent 'circ1 'rect1
                                             (list (make-addShape (make-rectangleObject 'newRect 10 50 (make-posn 80 10) (make-vel 0 0 )))
                                                   (make-setVel 'circ1 (make-vel 5 0))))
                     (make-addCollisionEvent 'circ1 'newRect
                                             (list (make-jump 'circ1)
                                                   (make-stopAll)))))))
                     






