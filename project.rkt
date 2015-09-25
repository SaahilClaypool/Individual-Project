;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname project) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
;; Individual Project
;; Graphics language to do animation

;; a shape is either
;; - (make-circle 'name radius x y)
;; - (make-rectangle 'name width height x y)

;; circle is make circle symbol int int int 
(define circle (make-circle name radius x y))

;; rectangle is a (make-rectangle symbol int int int int)
(define rectangle (make-rectangle name width height x y))

(define animation (listShape listCmd))

;; when the running animation, will take list of commands, make list of repeats: Every tick will do all repeats, plus check collision: if coll
;; will send event to both objects, let them move, then repaint the canvas. animation will separate list of collision evenents, could 

;; -------------------------------------------------
;; COMMANDS




;; addShape consumes shape, adds to 'world'
;; (shape -> void)
(define addShape(shape))

;; deleteShape: symbol -> void
;; takes in a shape name, deletes that shape
(define deleteShape(shape))

;; move: symbol int int -> void 
;;takes name of shape, moves it by x and y velocity

(define move(shapeName xVel yVel))

;; jump: symbol int int -> void
;; takes in a shape name and an x y location
(define jump(shapeName xLoc yLoc))

;; repeatCommand: (?? -> ??)
;; adds a command to be repeated every 'tick' of the world
(define repeat(command))

;; addCollisionEvent: symbol comand -> void
;; takes in a name of object and a comand,
;; executes that command if that object is hit
(define addCollisionEvent (name command))

(define animation1
  (

