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
    (define powerups '())
    (define to-do-list '())
    (define bomb-flames '())
    
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
    (define/public (add-key-board-player new-name x y dxy number-of-lives player-color keybord-bindings)
      (let((temp-player 
            (new player%
                 [x-pos x]
                 [y-pos y]
                 [dxdy dxy]
                 [name new-name]
                 [lives number-of-lives]
                 [color player-color])))
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
          ((and (eq? 'd dir) (not (= 0 (remainder (send proc get-x-pos-px) *blocksize*))))
           (set! collition #t))
          ((and (eq? 'r dir) (not (= 0 (remainder (send proc get-y-pos-px) *blocksize*))))
           (set! collition #t))
          ((and (eq? 'u dir) (not (= 0 (remainder (send proc get-x-pos-px) *blocksize*))))
           (set! collition #t))
          ((and (eq? 'l dir) (not (= 0 (remainder (send proc get-y-pos-px) *blocksize*))))
           (set! collition #t))
          ((eq? 'u dir)(set! new-y (-(get-field y-pos proc) 1)))
          ((eq? 'd dir)(set! new-y (+(get-field y-pos proc) 1)))
          ((eq? 'l dir)(set! new-x (-(get-field x-pos proc) 1)))
          ((eq? 'r dir)(set! new-x (+(get-field x-pos proc) 1))))
        
        (map(lambda (object-to-check)
              (if(and 
                  (send object-to-check collition? new-x new-y) 
                  (not collition);; F = ingen kolltion
                  )
                 (begin
                   (send object-to-check use-power-up proc);; add powerup to player
                   (set! powerups (remv object-to-check powerups));;remove poverup from game
                   ;(display powerups)
                   )
                 ))
            powerups)
        
        (map(lambda (object-to-check)
              (if(and 
                  (send object-to-check collition? new-x new-y) 
                  (not collition);; F = ingen kolltion
                  ;(not (eq? (get-field owner object-to-check) proc))
                  )
                 (begin
                   (set! collition #t)
                   ;(display (get-field type object-to-check))
                   )
                 ))
            bombs)
        
        (if(and (send game-board collision? new-x new-y) (not collition))
           (set! collition #t))
        
        (not collition)
        ));; inte klar!!!!!!!!!!!!!!!!!!!
    
    
    ;; fixa en collitonfunktion som klarar av att hitta ett objekt och berätta vilket håll som den stött i
    (define/public (move-dir dir proc)
      (if (move? proc dir)
          (cond
            ((eq? 'u dir)(send proc set-y-pos-px! (-(send proc get-y-pos-px) (get-field dxdy proc))))
            ((eq? 'd dir)(send proc set-y-pos-px! (+(send proc get-y-pos-px) (get-field dxdy proc))))
            ((eq? 'l dir)(send proc set-x-pos-px! (-(send proc get-x-pos-px) (get-field dxdy proc))))
            ((eq? 'r dir)(send proc set-x-pos-px! (+(send proc get-x-pos-px) (get-field dxdy proc))))
            ((eq? 'drop dir)(add-bomb (get-field x-pos proc) (get-field y-pos proc) proc)))
          (cond;;flytta om möjligt i rutan
            ((and (eq? 'u dir) 
                  (<= (get-field dxdy proc)  (remainder (send proc get-y-pos-px) *blocksize*)))
             (send proc set-y-pos-px! (-(send proc get-y-pos-px) (get-field dxdy proc))))
            ((and (eq? 'd dir) 
                  (<= (get-field dxdy proc)  (remainder (send proc get-y-pos-px) *blocksize*)))
             (send proc set-y-pos-px! (+(send proc get-y-pos-px) (get-field dxdy proc))))
            ((and
              (eq? 'l dir)
              (<= (get-field dxdy proc)  (remainder (send proc get-x-pos-px) *blocksize*)))
             (send proc set-x-pos-px! (-(send proc get-x-pos-px) (get-field dxdy proc))))
            ((and
              (eq? 'r dir)
              (<= (get-field dxdy proc)  (remainder (send proc get-x-pos-px) *blocksize*)))
             (send proc set-x-pos-px! (+(send proc get-x-pos-px) (get-field dxdy proc))))
            ))
      
      (if(not (eq? 'drop dir))
      (send proc set-dir! dir)))
    
    ;;Method to add bombs to a positon and giv it an owner.
    (define/private (add-bomb x y own)
      (if(send own can-bomb?)
         (begin
           (add-bomb-help x y own)
           (send own add-bomb))))
    
    (define/private (add-bomb-help x y own)
      (let((temp-bomb 
            (new bomb%
                 [x-pos x]
                 [y-pos y]
                 [delay (get-field delay own)];;get from proc
                 [radius (get-field radius own)]
                 [owner own])))
        (set! bombs 
              (cons 
               temp-bomb
               bombs))))
    
    ;; change here to give the explosion some logic
    (define/private (on-bomb-explosion bomb)
      ;;game-board returns (to-delete . emptyspaces)
       (define result (send game-board 
                            delete-destruct-from-board-radius! 
                            (get-field x-pos bomb)
                            (get-field y-pos bomb)
                            (get-field radius bomb)))
      
      (send (get-field owner bomb) remv-bomb);;set number of bombs out on player
      (set! bombs (remv bomb bombs));; remov the bomb from bombs
      
      ;;kolla mot olika powerups
      (map  (lambda (flame)
              (map  (lambda (bomb-to-check)
                      (if(send bomb-to-check collition? (car flame) (cadr flame))
                           (on-bomb-explosion bomb-to-check); spräng
                           )
                      )
                      bombs)
              (map  (lambda (powerup-to-check)
                      (if(send powerup-to-check collition? (car flame) (cadr flame))
                         (set! powerups (remv powerup-to-check powerups));;remove poverup from game
                         ))
                      powerups)
              ;;add flames here to
              (set! bomb-flames 
                    (cons 
                     (new flame% 
                          [x-pos (car flame)]
                          [y-pos (cadr flame)]
                          [delay 2] 
                          [owner (get-field owner bomb)]
                          [direction (caddr flame)])
                     bomb-flames))
              ;(display (caddr flame))(newline)
              )
            (car result))
      ;;add to todo list
      (set! to-do-list 
            (cons 
             (new make-timer% 
                  [delay 0];;spräng så fort som möjligt
                  [proc (lambda (arg)(remove-blocks arg))]
                  [args (list (cadr result))])
             to-do-list))
      )
    
    (define/private (remove-blocks block-list)
      (map  (lambda (block)
              (send game-board
                    delete-object-from-board!
                    (car block);x
                    (cadr block));y
              (if (= 5 (random 10))
                  (begin
                    (display "adding ")
                  (set! powerups 
                        (cons 
                          (new powerup% 
                               [x-pos (car block)] 
                               [y-pos (cadr block)])
                         powerups)))))
            block-list))
    
    (define/private(on-die player flame)
      (display (get-field name player))
      (display "was killed by")
      (display (get-field name (get-field owner flame)))
      (newline)
      )
    
    ;; skickar in alla trackade objects bitmaps i en viss positon.
    ;;track all players
    (define/public (update-scene draw-class)
      (send game-board update-bitmap)
      (send draw-class draw-bitmap-2 (send game-board get-bitmap) 0 0)
      
      ;;track all bombs in the bomb list
      (map  (lambda (proc)
              (send draw-class draw-bitmap-2
                    (send proc get-bitmap)
                    (* *blocksize* (get-field x-pos proc))
                    (* *blocksize* (get-field y-pos proc)))
              (if(send proc gone-off?)
                 (on-bomb-explosion proc))
              )
            bombs)
      
       ;;track all bombs in the flames list and check collisons between player and flames.
      (map  (lambda (proc)
              ;tarck all timers
              (map  (lambda (player)
                      (if(send proc collition?
                               (get-field x-pos player)
                               (get-field y-pos player))
                         (on-die player proc));;on die
                      )
                    players)
              (send draw-class draw-bitmap-2
                    (send proc get-bitmap)
                    (* *blocksize* (get-field x-pos proc))
                    (* *blocksize* (get-field y-pos proc)))
              (if(send proc gone-off?)
                 (set! bomb-flames (remv proc bomb-flames)))
              )
            bomb-flames)
      
      
      ;;tarck all timers
       (map  (lambda (proc)
              (if(send proc gone-off?)
                 (begin
                   (send proc run-proc)
                   (set! to-do-list (remv proc to-do-list))
                   )
                 );;run proc
              )
            to-do-list)
 
      ;;track all objects
      (map  (lambda (proc)
              (send draw-class draw-bitmap-2
                    (send proc get-bitmap)
                    (* *blocksize* (get-field x-pos proc))
                    (* *blocksize* (get-field y-pos proc))))
            objects-to-track)
      
      ;;track all powerups
      (map  (lambda (proc)
              (send draw-class draw-bitmap-2
                    (send proc get-bitmap)
                    (* *blocksize* (get-field x-pos proc))
                    (* *blocksize* (get-field y-pos proc))))
            powerups)
      
      ;;all players
      (map  (lambda (proc)
              (send draw-class draw-bitmap-2
                    (send proc get-bitmap)
                    (- (send proc get-x-pos-px) 5)
                    (- (send proc get-y-pos-px) 35)))
            players)
      
      
      )
    
    ))

