;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname assign3) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; CMPU-101 
; Fall 2018
; Assign 3
; <your name> 
;
; Description: Uses a list of bouncing balls to animate many balls
; of different sizes and colors, all moving in the same scene at 
; different speeds.

(require 2htdp/image) 
(require 2htdp/universe)

(define RADIUS 25)

; Scene dimensions
(define WIDTH 500)
(define HEIGHT 300)

; Create the background scene image
(define BACKGROUND
  (place-image (rectangle WIDTH HEIGHT "solid" "lightgray")
               (/ WIDTH 2) (/ HEIGHT 2)
               (empty-scene WIDTH HEIGHT)))

; Data Definitions 
(define-struct ball (im x y dx dy))
; A ball is a (make-ball im p dx dy) where
; im is an image (of the ball), 
; x and y are numbers representing the ball's position, and
; dx and dy are numbers representing the ball's horizontal and 
;   vertical velocity

; Data Definition for a list-of-balls:
; A list-of-balls is either:
; 1. '(), or
; 2. (cons b lob), where b is a ball
;    and lob is a list-of-balls

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Define four (4) example ball CONSTANTS:
;   one touching each edge of the scene (top, bottom, left, right)
;   These will help you test bounce conditions.

; here's one of my ball CONSTANTS, which you may use or modify
; if you like to define the rest.

(define BALL-ON-LEFT 
  (make-ball (circle (+ RADIUS 4) "solid" "teal")
             (+ RADIUS 4) (/ HEIGHT 2) -5 4))

(define BALL-ON-RIGHT
  (make-ball (circle (- RADIUS 10) "solid" "red")
             (- WIDTH (- RADIUS 10)) (/ HEIGHT 2) 5 5))

(define BALL-ON-TOP
  (make-ball (circle (- RADIUS 5) "solid" "blue")
             (/ WIDTH 2) (- RADIUS 5) -2 -2))

(define BALL-ON-BOTTOM
  (make-ball (circle RADIUS "solid" "purple")
             (/ WIDTH 2) (- HEIGHT RADIUS) 6 6))

; Define INIT-LOB to be a list-of-balls:
; You will use this to be the initial state of the world.
; I've defined it to be the empty list, but you should define it
; to contain the four example ball CONSTANTS you just defined. 
(define INIT-LOB
  (list BALL-ON-LEFT BALL-ON-RIGHT BALL-ON-TOP BALL-ON-BOTTOM)) 


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Templates for a ball and a list-of-balls.
; Use these to help you get started with the functions below.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; ball -> ???
; Template for a function that consumes a ball

;(define (fun-for-ball b) 
;  (...(ball-im b)...
;   ...(ball-x b)...(ball-y b)...
;   ...(ball-dx b)...(ball-dy b)...))

; list-of-balls -> ???
; Template for a function that consumes a list-of-balls

;(define (fun-for-list-of-balls lob) 
;  (cond
;    [(empty? lob)...] 
;    [else (...(fun-for-ball (first lob))...
 ;          ...(fun-for-lob (rest lob))...)]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Design the functions below, in order. I've supplied the
; signature, purpose statement, and header for each function.
;
; You provide the check-expect examples, and using the appropriate
; template, complete the function bodies.
;
; I recommend you proceed in order, and complete each function,
; with passing tests, before going on to the next.
;
; The reason for completing the functions in the order they appear
; is earlier functions can be used as helper functions for the
; later functions.
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; ball -> number
; computes the radius of given ball
(define (ball-radius b) (/ (image-height (ball-im b)) 2))

(check-expect (ball-radius BALL-ON-TOP) 20)
(check-expect (ball-radius BALL-ON-RIGHT) 15)
(check-expect (ball-radius BALL-ON-BOTTOM) 25)
(check-expect (ball-radius BALL-ON-LEFT) 29)

; ball -> boolean
; determines whether the ball reached the top edge of scene
;(define (top-edge? b) ...)
(define (top-edge? b) (<= (ball-y b) (ball-radius b)))

(check-expect (top-edge? BALL-ON-TOP) #true)
(check-expect (top-edge? BALL-ON-BOTTOM) #false)

; ball -> boolean
; determines whether the ball reached the bottom edge of scene
;(define (bottom-edge? b) ...)
(define (bottom-edge? b) (<= (- 300 (ball-y b)) (ball-radius b)))

(check-expect (bottom-edge? BALL-ON-BOTTOM) #true)
(check-expect (bottom-edge? BALL-ON-TOP) #false)

; ball -> boolean
; determines whether the ball reached the left edge of scene
;(define (left-edge? b) ...)
(define (left-edge? b) (<= (ball-x b) (ball-radius b)))

(check-expect (left-edge? BALL-ON-LEFT) #true)
(check-expect (left-edge? BALL-ON-RIGHT) #false)

; ball -> boolean
; determines whether the ball reached the right edge of scene
;(define (right-edge? b) ...)
(define (right-edge? b) (<= (- 500 (ball-x b)) (ball-radius b)))

(check-expect (right-edge? BALL-ON-RIGHT) #true)
(check-expect (right-edge? BALL-ON-LEFT) #false)

; ball -> ball
; reverse ball's up-down direction   
;(define (reverse-up-down b) ...)
(define (reverse-up-down b) (make-ball (ball-im b) (ball-x b) (ball-y b) (ball-dx b) (* -1 (ball-dy b))))

(check-expect (reverse-up-down BALL-ON-TOP) (make-ball (circle (- RADIUS 5) "solid" "blue")
             (/ WIDTH 2) (- RADIUS 5) -2 2))
(check-expect (reverse-up-down (make-ball (circle (- RADIUS 5) "solid" "blue") (/ WIDTH 2) (- RADIUS 5) 20 -22))
              (make-ball (circle (- RADIUS 5) "solid" "blue") (/ WIDTH 2) (- RADIUS 5) 20 22)) 

; ball -> ball
; reverse ball's left-right direction   
;(define (reverse-left-right b) ...)
(define (reverse-left-right b) (make-ball (ball-im b) (ball-x b) (ball-y b) (* -1 (ball-dx b)) (ball-dy b)))

(check-expect (reverse-left-right BALL-ON-TOP) (make-ball (circle (- RADIUS 5) "solid" "blue")
             (/ WIDTH 2) (- RADIUS 5) 2 -2))
(check-expect (reverse-left-right (make-ball (circle (- RADIUS 5) "solid" "blue") (/ WIDTH 2) (- RADIUS 5) -32 25))
              (make-ball (circle (- RADIUS 5) "solid" "blue") (/ WIDTH 2) (- RADIUS 5) 32 25))

; ball -> ball
; changes direction of given ball if it hit the top or bottom edge
;(define (bounce-up-down b) ...)
(define (bounce-up-down b)
  (cond
    [(top-edge? b) (reverse-up-down b)]
    [(bottom-edge? b) (reverse-up-down b)]
    [else (make-ball (ball-im b) (ball-x b) (ball-y b) (ball-dx b) (ball-dy b))]))

(check-expect (bounce-up-down BALL-ON-TOP) (make-ball (circle (- RADIUS 5) "solid" "blue")
             (/ WIDTH 2) (- RADIUS 5) -2 2))
(check-expect (bounce-up-down  (make-ball (circle RADIUS "solid" "purple") (/ WIDTH 2) (- HEIGHT RADIUS) 6 6))
               (make-ball (circle RADIUS "solid" "purple") (/ WIDTH 2) (- HEIGHT RADIUS) 6 -6))
(check-expect (bounce-up-down (make-ball (circle (- RADIUS 10) "solid" "red") (- WIDTH (- RADIUS 10)) (/ HEIGHT 2) 5 5))
              (make-ball (circle (- RADIUS 10) "solid" "red") (- WIDTH (- RADIUS 10)) (/ HEIGHT 2) 5 5))
; ball -> ball
; changes direction of given ball if it hit the left or right edge
;(define (bounce-left-right b) ...)
(define (bounce-left-right b)
  (cond
    [(right-edge? b) (reverse-left-right b)]
    [(left-edge? b) (reverse-left-right b)]
    [else (make-ball (ball-im b) (ball-x b) (ball-y b) (ball-dx b) (ball-dy b))]))

(check-expect (bounce-left-right BALL-ON-RIGHT) (make-ball (circle (- RADIUS 10) "solid" "red")
             (- WIDTH (- RADIUS 10)) (/ HEIGHT 2) -5 5))
(check-expect (bounce-left-right (make-ball (circle (+ RADIUS 4) "solid" "teal") (+ RADIUS 4) (/ HEIGHT 2) -5 4))
              (make-ball (circle (+ RADIUS 4) "solid" "teal") (+ RADIUS 4) (/ HEIGHT 2) 5 4))
(check-expect (bounce-left-right (make-ball (circle (- RADIUS 5) "solid" "blue") (/ WIDTH 2) (- RADIUS 5) -2 2))
              (make-ball (circle (- RADIUS 5) "solid" "blue") (/ WIDTH 2) (- RADIUS 5) -2 2))

; ball -> ball
; moves the given ball by its dx and dy amounts
;(define (move-ball b) ...)
(define (move-ball b) (make-ball (ball-im b) (+ (ball-x b) (ball-dx b)) (+ (ball-y b) (ball-dy b)) (ball-dx b) (ball-dy b)))

(check-expect (move-ball BALL-ON-TOP) (make-ball (circle (- RADIUS 5) "solid" "blue")
             248 18 -2 -2))
(check-expect (move-ball (make-ball (circle (- RADIUS 10) "solid" "red") 485 150 5 5))
              (make-ball (circle (- RADIUS 10) "solid" "red") 490 155 5 5))
(check-expect (move-ball (make-ball (circle 15 "solid" "red") 485 150 -5 -5))
              (make-ball (circle 15 "solid" "red") 480 145 -5 -5))
(check-expect (move-ball (make-ball (circle 15 "solid" "red") 485 150 5 -5))
              (make-ball (circle 15 "solid" "red") 490 145 5 -5))
(check-expect (move-ball (make-ball (circle 15 "solid" "red") 485 150 -5 5))
              (make-ball (circle 15 "solid" "red") 480 155 -5 5))

; list-of-balls -> list-of-balls
; moves (and possibly bounces) each ball in given list
;(define (move-list-of-balls lob) ...)
(define (move-list-of-balls lob) 
  (cond
    [(empty? lob) '()] 
    [(cons? lob) (cons (move-ball (bounce-left-right (bounce-up-down (first lob)))) (move-list-of-balls (rest lob)))]))

(check-expect (move-list-of-balls (list (make-ball (circle 15 "solid" "red") 250 150 5 5)
                                        (make-ball (circle 15 "solid" "red") 250 150 -5 5)
                                        (make-ball (circle 15 "solid" "red") 250 150 5 -5)
                                        (make-ball (circle 15 "solid" "red") 250 150 -5 -5)))
         (list(make-ball (circle 15 "solid" "red") 255 155 5 5)
              (make-ball (circle 15 "solid" "red") 245 155 -5 5)
              (make-ball (circle 15 "solid" "red") 255 145 5 -5)
              (make-ball (circle 15 "solid" "red") 245 145 -5 -5)))
(check-expect (move-list-of-balls (list (make-ball (circle 15 "solid" "red") 485 150 5 5)
                                        (make-ball (circle 15 "solid" "red") 250 150 -5 5)
                                        (make-ball (circle 15 "solid" "red") 485 150 5 -5)
                                        (make-ball (circle 15 "solid" "red") 485 150 -5 -5)))
         (list(make-ball (circle 15 "solid" "red") 480 155 -5 5)
              (make-ball (circle 15 "solid" "red") 245 155 -5 5)
              (make-ball (circle 15 "solid" "red") 480 145 -5 -5)
              (make-ball (circle 15 "solid" "red") 490 145 5 -5)))
(check-expect (move-list-of-balls (list (make-ball (circle 15 "solid" "red") 250 285 5 5)
                                        (make-ball (circle 15 "solid" "red") 250 285 -5 5)
                                        (make-ball (circle 15 "solid" "red") 250 150 5 -5)
                                        (make-ball (circle 15 "solid" "red") 250 285 -5 -5)))
         (list(make-ball (circle 15 "solid" "red") 255 280 5 -5)
              (make-ball (circle 15 "solid" "red") 245 280 -5 -5)
              (make-ball (circle 15 "solid" "red") 255 145 5 -5)
              (make-ball (circle 15 "solid" "red") 245 290 -5 5)))
              
; ball image -> image
; renders given ball b on given background bg
(define (render-ball b bg) (place-image (ball-im b) (ball-x b) (ball-y b) bg))
                                         
; list-of-balls -> image 
; produces image of each ball at each given current position on
; background.
; (Yes, I provided this function for you! You shouldn't have to
;  touch it if you've correctly implemented the functions above.)
(define (render-balls lob) 
  (cond [(empty? lob) BACKGROUND]
        [else (render-ball (first lob)
                           (render-balls (rest lob)))]))

; Here's the main function with the big-bang expression!
; Once you've implemented move-list-of-balls, uncomment on-tick below.
(define (main w)
  (big-bang w
            (on-tick move-list-of-balls 1/28) 
            (to-draw render-balls)))

; Run program automatically, or type this in Interactions Pane:
; Use INIT-LOB as the initial state of the world...
(main INIT-LOB)