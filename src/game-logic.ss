;; ---------------------------------------------------------------------
;; class game-logic%
;; ---------------------------------------------------------------------


(define game-logic%
  (class object%
    (super-new)
    (init-field height width height-px width-px
                ;players-to-track 
                objects-to-track)
    
    (define game-board
      (new board%
           [height height]
           [width width]
           [height-px height-px]
           [width-px width-px]))
    (send game-board randomize-stones)
       
    (define bombs '());; List of all active bombs, stored as procedures.
    (define players '());; List of all active players, stored as procedures.
    (define keyboard-players '());; List of all keyboard-players, stored as (procedure . keyboard-bindings)
    
    ;;method to redistubute the keydown's list from the userinteract function.
    ;; key - list of keys down. 
    ;; this is called from the gui class via the main-loop every 1/24 sec.
    (define/public (handle-key-event key)
      (map  (lambda (proc)
              (let((action (assq key (cdr proc))))
                (if action
                    (move-dir (cdr action) (car proc)))))
            keyboard-players))
     
    ;;method to add a keboard player. 
    ;; new-name - string
    ;; x y - cords
    ;;number-of-lives - int
    ;;keybord-bindings - list of keys and the corrisponding action, ex 
    ;;'((#\w . u)(#\a . l)(#\s . d)(#\d . r)(#\space . drop)
    ;; u = up, l = left, d = down, r = right, drop = key calling the the drop bomb method.
    (define/public (add-key-board-player new-name x y dxy number-of-lives keybord-bindings)
      (let((temp-player 
            (new player%
                 [x-pos x]
                 [y-pos y]
                 [dxdy dxy]
                 [name new-name]
                 [lives number-of-lives])))
        (set! players 
              (cons 
               temp-player
               players))
        (set! keyboard-players 
              (cons 
               (cons temp-player keybord-bindings)
               keyboard-players))))
    
    ;;Function to check if it's possible to move and do so if.
    (define (move? proc dir)
      (let((collition #f)
           (new-x (get-field x-pos proc))
           (new-y (get-field y-pos proc)))
        (cond
          ((eq? 'u dir)(set! new-y (-(get-field y-pos proc) (get-field dxdy proc))))
          ((eq? 'd dir)(set! new-y (+(get-field y-pos proc) (get-field dxdy proc))))
          ((eq? 'l dir)(set! new-x (-(get-field x-pos proc) (get-field dxdy proc))))
          ((eq? 'r dir)(set! new-x (+(get-field x-pos proc) (get-field dxdy proc)))))
        (map(lambda (object-to-check)
              (if(and (send object-to-check collition? new-x new-y (get-field height proc) (get-field width proc)) (not collition));; F = ingen kolltion
                 (begin
                   (set! collition #t)
                   (display (get-field type object-to-check)))
                 ))
            objects-to-track)
        
        (if(send game-board collision? new-x new-y)
           (set! collition #t))
        
        (not collition)
        ));; inte klar!!!!!!!!!!!!!!!!!!!
    
    
    ;; fixa en collitonfunktion som klarar av att hitta ett objekt och berätta vilket håll som den stött i
    (define/public (move-dir dir proc)
      (if (move? proc dir)
          (cond
            ((eq? 'u dir)(send proc set-y! (-(get-field y-pos proc) (get-field dxdy proc))))
            ((eq? 'd dir)(send proc set-y! (+(get-field y-pos proc) (get-field dxdy proc))))
            ((eq? 'l dir)(send proc set-x! (-(get-field x-pos proc) (get-field dxdy proc))))
            ((eq? 'r dir)(send proc set-x! (+(get-field x-pos proc) (get-field dxdy proc))))
            ((eq? 'drop dir)(add-bomb (get-field x-pos proc) (get-field y-pos proc) proc))))
      (if(not (eq? 'drop dir))
      (send proc set-dir! dir)))
    
    ;;Method to add bombs to a positon and giv it an owner.
    (define/private (add-bomb x y own)
      (let((temp-bomb 
            (new bomb%
                 [x-pos x]
                 [y-pos y]
                 [delay 10];;get from proc
                 [radius (get-field radius own)]
                 [owner own])))
        (set! bombs 
              (cons 
               temp-bomb
               bombs))))
    
    ;; change here to give the explosion som logic
    (define/private (on-bomb-explosion bomb)
      (display (get-field name (get-field owner bomb)))
      (set! bombs (remv bomb bombs));; remov the bomb from bombs
      )
    
    ;; skickar in alla trackade objects bitmaps i en viss positon.
    ;;track all players
    (define/public (update-scene draw-class)
      (send game-board update-bitmap)
      (send draw-class draw-bitmap-2 (send game-board get-bitmap) 0 0)
      
      (map  (lambda (proc)
              (send draw-class draw-bitmap-2 (send proc get-bitmap) (* *blocksize* (get-field x-pos proc)) (* *blocksize* (get-field y-pos proc))))
            players)
      ;;track all objects in the bomb list
      (map  (lambda (proc)
              (send draw-class draw-bitmap-2 (send proc get-bitmap) (* *blocksize* (get-field x-pos proc)) (* *blocksize* (get-field y-pos proc))))
            objects-to-track)
      
      ;;track all bombs in the bomb list
      (map  (lambda (proc)
              (send draw-class draw-bitmap-2 (send proc get-bitmap) (* *blocksize* (get-field x-pos proc)) (* *blocksize* (get-field y-pos proc)))
              (if(send proc gone-off?)
                 (on-bomb-explosion proc))
              )
            bombs)
      )
    
    ))

