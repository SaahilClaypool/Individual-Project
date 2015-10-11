
;;Saahil Claypool Individual Project

#|     NOTE: This is more of a simulation than an animation. Professor Rich said this was fine.

1. To run an animation, type (runAnimation animationA) into the interactions window. The pre-defined animations are
     - animationA
     - animationB
     - animationC

2. This is more of a simulation than an animation. This means the collisions and actions are event driven rather than executed in a pre set list. To create an animation, a user describes what he or she wants to happen objects hit things. Movements then proceed until any of those collisions happen. 
   This language includes macros, collisions, events for each collision and the basic commands such as move jump and delete.
The language fails when objects remain in contact with eachother after a collision. For example, if a circle hits a rectangle then moves sideways along the rectangle, it will register as a collision each time it moves, and repeat the collision event.

3. In my desing phase, I planned on making different shapes different structures. For example, I would have a circleObject structure and a rectangleObject structure. I changed the shape definition to instead just take in an image of either a circle or a rectangle. Having two structures for shapes made it harder to write the interpreter because each function needed to be branched for both circles and rectangles.
I also had a repeat command that was planned to repeat a certain command or block of commands, but when I implemented the design the actions were implicitly repeated and the explicit repeat command became redundant. I also added a structure named collision to represent collisions and made slight changes to names for clarity.

4. The shapes should hold their own velocity. This would make things like a bounce function that reverses a shape's x velocity or y velocity much less complicated. It is still possible with my implementation, but the code would not be nearly as clean. This also makes the "move" functions more complicated as they now need to find and stop the previous move commands for that shape rather than changing the velocity of an object.
 Additionally, it would better if my collision events took in lists of collisions. This would make creating animations less repatative. (right now a new collision event must be created for each action that a user desires to create after a collision)
addShape may not be a needed command but it may help add clarity. 
|#


(require "world-cs1102.rkt")
(require test-engine/racket-gui)


(circle 5 "solid" "red")
(rectangle 40 80 "solid" "green")


;;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Structure Definitions


;; an animation is a (make-animation list[cmd]
;; takes in a list of commands, creates an animation from this list
(define-struct animation (listCmd) (make-inspector))

;; a shape is a (make-shape symbol posn image)
(define-struct shape(name posn image) (make-inspector) )

;; velocity is a (make-vel int int)
;; creats an x y velocity
(define-struct vel(x y) (make-inspector))
;; posn is (make-posn int int) 
;; creates x y position (pre defined)

;;collision is a (make-collision symbol sybol)
;; represents the collision of two objects
;; collision is (make-collision symbol sybol)
;; a symbol is either a shape name or 'lEdge 'rEdge 'tEdge 'bEdge where each symbol corresponds with the appropriate Edge of the animation

(define-struct collision (shapeName1 shapeName2) (make-inspector))



;;~~~~~~~~~~~~~~~~~~~~~~~~ Macros

;; add: adds circle shape to animation
;; Circle: add circle named name at xLoc yLoc radius rad color c



(define-syntax add
  (syntax-rules (circle rectangle width height named at radius color)
    [(add circle named name at intX intY radius intR color theColor)
     (make-addShape (make-shape 'name (make-posn intX intY) (circle intR "solid" 'theColor)))]
    [(add rectangle named name at intX intY width intW height intH color theColor)
     (make-addShape (make-shape 'name (make-posn intX intY) (rectangle intW intH "solid" 'theColor)))]))


;; addMove: adds move command to a shape
;; (addMove shapeName by int int) -> make-move
(define-syntax addMove
  (syntax-rules (by)
    [(addMove name by intX intY)
     (make-move 'name (make-vel intX intY))]))

;; create: creates an animation
;; (create command ...) -> make (animation list cmd)
(define-syntax create
  (syntax-rules ()
    [(create name fun1 ...)
     (define name (make-animation (list fun1 ...)))]))

;; when: creates collision events 
;; (when shapeName hits shapeName then command) -> (make-collisionsEvent (make-collision symbol symbol)
;;                                                                       command)
(define-syntax when
  (syntax-rules(hits then) 
    [(when name hits name2 then command)
     (make-collisionEvent (make-collision 'name 'name2)
                            command )])) 
;; delete: removes a shape
;;(delete shapeName) -> (make-removeShape symbol) 
(define-syntax delete
  (syntax-rules ()
    [(delete shape)
     (make-removeShape 'shape)]))

;; stopMoving: stops all movement commands for a shape
;; (stopMoving shapeName) -> (make-stop symbol)
(define-syntax stopMoving
  (syntax-rules ()
    [(stopMoving shape)
     (make-stop 'shape)]))
;; jumpOnce: causes shape to jump once
;; (singleJump shapeName) -> (make-jumpOnce symbol)
(define-syntax singleJump
  (syntax-rules ()
    [(singleJump shape)
     (make-jumpOnce 'shape)]))

;; jumpRepeatedly: causes shape to jump every world move
;;(jumpRepeatedly shapeName) -> (make-jump symbol)
(define-syntax jumpRepeatedly
  (syntax-rules ()
    [(jumpRepeatedly shape)
     (make-jump 'shape)]))
;; -------------------------------------------------
;; COMMANDS



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




;; ~~~~~~~~~~~~~~~~~~~~~~~EXAMPLES

;; these examples are created with macros


;; Creats an animation. In this , a circle moves from left to right until it hits a rectangle, it then deletes that rectangle and bounces back
;; until it hits a wall.
(create animationA
        (add circle named circ at 30 30 radius 25 color blue)
        (add rectangle named rect at 300 5 width 25 height 300 color green)
        (addMove circ by 15 3)
        (when circ hits rect then (delete rect))
        (when circ hits rect then (addMove circ by -15 3))
        (when circ hits lEdge then (stopMoving circ)))

;;Creates an animation where a ball jumps randomly accross the screen until comming into contact with an edge 
(create animationB
        (add circle named circ at 100 100 radius 5 color blue)
        (jumpRepeatedly circ)
        (when circ hits tEdge then (stopMoving circ)))

;; Creates an animation with a ball and rectangle. The ball moves down until it hits the rectangle then bounces to the right. The bounce creates a new
;; rectangle to the right, and when the ball hits this it jumps to a random location and stops moving. 
    (create animationC

                     (add circle named circ at 20 20 radius 7 color green)
                     (add rectangle named rect at 5 100 width 100 height 10 color blue)
                     (addMove circ by 0 5)

                     (when circ hits rect then (add rectangle named newRect at 80 80 width 10 height 50 color orange))

                     (when circ hits rect then (addMove circ by 5 -1))

                     
                     (when circ hits newRect then (singleJump circ))
                     (when circ hits newRect then (stopMoving circ))
                     
                     )  

 





;;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ INTERPRETER
;; screen size constants

(define HEIGHT 500)
(define WIDTH 500)


;; runAnimation:  animation -> void
;; creates a world object and starts the running of this world. The world has constants for each edge
(define (runAnimation animation)
  (let ([world (runList (animation-listCmd animation) (make-world (list (make-shape
                                                                         'tEdge (make-posn (* .5 WIDTH) -8) (rectangle (* 2 WIDTH) 20 "solid" "red"))
                                                                        (make-shape
                                                                         'lEdge (make-posn -8 (* .5 HEIGHT)) (rectangle 20 (* 2 HEIGHT) "solid" "red"))
                                                                        (make-shape
                                                                         'rEdge (make-posn ( + 8 WIDTH) (* .5 HEIGHT)) (rectangle 20 (* 2 HEIGHT) "solid" "red"))
                                                                        (make-shape
                                                                         'bEdge (make-posn (* .5 WIDTH) (+ HEIGHT 8)) (rectangle (* 2 WIDTH) 20 "solid" "red")))
                                                                  empty empty))])
    (begin
      (big-bang WIDTH HEIGHT 1/28 true)
      (runWorld world))))

;; runWorld: world -> void
;; runs the world
(define (runWorld world)
  (cond ((empty? (world-listActions world)) (drawWorld world))
  (else
   (begin
     (drawWorld world)
     (sleep/yield .1)
     (runWorld (doActions (doCollisions world)))))))



;;~~~~~~~~~~~~~~~~~~~~~~~~ Collisions:

;; doCollisions: world -> world
;; creates a world after each collision has been resolved
(define (doCollisions world)
  (let ([collList (findCollisions (world-listShapes world))])
    (doCollisionsList collList world)))



;;doCollList: list[collision] world -> world
;; executes list of collisions
(define (doCollisionsList collList world)
  (cond [(empty? collList) world]
        [(cons? collList) (doCollisionsList (rest collList)
                                            (runList (map collisionEvent-cmd
                                                          (filter (lambda (a-colEvent)
                                                                    (equal? (collisionEvent-collision a-colEvent)
                                                                            (first collList)))
                                                                  (world-listEvents world)))
                                                     world))]))


;;testing
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



;; findCollisions: list[shape] -> list[collision] 
;; gives back list of all collisions. note: collisions are order sensitive, collision between 1 and 2 does not equal the collision of 2 and 1

(define (findCollisions listShapes)
  (let ([all-collisions (map (lambda (a-shape) (findCollisionsShape a-shape listShapes))
                             listShapes)])      
    (flattenListOfList all-collisions)))



(check-expect (findCollisions (list (make-shape '1 (make-posn 0 0 ) (circle 3 "solid" "blue"))
                                    (make-shape '2 (make-posn 0 0 ) (circle 3 "solid" "blue"))))
              (list
               (make-collision '1 '2)
               (make-collision '2 '1)
               ))
(check-expect (findCollisions (list (make-shape '1 (make-posn 0 0 ) (circle 3 "solid" "blue"))
                                    (make-shape '2 (make-posn 10 10 ) (circle 3 "solid" "blue"))))
              empty)



;; findCollisionsShape: shape list[shape] -> list[collision]
;; returns the list of collisions one shape has with the rest of the shapes
(define (findCollisionsShape shape listShapes)
  (map (lambda (a-shape) (make-collision (shape-name shape) (shape-name a-shape)))
       (filter (lambda (a-shape) (and (not (equal? shape a-shape))
                                      (doCollide? shape a-shape)))
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


;; doCollide?: shape shape -> boolean 
;; determines of two shapes overlap
(define (doCollide? shape1 shape2)  
  (let ([shape1Left (getLeft shape1)]
        [shape1Right (getRight shape1)]
        [shape1Top (getTop shape1)]
        [shape1Bottom (getBottom shape1)]
        [shape2Left (getLeft shape2)]
        [shape2Right (getRight shape2)]
        [shape2Top (getTop shape2)]
        [shape2Bottom (getBottom shape2)]
        )
    
    (and (< shape1Left shape2Right)
         (> shape1Right shape2Left)
         (< shape1Top shape2Bottom)
         (> shape1Bottom shape2Top))))

(check-expect (doCollide? (make-shape '1 (make-posn 0 0 ) (circle 3 "solid" "blue"))
                         (make-shape '1 (make-posn 0 0 ) (circle 3 "solid" "blue")))
              true)
(check-expect (doCollide? (make-shape '1 (make-posn 10 0 ) (circle 3 "solid" "blue"))
                         (make-shape '1 (make-posn 0 0 ) (circle 3 "solid" "blue")))
              false)
(define (getRight shape)        
  (+(posn-x(shape-posn shape)) (* .5 (image-width(shape-image shape)))))



(check-range (getRight (make-shape 'name (make-posn 0 0) (circle 5 "solid" "green")))
             4.9 5.1)

(define (getBottom shape)
  (+ (posn-y(shape-posn shape)) (* .5 (image-height (shape-image shape)))))

(check-range  (getBottom (make-shape 'name (make-posn 0 0 ) (circle 5 "solid" "green")))
              4.9 5.1)
(define (getTop shape)
  (+ (posn-y(shape-posn shape)) (* -.5 (image-height (shape-image shape)))))

(define (getLeft shape)
  (+ (posn-x(shape-posn shape)) (* -.5 (image-width (shape-image shape)))))
 

;; FlattenListOfList: list[list[?]] -> list[?]
;; turns a 2D list into a 1D list
(define (flattenListOfList list)
  (cond [(empty? list) empty]
        [(cons? list ) (append (first list) (flattenListOfList (rest list)))]))
(check-expect (flattenListOfList (list (list 1 2 3) (list 4 5 6)))
              (list 1 2 3 4 5 6))
;;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Do Actions

;; doActions: world -> world
;; gives back a world after all movements have been resolved
(define (doActions world)
  (doActionsList (world-listActions world) world)
  )

;;doActionsList: list[action] world -> world
;; resolves all movements of a world

(define (doActionsList list world)
  (cond [(empty? list) world]
        [(cons? list)(doActionsList (rest list) (doAction (first list) world))]))



(check-expect (doActionsList (list(make-move 'circ (make-vel 5 5)))
                             
                             (make-world (list (make-shape 'circ (make-posn 0 0) (circle 1 "solid" "green")))
                                         empty empty))
              (make-world (list (make-shape 'circ (make-posn 5 5) (circle 1 "solid" "green"))) 
                          empty empty))

;; doAction: action world -> world
;; gives back the world after a single action 
(define (doAction action world)
  (cond [(move? action) (doMove action world)]
        [(jump? action) (doJump (jump-shapeName action) world)]
        [else world]))

(check-expect (doAction (make-move 'circ (make-vel 5 5))
                        (make-world (list (make-shape 'circ (make-posn 0 0) (circle 1 "solid" "green")))
                                    empty empty))
              (make-world (list (make-shape 'circ (make-posn 5 5) (circle 1 "solid" "green"))) 
                          empty empty))
;; doJump: symbol world -> world
;; executes the jump action. Places shape at random x y location
(define (doJump name world)
  (let ([thisShape (findShape name (world-listShapes world))])
    (cond [(shape? thisShape)
           (make-world
            (cons (make-shape name (randomPosition) (shape-image thisShape))
                  (removeShapeFromList name (world-listShapes world)))
            (world-listEvents world)
            (world-listActions world))] 
          [else world])))




;; randomPosiion : void -> position
;; creates a random position within the bounds
(define (randomPosition)
  (make-posn (random WIDTH (current-pseudo-random-generator))
             (random HEIGHT (current-pseudo-random-generator))))

;; doMove move world -> world
;; executes a move command. Moves shape by a velocity
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
 

;; findShape: name list[shape] -> shape
;; gives back the shape with a given name
(define (findShape name list)
  (let ([shape (filter (lambda (aShape) (symbol=? name (shape-name aShape))) list)]) 
    (cond [(cons? shape)(first shape)]
          [else false]))) 

(check-expect (findShape 'circ (list (make-shape 'circ (make-posn 0 0 ) (circle 1 "solid" "blue"))))
              (make-shape 'circ (make-posn 0 0 ) (circle 1 "solid" "blue")))

;; removeShape: list[shape] -> list[shape]
;; gives back the list of shapes with the given shape removed
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
;; moveShape: shape vel -> shape
;; takes a shape and creates a shape that is moved by the given velocity
(define (moveShape shape vel)
  (make-shape (shape-name shape)
              (make-posn (+ (posn-x (shape-posn shape)) (vel-x vel)) 
                         (+ (posn-y (shape-posn shape)) (vel-y vel)))
              (shape-image shape)))

(check-expect (moveShape  (make-shape 'circ (make-posn 0 0 ) (circle 1 "solid" "blue")) (make-vel 5 5 ))
              (make-shape 'circ (make-posn 5 5  ) (circle 1 "solid" "blue")))
;;~~~~~~~~~~~~~~~~~~~~~~~~~DRAWING

;; drawWorld: (world-> void)
;; gives the image of the world 
(define (drawWorld world)
  (update-frame (drawList (world-listShapes world))))
;; drawList: list[shape] -> image
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
;; action? :  struct -> boolean
;; gives back true if cmd is an action (move or jump)
(define (action? cmd)
  (or (move? cmd)
      (jump? cmd)
      ))


;;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~WORLD


;; world is (make-struct list[shapes] list[events] list[actions]
;; A world is a structure representation of all all the shapes events and actions going on in the animation
(define-struct world (listShapes listEvents listActions) (make-inspector))





;; runList: list[commands] world -> world
;; gives back the world after the list of commands has been run 
(define (runList a-list old-world)
  (cond [(empty? a-list) old-world]
        [(cons? a-list)
         (let ([L1 (first a-list)])
           ;;                   adds rest of elements in list, to the world that contains the current element
           (cond [(addShape?  L1) (runList (rest a-list) (addShapeToList (addShape-shape L1) old-world))]
                 [(collisionEvent? L1) (runList (rest a-list) (addEventToList L1 old-world))]
                 [(action? L1)(runList (rest a-list) (addActionToList L1 old-world))]
                 [else (runList (rest a-list) (executeCommand L1 old-world))]))])) ;;TODO

;; executeCommand: command world -> world
;; gives back the state of the world after a command has been executed
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
                                  (world-listActions world)))]
        [else world]))


(check-expect (executeCommand (make-stop 'a) (make-world empty empty (list (make-move 'ab (make-vel 1 1)) (make-move 'a (make-vel 1 1))
                                                                           (make-jump 'a))))
              (make-world empty empty (list (make-move 'ab (make-vel 1 1)))))
(check-expect (executeCommand (make-removeShape 'a) (make-world (list (make-shape 'a (make-posn 1 1 ) (circle 5 "solid" "green")))
                                                                empty
                                                                empty))
              (make-world empty empty empty))


;; addShapeToList: shape world -> world
;; adds a shape to a world
(define (addShapeToList shape old-world)
  (make-world (cons shape (world-listShapes old-world)) (world-listEvents old-world) (world-listActions old-world)))

;; addEventToList: collisionEvent world -> world
;; adds collision event to world
(define (addEventToList event old-world)
 
   (make-world  (world-listShapes old-world)
               (cons event (world-listEvents old-world))
               (world-listActions old-world)))

;; addActionToList: action world -> world 
;; adds action to world. User helper function and stops any other movement command for the same shape
(define (addActionToList action old-world)
  (addActionToListHelper action (executeCommand (make-stop ((cond
                                                              [(jump? action) jump-shapeName]
                                                              [(move? action) move-shapeName])
                                                            action))
                                                           old-world)))

;; addActionToListHelper: action world -> world
;; helps the addActionToList function
(define (addActionToListHelper action old-world)
  (make-world  (world-listShapes old-world)
               (world-listEvents old-world)
               (cons action (world-listActions old-world))))














