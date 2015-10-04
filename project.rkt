
;;Saahil Claypool Individual Project
;;TODO make when adding move remove old move add  add jumpOnce

;; Graphics language to do animation
(require "world-cs1102.rkt")
(require test-engine/racket-gui)


(circle 5 "solid" "red")
(rectangle 40 80 "solid" "green")



;; addShape ('name shape)
;; a shape is a (make-shape symbol posn image)
(define-struct shape(name posn image) (make-inspector) )

;; an animation is a (make-animation list[cmd]
;; takes in a list of commands, creates an animation from this list
(define-struct animation (listCmd) (make-inspector))

;; velocity is a (make-vel int int)
;; creats an x y velocity
(define-struct vel(x y) (make-inspector))
;; posn is (make-posn int int)
;; creates x y position (pre defined)

;;collision is a (make-collision symbol sybol)
;; represents the collision of two objects
(define-struct collision (shapeName1 shapeName2) (make-inspector))


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
(define-struct addShape (shape) (make-inspector))

;; removeShape is (make-removeShape symbol)
(define-struct removeShape(shapeName) (make-inspector))

;; jump is (make-jump symbol)
(define-struct jump (shapeName) (make-inspector))

;; jumpOnce is (make-jumpOnce symbol)
(define-struct jumpOnce (shapeName) (make-inspector))
;; move is (make-move symbol vel
(define-struct move (shapeName vel) (make-inspector))

;; stop is (make-stop symbol)
(define-struct stop (shapeName) (make-inspector))

;; collisionEvent is (make-collisionEvent collision cmd
(define-struct collisionEvent (collision cmd) (make-inspector))

;; collision is (make-collision symbol sybol)
;; a symbol is either a shape name or 'lEdge 'rEdge 'tEdge 'bEdge where each symbol corresponds with the appropriate Edge of the animation


;; ~~~~~~~~~~~~~~~~~~~~~~~EXAMPLES

(define animationA
  (let ([circ (make-shape 'circ (make-posn 10 5) (circle 5 "solid" "blue"))]
        [rect (make-shape 'rect (make-posn 100 5)(rectangle 5 100 "solid" "green"))]
        [collision (make-collision 'circ 'rect)]
        )
    (make-animation (list
                     (make-addShape circ)
                     (make-addShape rect)
                     (make-move 'circ (make-vel 5 1))
                     
                     (make-collisionEvent collision (make-removeShape 'rect))
                     (make-collisionEvent collision (make-move 'circ (make-vel -5 1)))
                     (make-collisionEvent collision (make-stop 'circ))
                     
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
        [newRect (make-shape 'newRect (make-posn 80 80 ) (rectangle 10 50 "solid" "orange"))]
        )
    (make-animation (list
                     (make-addShape circ)
                     (make-addShape rect)
                     (make-move 'circ (make-vel 0 5))
                     (make-collisionEvent (make-collision 'circ 'rect)
                                          (make-addShape newRect))
                     (make-collisionEvent (make-collision 'circ 'rect)
                                          (make-move 'circ (make-vel 5 -1)))
                     (make-collisionEvent (make-collision 'circ 'rect )
                                          (make-stop 'circ))
;                     (make-collisionEvent (make-collision 'circ 'newRect)
;                                          (make-jumpOnce 'circ))
                     (make-collisionEvent (make-collision 'circ 'newRect)
                                          (make-stop 'circ ))

                     ))))





;;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ INTERPRETER
(define HEIGHT 500)
(define WIDTH 500)
  ;;animation -> void
  (define (runAnimation animation)
    (let ([world (runList (animation-listCmd animation) (make-world empty empty empty))])
      (begin
        (big-bang WIDTH HEIGHT 1/28 true)
        (runWorld world))))
  
  ;; world -> void 
  (define (runWorld world)
    
    (begin
      
      (drawWorld world)
      (sleep/yield .25)
      (runWorld (doActions (doCollisions world)))
      
      
      ))
  
  
  
  ;;~~~~~~~~~~~~~~~~~~~~~~~~ Collisions:
  ;; findCollisions (world -> listCollisions)
  ;; Docollision: (world) -> world
  (define (doCollisions world)
    (let ([collList (findCollisions (world-listShapes world))])
      (doCollisionsList collList world)))
  
  
  
  ;;DoCollList list[collision] world -> world
  (define (doCollisionsList collList world)
    (cond [(empty? collList) world]
          [(cons? collList) (doCollisionsList (rest collList)
                                              (runList (map collisionEvent-cmd
                                                            (filter (lambda (a-colEvent)
                                                                      (equal? (collisionEvent-collision a-colEvent)
                                                                              (first collList)))
                                                                    (world-listEvents world)))
                                                       world))]))
  
  
  
  (check-expect (doCollisionsList (list (make-collision 'a 'b))
                                  (make-world empty (list
                                                     (make-collisionEvent
                                                      (make-collision 'a 'b)
                                                      (addShape (make-shape '1 (make-posn 0 0) (circle 5 "solid" "green")))))
                                              empty))
                (make-world (list
                             (make-shape '1 (make-posn 0 0 ) (circle 5 "solid" "green")))
                            (list
                             (make-collisionEvent
                              (make-collision 'a 'b)
                              (addShape (make-shape '1 (make-posn 0 0) (circle 5 "solid" "green")))))
                            empty))
  
  ;; need this fun to search through list events, add list of events that need to be done, then runcmd list of active events
  ;; (runcmdlist (getCollisionEvents (find Collisions)) world)
  
  ;; findCollisions: (list Shapes) -> (hasCollision shape list)
  ;;                                   (if shape = (first list) -> skip over)
  ;;                                    build list of collisions
  
  
  ;; findCollisions: list[shape] -> list[collision] 
  ;; gives back list of all collisions
  ;; note: objects always will collide with themselves and give an extra collision
  (define (findCollisions listShapes)
    (let ([all-collisions (map (lambda (a-shape) (findCollisionsShape a-shape listShapes))
                               listShapes)])
      (begin
        (print (flattenListOfList all-collisions ))
        (flattenListOfList all-collisions))))
  (check-expect (findCollisions (list (make-shape '1 (make-posn 0 0 ) (circle 3 "solid" "blue"))
                                      (make-shape '2 (make-posn 0 0 ) (circle 3 "solid" "blue"))))
                (list (make-collision '1 '1)
                      (make-collision '1 '2)
                      (make-collision '2 '1)
                      (make-collision '2 '2)))
  (check-expect (findCollisions (list (make-shape '1 (make-posn 0 0 ) (circle 3 "solid" "blue"))
                                      (make-shape '2 (make-posn 10 10 ) (circle 3 "solid" "blue"))))
                (list (make-collision '1 '1)
                      (make-collision '2 '2)))
  
  ;; findCollisionsShape: shape list[shape] -> list[collision]
  ;; returns the list of collisions one shape has with the rest of the shapes
  (define (findCollisionsShape shape listShapes)
    (map (lambda (a-shape) (make-collision (shape-name shape) (shape-name a-shape)))
         (filter (lambda (a-shape) (and (not (equal? shape a-shape))
                                             (doCollide shape a-shape)))
                 listShapes)))
  (check-expect (findCollisionsShape (make-shape '1 (make-posn 0 0 ) (circle 3 "solid" "blue"))
                                     (list (make-shape '2 (make-posn 0 0 ) (circle 3 "solid" "blue"))
                                           (make-shape '3 (make-posn 0 0 ) (circle 3 "solid" "blue"))))
                (list (make-collision '1 '2)
                      (make-collision '1 '3)))
  (check-expect (findCollisionsShape (make-shape '1 (make-posn 0 0 ) (circle 3 "solid" "blue"))
                                     (list (make-shape '2 (make-posn 10 10 ) (circle 3 "solid" "blue"))
                                           (make-shape '3 (make-posn 0 0 ) (circle 3 "solid" "blue"))))
                (list (make-collision '1 '3)))
  
  (define (doCollide shape1 shape2)  
    (let ([shape1Left (posn-x (shape-posn shape1))]
          [shape1Right (getRight shape1)]
          [shape1Top (posn-y (shape-posn shape1))]
          [shape1Bottom (getBottom shape1)]
          [shape2Left (posn-x (shape-posn shape2))]
          [shape2Right (getRight shape2)]
          [shape2Top (posn-y (shape-posn shape2))]
          [shape2Bottom (getBottom shape2)]
          )
      ;; x overlap:
      (and (< shape1Left shape2Right)
           (> shape1Right shape2Left)
           (< shape1Top shape2Bottom)
           (> shape1Bottom shape2Top))))
  
  (check-expect (doCollide (make-shape '1 (make-posn 0 0 ) (circle 3 "solid" "blue"))
                           (make-shape '1 (make-posn 0 0 ) (circle 3 "solid" "blue")))
                true)
  (check-expect (doCollide (make-shape '1 (make-posn 10 0 ) (circle 3 "solid" "blue"))
                           (make-shape '1 (make-posn 0 0 ) (circle 3 "solid" "blue")))
                false)
  (define (getRight shape)        
    (+(posn-x(shape-posn shape)) (image-width(shape-image shape))))
  ;;(define (getBottom shape) ENDING HERE
  
  
  (check-expect (getRight (make-shape 'name (make-posn 0 0) (circle 5 "solid" "green")))
                10)
  (define (getBottom shape)
    (+ (posn-y(shape-posn shape)) (image-height (shape-image shape))))
  (check-expect (getBottom (make-shape 'name (make-posn 0 0 ) (circle 5 "solid" "green")))
                10)
  
  ;; FlattenListOfList: list[list[?]] -> list[?]
  (define (flattenListOfList list)
    (cond [(empty? list) empty]
          [(cons? list ) (append (first list) (flattenListOfList (rest list)))]))
  (check-expect (flattenListOfList (list (list 1 2 3) (list 4 5 6)))
                (list 1 2 3 4 5 6))
  ;;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Do Actions
  
  (define (doActions world)
    (doActionsList (world-listActions world) world))
  
  
  (define (doActionsList list world)
    (cond [(empty? list) world]
          [(cons? list)(doActionsList (rest list) (doAction (first list) world))]))
  
  
  
  (check-expect (doActionsList (list(make-move 'circ (make-vel 5 5)))
                               
                               (make-world (list (make-shape 'circ (make-posn 0 0) (circle 1 "solid" "green")))
                                           empty empty))
                (make-world (list (make-shape 'circ (make-posn 5 5) (circle 1 "solid" "green"))) 
                            empty empty))
  
  ;; action world -> world after action 
  (define (doAction action world)
    (cond [(move? action) (doMove action world)]
          [(jump? action) (doJump (jump-shapeName action) world)]))
  
  (check-expect (doAction (make-move 'circ (make-vel 5 5))
                          (make-world (list (make-shape 'circ (make-posn 0 0) (circle 1 "solid" "green")))
                                      empty empty))
                (make-world (list (make-shape 'circ (make-posn 5 5) (circle 1 "solid" "green"))) 
                            empty empty))
  ;; doJump: symbol world -> world
  
  (define (doJump name world)
    (let ([thisShape (findShape name (world-listShapes world))])
      (cond [(shape? thisShape)
             (make-world
              (cons (make-shape name (randomPosition) (shape-image thisShape))
                    (removeShapeFromList name (world-listShapes world)))
              (world-listEvents world)
              (world-listActions world))]
            [else world])))
  

;;TODO

  ;; randomPosiion : void -> position
(define (randomPosition)
  (make-posn (random WIDTH (current-pseudo-random-generator))
             (random HEIGHT (current-pseudo-random-generator))))
  
  ;; doMove world -> world
  (define (doMove move world)
    (let ([thisShape  (findShape (move-shapeName move) (world-listShapes world))])
      (cond [(shape? thisShape)
             (make-world
              (cons (moveShape thisShape (move-vel move))
                    (removeShapeFromList (shape-name thisShape) (world-listShapes world)))
              (world-listEvents world)
              (world-listActions world))]
            [else world]))) 
  
  (check-expect (doMove (make-move 'circ (make-vel 5 5))
                        (make-world (list (make-shape 'circ (make-posn 0 0) (circle 1 "solid" "green")))
                                    empty
                                    empty))
                (make-world (list (make-shape 'circ (make-posn 5 5) (circle 1 "solid" "green"))) 
                            empty empty))
  
  
  ;; name list[shape] -> shape 
  (define (findShape name list)
    (let ([shape (filter (lambda (aShape) (symbol=? name (shape-name aShape))) list)]) 
      (cond [(cons? shape)(first shape)]
            [else void]))) 
  
  (check-expect (findShape 'circ (list (make-shape 'circ (make-posn 0 0 ) (circle 1 "solid" "blue"))))
                (make-shape 'circ (make-posn 0 0 ) (circle 1 "solid" "blue")))
  
  ;; list -> list
  (define (removeShapeFromList name list)
    (cond [(empty? list) empty]
          [(cons? list )
           (cond [(symbol=? name (shape-name (first list)))
                  (rest list)]
                 [else (cons (first list)
                             (removeShapeFromList name (rest list)))])]))
  
  
  (check-expect (removeShapeFromList 'testing
                                     (list
                                      (make-shape 'test (make-posn 0 0) (circle 1 "solid" "blue" )) 
                                      (make-shape 'testing void void)))
                (list (make-shape 'test (make-posn 0 0) (circle 1 "solid" "blue" )))) 
  ;; shape -> shape
  (define (moveShape shape vel)
    (make-shape (shape-name shape)
                (make-posn (+ (posn-x (shape-posn shape)) (vel-x vel)) 
                           (+ (posn-y (shape-posn shape)) (vel-y vel)))
                (shape-image shape)))
  
  (check-expect (moveShape  (make-shape 'circ (make-posn 0 0 ) (circle 1 "solid" "blue")) (make-vel 5 5 ))
                (make-shape 'circ (make-posn 5 5  ) (circle 1 "solid" "blue")))
  ;;~~~~~~~~~~~~~~~~~~~~~~~~~DRAWING
  
  ;; (world-> void)
  ;; gives the image of the world 
  (define (drawWorld world) 
    (update-frame (drawList (world-listShapes world)))) 
  ;; list -> image
  (define (drawList list)
    (cond[(empty? list) (empty-scene WIDTH HEIGHT)]
         [(cons? list)
          (place-image (shape-image (first list))
                       (posn-x (shape-posn (first list)))
                       (posn-y (shape-posn (first list)))
                       (drawList (rest list)))]))
  ;;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~HELPER FUN
  ;; an action is either
  ;;    - (make-move symbol(name) vel)
  ;;    - (make-jump symbol(name) )
  ;;    - (make-jumpOnce symbol(name) )
  (define (action? cmd)
    (or (move? cmd)
        (jump? cmd)
        (jumpOnce? cmd)))
  
  
  ;;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~MAKING WORLD
  ;; an event is either :
  ;;    - (make-make-CollisionEvent collision cmd)
  
  ;; (make-struct list[shapes] list[events] list[actions]
  (define-struct world (listShapes listEvents listActions) (make-inspector))
  
  
  
  
  ;; gives back the  
  (define (runList a-list old-world)
    (cond [(empty? a-list) old-world]
          [(cons? a-list)
           (let ([L1 (first a-list)])
             ;;                   adds rest of elements in list, to the world that contains the current element
             (cond [(addShape?  L1) (runList (rest a-list) (addShapeToList (addShape-shape L1) old-world))]
                   [(collisionEvent? L1) (runList (rest a-list) (addEventToList L1 old-world))]
                   [(action? L1)(runList (rest a-list) (addActionToList L1 old-world))]
                   [else (runList (rest a-list) (executeCommand L1 old-world))]))])) ;;TODO
  
  (define (executeCommand command world)
    (cond [(removeShape? command) (make-world
                                   (removeShapeFromList (removeShape-shapeName command) (world-listShapes world))
                                   (world-listEvents world)
                                   (world-listActions world))]
          [(jumpOnce? command) (doJump (jumpOnce-shapeName command) world)]
                                
          [(stop? command) (make-world
                            (world-listShapes world)
                            (world-listEvents world)
                            (filter (lambda (cmd) (not (symbol=? (cond [(move? cmd) (move-shapeName cmd)]
                                                                       [(jump? cmd) (jump-shapeName cmd)]
                                                                       [else 'false])
                                                                 (stop-shapeName command))))
                                    (world-listActions world)))]))


  (check-expect (executeCommand (make-stop 'a) (make-world empty empty (list (make-move 'ab (make-vel 1 1)) (make-move 'a (make-vel 1 1))
                                                                             (make-jump 'a))))
                (make-world empty empty (list (make-move 'ab (make-vel 1 1)))))
  (check-expect (executeCommand (make-removeShape 'a) (make-world (list (make-shape 'a (make-posn 1 1 ) (circle 5 "solid" "green")))
                                                                  empty
                                                                  empty))
                (make-world empty empty empty))
(check-expect (executeCommand (make-jumpOnce 'a) (make-world (list (make-shape 'a (make-posn 1 1) (circle 1 "solid" "green")))
                                                             empty empty))
              (make-world empty empty empty))
  
  ;; (shape world -> world)
  ;; adds a shape to a world
  (define (addShapeToList shape old-world)
    (make-world (cons shape (world-listShapes old-world)) (world-listEvents old-world) (world-listActions old-world)))
  
  ;; (collisionEvent world -> world
  ;; adds collision event to worl
  (define (addEventToList event old-world)
    (make-world  (world-listShapes old-world)
                 (cons event (world-listEvents old-world))
                 (world-listActions old-world)))
  
  ;; (action world -> world) 
  ;; adds action to world
  (define (addActionToList action old-world)
    (make-world  (world-listShapes old-world)
                 (world-listEvents old-world)
                 (cons action (world-listActions old-world))))
  
  
  
  
  
  
  ;;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ testing
  (define TEST_ANIMATION (make-animation (list
                                          (make-addShape
                                           (make-shape 'shape (make-posn 1 1 )
                                                       (circle 1 "solid" "green")))
                                          (make-collisionEvent null null)
                                          (make-move 'shape (make-vel 1 1 )))))
  
  (check-expect (runList (animation-listCmd TEST_ANIMATION) (make-world empty empty empty))
                (make-world (list (make-shape 'shape (make-posn 1 1)
                                              (circle 1 "solid" "green")))
                            (list (make-collisionEvent null null))
                            (list (make-move 'shape (make-vel 1 1)))))
  
  
  
  
  
  
  
  
  (test)