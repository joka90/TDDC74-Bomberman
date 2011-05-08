;(load "paint-tools.ss")
(require scheme/date);; for timestamps in bombs
(require racket/string);; for image loading
(load "help-classes.ss");; small helpclasses from lists etc.
(load "draw-class.ss")
(load "image-store.ss")
(load "player-class.ss")
(load "game-board-class.ss")
(load "user-interact.ss")
(load "game-logic.ss")
(load "powerup-class.ss")
(load "bomb-class.ss")
(load "flame-class.ss")
(load "gui-class.ss")
(load "main-loop.ss")
(load "timer-class.ss")


;; ---------------------------------------------------------------------
;; global objects just for testing
;; ---------------------------------------------------------------------

(define *blocksize* 30)


(define *image-store*
  (new make-image-store%))
;;http://www.spriters-resource.com/snes/S.html
(send *image-store* add-image 'red-player '((r . ("img/red-player/r-" ".png" 5))
                                            (l . ("img/red-player/l-" ".png" 5))
                                            (u . ("img/red-player/u-" ".png" 5))
                                            (d . ("img/red-player/d-" ".png" 5))))

(send *image-store* add-image 'blue-player '((r . ("img/blue-player/r-" ".png" 5))
                                             (l . ("img/blue-player/l-" ".png" 5))
                                             (u . ("img/blue-player/u-" ".png" 5))
                                             (d . ("img/blue-player/d-" ".png" 5))))




(send *image-store* add-image 'bomb-1 "img/bomb1.png")
(send *image-store* add-image 'bomb-2 "img/bomb2.png")

(send *image-store* add-image 'flame-big '((r . "img/flame-big-h.png")
                                           (l . "img/flame-big-h.png")
                                           (u . "img/flame-big-v.png")
                                           (d . "img/flame-big-v.png")))

(send *image-store* add-image 'flame-small '((r . "img/flame-small-h.png")
                                             (l . "img/flame-small-h.png")
                                             (u . "img/flame-small-v.png")
                                             (d . "img/flame-small-v.png")))

(send *image-store* add-image 'powerup-multi-bomb "img/max-image.png")
(send *image-store* add-image 'powerup-speed "img/speed-powerup.png")
(send *image-store* add-image 'powerup-stronger-bomb "img/power-image.png")
(send *image-store* add-image 'non-dest-block "img/non-dest-block.png")
(send *image-store* add-image 'dest-block "img/dest-block.png")
(send *image-store* add-image 'bg "img/bg.png")

;; ---------------------------------------------------------------------
;; game logic
;; ---------------------------------------------------------------------
(define (*current-sec*)
  (send main-loop get-current-sec))

(define test-logic
  (new game-logic%
       [height 21]
       [width 21]
       [height-px 630]
       [width-px 630]))

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
;;(add-key-board-player new-name x y dxy number-of-lives color keybord-bindings)
;;palyer 1 
(send test-logic add-key-board-player "jocke" 1 1 10 5 'blue-player 
      '((#\w . u)
        (#\a . l)
        (#\s . d)
        (#\d . r)
        (#\q . drop)))
;;palyer 2
(send test-logic add-key-board-player "pocke" 19 19 10 5 'blue-player 
      '((#\i . u)
        (#\j . l)
        (#\k . d)
        (#\l . r)
        (#\b . drop)))

(send test-logic add-key-board-player "tocke" 1 19 10 5 'red-player 
      '((up . u)
        (left . l)
        (down . d)
        (right . r)
        (#\0 . drop)
        (numpad0 . drop)))

(send test-logic add-key-board-player "focke" 19 1 10 5 'red-player 
      '((#\8 . u)
        (#\4 . l)
        (#\5 . d)
        (#\6 . r)
        (#\7 . drop)
        (numpad8 . u)
        (numpad4 . l)
        (numpad5 . d)
        (numpad6 . r)
        (numpad7 . drop)))

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
       [function-to-loop draw]
       [fps 24]));; anropar draw spec i update-graphic

;(play-sound "sound/bg_music.mp3" #f)
(send main-loop start-loop);; startar loopen
