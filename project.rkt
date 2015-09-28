;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname project) (read-case-sensitive #t) (teachpacks ((lib "universe.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #t #t none #f ((lib "universe.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
;; Individual Project
;; Graphics language to do animation


;; TODO: add Stop when ()
;; addShape ('name shape)
;;NOTE: might be able to make anon shapes, doesnt really matter, will be searched anyways
;; a shape is either
;; - (make-circle 'name radius x y)
;; - (make-rectangle 'name width height x y)

;; circle is (make-circleObject symbol int posn  
(define-struct circleObject (name radius posn))

;; rectangle is a (make-rectangleObject symbol int int posn )
(define-struct rectangleObject (name width height posn ))
;; an animation is a (make-animation list[cmd]
;; takes in a list of commands, creates an animation from this list
(define-struct animation (listCmd))

;; velocity is a (make-vel int int)
;; creats an x y velocity
(define-struct vel(x y))


;; when the running animation, will take list of commands, make list of repeats: Every tick will do all repeats, plus check collision: if coll
;; will send event to both objects, let them move, then repaint the canvas. animation will separate list of collision evenents, could 

;; -------------------------------------------------
;; COMMANDS


#|a cmd is either a
    (make-addShape symbol shape)
    (make-deleteShape symbol)
    (make-move symbol vel)
    (make-jump symbol)
    (make-stop symbol)
    (make-horzBounce symbol)
    (make-vertBounce symbol)
    (make-addCollisionEvent symbol symbol cmd)
    (make-repeat cmd)
    (make-stopAll )
    


|#

;; addShape (make-addShape  shape), adds to 'world'
;; (shape -> void)
(define-struct addShape( shape))

;; deleteShape: (make-deleteShape symbol)
;; takes in a shape name, deletes that shape
(define-struct deleteShape(name))

;; move: (make-move symbol vel)
;;takes name of shape, moves it by x and y velocity
(define-struct move(name vel))


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



;; addCollisionEvent: object object list[cmd]  -> void
;; takes in two objects, executes list of events of what should happen when
;; the two given objects collide
;; either object can be Symbol 'lWall (left wall) 'rWall (right wall) 'tWall (top wall) or 'bWall (bottom wall) this creates event for objects hitting edges
(define-struct addCollisionEvent (object1 object2  listofcommand))

;; (make-repeat command)
;; might not need ````````````````````````````````````````````````````````````````````````````````````````````````` TODO
;; repeatCommand: (?? -> ??)
;; adds a command to be repeated every 'tick' of the world
(define-struct repeat(command))


;; stopAll: (make-stopAll )
;; ends animation
(define-struct stopAll())





(define animation1
  (let ([circle1 (make-circleObject 'circle 1
                                    (make-posn 1 1))]
        [rectangle1 (make-rectangleObject 'rectangle1 10 10
                                          (make-posn 100 10))])
    (make-animation (list
                     (make-addShape  circle1)
                     (make-addShape  rectangle1)
                     (make-repeat(make-move 'circle1 (make-vel 5 0)))
                     (make-addCollisionEvent
                      'circle1
                      'rectangle1
                      (list(make-deleteShape 'rectangle1)
                           (make-horzBounce 'circle1)))))))

(define animationA
  (let ([circle1 (make-circleObject  'rect 10
                                    (make-posn 10 5)
                                   )]
        [rect1 (make-rectangleObject 'circ 5 100
                                     (make-posn 100 5))])
    (make-animation (list
                     (make-addShape  circle1)
                     (make-addShape  rect1)
                     
                     (make-repeat (make-move 'circ (make-vel 5 1)))
                     (make-addCollisionEvent 'circ 'rect1
                                             (list (make-deleteShape 'rect)
                                                   (make-horzBounce 'circ)))
                     (make-addCollisionEvent circle1 'lWall
                                             (list (make-stop 'circle1)))))))

(define animationB
  (let ([circ1 (make-circleObject 'circ1 10 (make-posn 100 100) )])
    (make-animation (list
                     (make-addShape circ1)
                     (make-repeat (make-jump 'circ1))
                     (make-addCollisionEvent 'circ1 'tWall
                                             (list (make-stop 'circ1)
                                                   (make-stopAll)))))))
(define animationC
  (let ([circ1 (make-circleObject 'circ1 7 (make-posn 20 20) )]
        [rect1 (make-rectangleObject 'rect  100 10 (make-posn 5 100))])
    (make-animation (list
                     (make-addShape circ1)
                     (make-addShape rect1)
                     (make-repeat (make-move 'circ1 (make-vel 0 5)))
                     (make-addCollisionEvent 'circ1 'rect1
                                             (list (make-addShape (make-rectangleObject 'newRect 10 50 (make-posn 80 10) ))
                                                   (make-vertBounce 'circ1)))
                     (make-addCollisionEvent 'circ1 'tWall
                                             (list (make-stop 'circ1)))))))


;; interpreter: makes animationRunner: list of collisionEvents, list Objects, list repeat commands;
;;    runs original command list once, then starts animation.
;; Running; will check collisions (go through list of objects, check each for collide -> give back list of collides (2d (ab)(ac))
;;          will then run all repeat commands 

