;(load "paint-tools.ss")
(load "draw-class.ss")
(load "player-class.ss")
(load "stone-class.ss")
(load "user-interact.ss")
(load "game-logic.ss")
(load "update-graphic.ss")
(load "gui-class.ss")
(load "main-loop.ss")

(send *draw* clear);; clears buffer in draw
(send *gui* show-gui);; starts gui
(send *draw* background);; change background in draw buffer
(send *gui* redraw);; update canvas


;; ------------------------------------------------------------
;; Main loop
;; ------------------------------------------------------------
(define main-loop
  (new make-loop%
       [function-to-loop draw]))

(send main-loop start-loop)
