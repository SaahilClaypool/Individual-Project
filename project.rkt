;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname project) (read-case-sensitive #t) (teachpacks ((lib "universe.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #t #t none #f ((lib "universe.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
;; Individual Project
;; Graphics language to do animation

;; a shape is either
;; - (make-circle 'name radius x y)
;; - (make-rectangle 'name width height x y)

;; circle is (make-circleObject symbol int int int 
(define-struct circleObject(name radius x y))

;; rectangle is a (make-rectangleObject symbol int int int int)
(define-struct rectangleObject (name width height x y))

(define-struct animation (listCmd))

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

(define-struct move(shapeName xVel yVel))

;; jump: symbol int int -> void
;; takes in a shape name and an x y location
(define-struct jump(shapeName xLoc yLoc))

;; repeatCommand: (?? -> ??)
;; adds a command to be repeated every 'tick' of the world
(define-struct repeat(command))

;; addCollisionEvent: object (object -> command) -> void
;; takes in a name of object and a comand,
;; executes that command if that object is hit
(define-struct addCollisionEvent (name command))


(define animation1
  (let ([circle1 (make-circleObject 'circle1 1 1 1)]
        [rectangle1 (make-rectangleObject 'rectangle1 10 10 10 10)])
    (make-animation (list
                     (make-addShape circle1)
                     (make-addShape rectangle1)
                     (make-repeat (make-move 'circle1 5 5))
                     (make-addCollisionEvent circle1
                                         (lambda (thing-hit)
                                           (make-deleteShape thing-hit)))))))
                                         