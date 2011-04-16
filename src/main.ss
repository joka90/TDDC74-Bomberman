;(load "paint-tools.ss")
(require scheme/date)
(load "draw-class.ss")
(load "player-class.ss")
(load "stone-class.ss")
(load "user-interact.ss")
(load "game-logic.ss")
;(load "update-graphic.ss")
(load "gui-class.ss")
(load "main-loop.ss")

;; ---------------------------------------------------------------------
;; The main globalbitmap *draw* and gui
;; ---------------------------------------------------------------------
(define *draw*
  (new make-draw%
       [width 500]
       [height 500]))

(define *gui*
  (new make-gui%
       [window-name "New gui!"]
       [width 500]
       [height 500]
       [image-buffer *draw*]
       ))

;; ---------------------------------------------------------------------
;; global objects
;; ---------------------------------------------------------------------
(define test-player
  (new player%
       [x-pos 30]
       [y-pos 30]
       [dxdy 3]
       [name "kalle"]))

(define stone
  (new stone%
       [x-pos 100]
       [y-pos 100]))

(define stone2
  (new stone%
       [x-pos 200]
       [y-pos 100]))

(define stone3
  (new stone%
       [x-pos 250]
       [y-pos 150]))

(define stone4
  (new stone%
       [x-pos 100]
       [y-pos 300]))


;; global lists to track objects
(define objects (list stone stone2 stone3 stone4))

(define players (list test-player))

;; ---------------------------------------------------------------------
;; game logic
;; ---------------------------------------------------------------------

(define test-logic
  (new game-logic%
       [height 500]
       [width 500]
       [players-to-track players]
       [objects-to-track objects]))


;; Handle keys pressd
;; Skickar vidare till gamelogic som det är nu, ska flyttas till bättre ställe?
(define keys '((#\w . u)
               (#\a . l)
               (#\s . d)
               (#\d . r)))
;(cadr (assq key keys))
(define (handle-key-event key)
  (let((action (assq key keys)))
    (if action
        (send test-logic move-dir (cdr action) test-player))))


;; The procedures that redraws the scene form the main-thread.
(define (draw)
  (send *draw* clear)
  (send test-logic update-scene *draw*)
  ;(send *draw* background)
  (send *gui* redraw))


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
