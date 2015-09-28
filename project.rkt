;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname project) (read-case-sensitive #t) (teachpacks ((lib "universe.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #t #t none #f ((lib "universe.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
;; Individual Project
;; Graphics language to do animation

;;NOTE: might be able to make anon shapes, doesnt really matter, will be searched anyways
;; a shape is either
;; - (make-circle 'name radius x y)
;; - (make-rectangle 'name width height x y)

;; circle is (make-circleObject symbol int posn vel 
(define-struct circleObject(name radius posn vel))

;; rectangle is a (make-rectangleObject symbol int int posn vel)
(define-struct rectangleObject (name width height posn vel))
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




;; addShape consumes shape, adds to 'world'
;; (shape -> void)
(define-struct addShape(shape))

;; deleteShape: symbol -> void
;; takes in a shape name, deletes that shape
(define-struct deleteShape(shape))

;; move: symbol int int -> void 
;;takes name of shape, moves it by x and y velocity



;; jump: symbol int int -> void
;; takes in a shape name and an x y location
(define-struct jump(shapeName))

;; might not need ````````````````````````````````````````````````````````````````````````````````````````````````` TODO
;; repeatCommand: (?? -> ??)
;; adds a command to be repeated every 'tick' of the world
(define-struct repeat(command))

;; addCollisionEvent: object object list[cmd]  -> void
;; takes in two objects, executes list of events of what should happen when
;; the two given objects collide
;; either object can be Symbol 'lWall (left wall) 'rWall (right wall) 'tWall (top wall) or 'bWall (bottom wall) this creates event for objects hitting edges
(define-struct addCollisionEvent (object1 object2  listofcommand))

;; horzBounce: (make-horzBounce shape)
;; reverses x vel of shape
(define-struct horzBounce (shape))
;; horzBounce: (make-vertBounce shape)
;; reverses y vel of shape
(define-struct vertBounce (shape))
;; stop: (make-stop shape)
;; reverts vel of shape to (make-vel 0 0)
(define-struct stop(shape))
(define animation1
  (let ([circle1 (make-circleObject 'circle1 1
                                    (make-posn 1 1)
                                    (make-vel 5 1))]
        [rectangle1 (make-rectangleObject 'rectangle1 10 10
                                          (make-posn 100 10)
                                          (make-vel 0 0 ))])
    (make-animation (list
                     (make-addShape circle1)
                     (make-addShape rectangle1)                   
                     (make-addCollisionEvent
                      circle1
                      rectangle1
                      (list(make-deleteShape rectangle1)
                           (make-horzBounce circle1)))))))

(define animationA
  (let ([circle1 (make-circleObject 'circ 10
                                    (make-posn 10 5)
                                    (make-vel 5 0))]
        [rect1 (make-rectangleObject 'rect 5 100
                                     (make-posn 100 5)
                                     (make-vel 0 0 ))])
    (make-animation (list
                     (make-addShape circle1)
                     (make-addShape rect1)
                     (make-addCollisionEvent circle1 rect1
                                             (list (make-deleteShape rect1)
                                                   (make-horzBounce circle1)))
                     (make-addCollisionEvent circle1 'lWall
                                             (list (make-stop circle1)))))))

(define animationB
  (let ([circ1 (make-circleObject 'circ1 10 (make-posn 100 100) (make-vel 0 0 ))])
   (make-animation (list
                    (make-addShape circ1)
                    (make-repeat (make-jump circ1))
                    (make-addCollisionEvent circ1 'tWall
                                                (list (make-stop circ1)))))))
(define animationC
  (let ([circ1 (make-circleObject 'circ1 7 (make-posn 20 20) (make-vel 0 5))]
        [rect1 (make-rectangleObject 'rect  100 10 (make-posn 5 100)(make-vel 0 0 ))])
    (make-animation (list
                     (make-addShape circ1)
                     (make-addShape rect1)
                     (make-addCollisionEvent circ1 rect1
                                             (list (make-addShape (make-rectangleObject 'newRect 10 50 (make-posn 80 10) (make-vel 0  0)))
                                                   (make-vertBounce circ1)))
                     (make-addCollisionEvent circ1 'tWall
                                             (list (make-stop circ1)))))))
                   
                     
;; interpreter: makes animationRunner: list of collisionEvents, list Objects, list repeat commands;
;;    runs original command list once, then starts animation.
;; Running; will check collisions (go through list of objects, check each for collide -> give back list of collides (2d (ab)(ac))
;;          will then run all repeat commands 

                                         