;(load "paint-tools.ss")
(require scheme/date);; for timestamps in bombs
(load "draw-class.ss")
(load "image-store.ss")
(load "player-class.ss")
(load "stone-class.ss");; temp
(load "game-board-class.ss")
(load "user-interact.ss")
(load "game-logic.ss")
(load "bomb-class.ss")
(load "gui-class.ss")
(load "main-loop.ss")



;; ---------------------------------------------------------------------
;; global objects just for testing
;; ---------------------------------------------------------------------

(define *blocksize* 30)


;; global lists to track objects
;(define objects (list stone stone2 stone3 stone4))
(define objects '())

;(define players (list test-player))

(define *image-store*
  (new make-image-store%))

(send *image-store* add-image 'red-player '((r . "img/r.bmp")(l . "img/l.bmp")(d . "img/d.bmp")(u . "img/u.bmp")))
(send *image-store* add-image 'blue-player '((r . "img/r.bmp")(l . "img/l.bmp")(d . "img/d.bmp")(u . "img/u.bmp")))
(send *image-store* add-image 'bomb-1 "img/bomb1.png")
(send *image-store* add-image 'bomb-2 "img/bomb2.png")
;;FIX att detta används istället för manuelt

;; ---------------------------------------------------------------------
;; game logic
;; ---------------------------------------------------------------------

(define test-logic
  (new game-logic%
       [height 21]
       [width 21]
       [height-px 630]
       [width-px 630]
       [objects-to-track objects]))

;; ---------------------------------------------------------------------
;; The main globalbitmap *draw* and gui
;; ---------------------------------------------------------------------
(define *draw*
  (new make-draw%
       [width 630];;canvas/bitmaps size
       [height 630])) 

(define *gui*
  (new make-gui%
       [window-name "New gui!"]
       [width 800];;Window size
       [height 630]
       [image-buffer *draw*];;image buffer, the image to load in to the canvas.
       [logic-class test-logic]));; logic class to send key events to


;; ---------------------------------------------------------------------
;; add players
;; ---------------------------------------------------------------------
;;(add-key-board-player new-name x y dxy number-of-lives keybord-bindings)
;;palyer 1 
(send test-logic add-key-board-player "jocke" 1 1 10 5 '((#\w . u)
                                                        (#\a . l)
                                                        (#\s . d)
                                                        (#\d . r)
                                                        (#\q . drop)))
;;palyer 2
(send test-logic add-key-board-player "pocke" 19 19 5 5 '((#\i . u)
                                                            (#\j . l)
                                                            (#\k . d)
                                                            (#\l . r)
                                                            (#\b . drop)))

;; The procedures that redraws the scene form the main-thread.
(define (draw)
  (send *gui* update-keys-down);send keys to gamelogic once a loop.
  (send *draw* clear);; clear bitmap,
  (send test-logic update-scene *draw*);;update bitmap
  ;(send *draw* background)
  (send *gui* redraw));;redraw gui to see the new bitmap


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; END DEFINE ;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ------------------------------------------------------------
;; Alwas do before start
;; ------------------------------------------------------------
(send *draw* clear);; clears buffer in draw
(send *gui* show-gui);; starts gui
(send *draw* background);; change background in draw buffer
(send *gui* redraw);; update canvas

;; ------------------------------------------------------------
;; Main loop
;; ------------------------------------------------------------
(define main-loop
  (new make-loop%
       [function-to-loop draw]));; anropar draw spec i update-graphic

(send main-loop start-loop);; startar loopen
