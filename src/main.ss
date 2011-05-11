;(load "paint-tools.ss")
(require scheme/date);; tid f�r bomber och liknande.
(require racket/string);; f�r att ladda in bilder
(load "help-classes.ss");; sm� hj�lpklasser f�r listor mm.
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
;; globala objekt
;; ---------------------------------------------------------------------

;; Storleken p� blocken i spelplanen
(define *blocksize* 30)

;;Bildinladdningsfunktion s� att det inte ska lagga n�r senare.
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

(send *image-store* add-image 'invincible "img/invincible.png")


(send *image-store* add-image 'bomb-1 "img/bomb1.png")
(send *image-store* add-image 'bomb-2 "img/bomb2.png")

(send *image-store* add-image 'flame-big '((x . "img/flame-big-h.png")
                                           (y . "img/flame-big-v.png")))

(send *image-store* add-image 'flame-small '((x . "img/flame-small-h.png")
                                             (y . "img/flame-small-v.png")))

(send *image-store* add-image 'powerup-multi-bomb "img/max-image.png")
(send *image-store* add-image 'powerup-speed "img/speed-powerup.png")
(send *image-store* add-image 'powerup-stronger-bomb "img/power-image.png")
(send *image-store* add-image 'non-dest-block "img/non-dest-block.png")
(send *image-store* add-image 'dest-block "img/dest-block.png")
(send *image-store* add-image 'bg "img/bg.png")

;; ---------------------------------------------------------------------
;; Spellogik
;; ---------------------------------------------------------------------
(define (*current-m-sec*)
  (send main-loop get-current-m-sec))


;;Skapar en logik m.h.a. spellogiks-klassen
(define bomberman-logic
  (new game-logic%
       [height 21]
       [width 21]
       [height-px 630]
       [width-px 630]))

;; ---------------------------------------------------------------------
;; Globala bitmapsvariabler
;; ---------------------------------------------------------------------
(define *draw*
  (new make-draw%
       [width 800];;canvas-/bitmapsstorlek
       [height 630])) 

(define *status-draw*
  (new make-draw%
       [width 170];;canvas/bitmaps size
       [height 600])) 

(define *gui*
  (new make-gui%
       [window-name "New gui!"]
       [width 800];;f�nsterstorlek
       [height 650]
       [image-buffer *draw*];;bildbuffer, laddar bilden till canvas
       [logic-class bomberman-logic]));; logisk klass att s�nda tangentbords-nedtryckningar till.


;; ---------------------------------------------------------------------
;; L�gga till spelare
;; ---------------------------------------------------------------------
;;(add-key-board-player new-name x y dxy number-of-lives color keybord-bindings)
;;spelare 1
(send bomberman-logic add-key-board-player "jocke" 1 1 10 5 'blue-player 
      '((#\w . u)
        (#\a . l)
        (#\s . d)
        (#\d . r)
        (#\q . drop)))
;;spelare 2
(send bomberman-logic add-key-board-player "pocke" 19 19 10 5 'blue-player 
      '((#\i . u)
        (#\j . l)
        (#\k . d)
        (#\l . r)
        (#\b . drop)))
;;spelare 3
(send bomberman-logic add-key-board-player "tocke" 1 19 10 5 'red-player 
      '((up . u)
        (left . l)
        (down . d)
        (right . r)
        (#\0 . drop)
        (numpad0 . drop)))
;;spelare 4
(send bomberman-logic add-key-board-player "focke" 19 1 10 5 'red-player 
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

;; Procedurerna som ritar om br�dan fr�n huvudtr�den. 
(define (draw)
  (send *gui* update-keys-down);Skicka tangenter till spellogiken en g�ng per loop-varv 
  (send *draw* clear);; rensa bitmap
  (send bomberman-logic update-scene *draw*);;uppdatera bitmap och skicka till main bitmappen
  ;(send *draw* background)
  (send *gui* redraw));; Rita om gui f�r att se nya bitmapen


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; END DEFINE ;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ------------------------------------------------------------
;; G�rs alltid innan start
;; ------------------------------------------------------------
(send *draw* clear);; Rensar buffern som ritar
(send *gui* show-gui);; startar gui
(send *gui* redraw);; updaterar canvas

;; ------------------------------------------------------------
;; Huvudloop
;; ------------------------------------------------------------
(define main-loop
  (new loop-this-proc%
       [function-to-loop draw]
       [fps 24]));; anropar draw spec i update-graphic


(send main-loop start-loop);; startar loopen
