;; ---------------------------------------------------------------------
;; class game-logic%
;; ---------------------------------------------------------------------


(define game-logic%
  (class object%
    (super-new)
    (init-field height width height-px width-px)
    (field
     (bombs (new list-object%));; List of all active bombs stored as objects in list-object%
     (players (new list-object%));; List of all active players, stored as
     (keyboard-players (new list-object%));; List of all keyboard-players, stored as (object . keyboard-bindings)
     (powerups (new list-object%))
     (to-do-list (new list-object%))
     (bomb-flames (new list-object%))
     )
    
    (define game-board
      (new board%
           [height height]
           [width width]
           [height-px height-px]
           [width-px width-px]))
    (send game-board randomize-stones)
    
    
    
    ;;method to redistubute the keydown's list from the userinteract function.
    ;; key - list of keys down. 
    ;; this is called from the gui class via the main-loop every 1/24 sec.
    (define/public (handle-key-event key)
      (for-each
       (lambda (proc)
         (let((action (assq key (cdr proc))))
           (if action
               (move-dir (cdr action) (car proc)))))
       (get-field inner-list keyboard-players)))
    
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
        
        (send players add-to-list! temp-player)
        (send keyboard-players add-to-list! (cons temp-player keybord-bindings))))
    
    ;;Function to check if it's possible to move and do so if.
    (define (move? player dir)
      (let((collition #f)
           (new-x (get-field x-pos player))
           (new-y (get-field y-pos player)))
        
        (cond
          ((and (eq? 'd dir) (not (= 0 (remainder (send player get-x-pos-px) *blocksize*))))
           (set! collition #t))
          ((and (eq? 'r dir) (not (= 0 (remainder (send player get-y-pos-px) *blocksize*))))
           (set! collition #t))
          ((and (eq? 'u dir) (not (= 0 (remainder (send player get-x-pos-px) *blocksize*))))
           (set! collition #t))
          ((and (eq? 'l dir) (not (= 0 (remainder (send player get-y-pos-px) *blocksize*))))
           (set! collition #t))
          ((eq? 'u dir)(set! new-y (-(get-field y-pos player) 1)))
          ((eq? 'd dir)(set! new-y (+(get-field y-pos player) 1)))
          ((eq? 'l dir)(set! new-x (-(get-field x-pos player) 1)))
          ((eq? 'r dir)(set! new-x (+(get-field x-pos player) 1))))
        
        (for-each
         (lambda (powerup)
           (if(and 
               (send powerup collition? new-x new-y) 
               (not collition);; F = ingen kolltion
               )
              (begin
                (send powerup use-power-up player);; add powerup to player
                (send powerups remove-from-list! powerup);;remove poverup from game                   
                )
              ))
         (get-field inner-list powerups))
        
        (for-each
         (lambda (bomb)
           (if(and 
               (send bomb collition? new-x new-y) 
               (not collition);; F = ingen kolltion
               ;(not (eq? (get-field owner object-to-check) player))
               )
              (begin
                (set! collition #t)
                ;(display (get-field type object-to-check))
                )
              ))
         (get-field inner-list bombs))
        
        (if(and (send game-board collision? new-x new-y) (not collition))
           (set! collition #t))
        
        (not collition)
        ));; inte klar!!!!!!!!!!!!!!!!!!!
    
    
    ;; fixa en collitonfunktion som klarar av att hitta ett objekt och berätta vilket håll som den stött i
    (define/public (move-dir dir player)
      (if (move? player dir)
          (cond
            ((eq? 'u dir)(send player set-y-pos-px! (-(send player get-y-pos-px) (get-field dxdy player))))
            ((eq? 'd dir)(send player set-y-pos-px! (+(send player get-y-pos-px) (get-field dxdy player))))
            ((eq? 'l dir)(send player set-x-pos-px! (-(send player get-x-pos-px) (get-field dxdy player))))
            ((eq? 'r dir)(send player set-x-pos-px! (+(send player get-x-pos-px) (get-field dxdy player))))
            ((eq? 'drop dir)(add-bomb (get-field x-pos player) (get-field y-pos player) player)))
          (cond;;flytta om möjligt i rutan
            ((and (eq? 'u dir) 
                  (<= (get-field dxdy player)  (remainder (send player get-y-pos-px) *blocksize*)))
             (send player set-y-pos-px! (-(send player get-y-pos-px) (get-field dxdy player))))
            ((and (eq? 'd dir) 
                  (<= (get-field dxdy player)  (remainder (send player get-y-pos-px) *blocksize*)))
             (send player set-y-pos-px! (+(send player get-y-pos-px) (get-field dxdy player))))
            ((and
              (eq? 'l dir)
              (<= (get-field dxdy player)  (remainder (send player get-x-pos-px) *blocksize*)))
             (send player set-x-pos-px! (-(send player get-x-pos-px) (get-field dxdy player))))
            ((and
              (eq? 'r dir)
              (<= (get-field dxdy player)  (remainder (send player get-x-pos-px) *blocksize*)))
             (send player set-x-pos-px! (+(send player get-x-pos-px) (get-field dxdy player))))
            ))
      
      (if(not (eq? 'drop dir))
         (send player set-dir! dir)))
    
    ;;Method to add bombs to a positon and giv it an owner.
    (define/private (add-bomb x y owner)
      (if(send owner can-bomb?)
         (begin
           (add-bomb-help x y owner)
           (send owner add-bomb))))
    
    (define/private (add-bomb-help x y own)
      (let((temp-bomb 
            (new bomb%
                 [x-pos x]
                 [y-pos y]
                 [delay (get-field delay own)];;get from proc
                 [radius (get-field radius own)]
                 [owner own])))
        (send bombs add-to-list! temp-bomb)))
    
    ;; change here to give the explosion some logic
    (define/private (on-bomb-explosion bomb)
      ;;game-board returns (emptyspaces delete-block)
      (define result 
        (send game-board 
              delete-destruct-from-board-radius! 
              (get-field x-pos bomb)
              (get-field y-pos bomb)
              (get-field radius bomb)))
      
      (define flames (car result))
      (define to-blow-up (cadr result))
      (define flame-limits (caddr result))
      
      ;;set number of bombs out on player
      (send (get-field owner bomb) remv-bomb)
      
      ;; remov the bomb from bombs
      (send bombs remove-from-list! bomb)
      
      ;;kolla mot olika powerups och bomber för kjedjesprängning
      (for-each  (lambda (flame)
                   
                   ;;blow all boms up
                   (for-each  (lambda (bomb-to-check)
                                (if(send bomb-to-check collition? (car flame) (cadr flame))
                                   (on-bomb-explosion bomb-to-check); spräng
                                   )
                                )
                              (get-field inner-list bombs))
                   
                   ;;blow all powerups up
                   (for-each  (lambda (powerup-to-check)
                                (if(send powerup-to-check collition? (car flame) (cadr flame))
                                   (send powerups remove-from-list! powerup-to-check);;remove poverup from game
                                   ))
                              (get-field inner-list powerups))
                   
                   
         
                   );;end lambda for-each flame
                 flames)
      ;;add flame to a list for tracking
      (display flame-limits)
      (display " x: ")(display (get-field x-pos bomb))
      (display " y: ")(display (get-field y-pos bomb))(newline)
      (send bomb-flames add-to-list! 
            (new flame% 
                 [center-x-pos (get-field x-pos bomb)]
                 [center-y-pos (get-field y-pos bomb)]
                 [delay 2] 
                 [owner (get-field owner bomb)]
                 [limits flame-limits]))
      ;(display to-blow-up)
      ;;add to todo list, to remove next loop.
      (send to-do-list add-to-list!
            (new make-timer% 
                 [delay 0];;spräng så fort som möjligt
                 [proc (lambda (arg)(remove-blocks arg))]
                 [args (list to-blow-up)]))
      )
    
    (define/private (remove-blocks block-list)
      (for-each  (lambda (block)
                   (if (and  
                        (send game-board;;check if delete succeded and delete
                              delete-object-from-board!
                              (car block);x
                              (cadr block));y
                        (= 2 (random 6)));en på sex
                       (send powerups add-to-list! 
                             (new powerup% 
                                  [x-pos (car block)] 
                                  [y-pos (cadr block)]))))
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
      (for-each  (lambda (bomb)
                   (send draw-class draw-bitmap-2
                         (send bomb get-bitmap)
                         (* *blocksize* (get-field x-pos bomb))
                         (* *blocksize* (get-field y-pos bomb)))
                   (if(send bomb gone-off?)
                      (on-bomb-explosion bomb)))
                 (get-field inner-list bombs))
      
      ;;track all bombs in the flames list and check collisons between player and flames.
      (for-each  (lambda (flame)
                   ;tarck all timers
                   ;;TODO: to we need to check this every time?
                   (map  (lambda (player)
                           (if(eq? 'flame ;; if we want flames that dont kill
                                   (send flame collition?
                                         (get-field x-pos player)
                                         (get-field y-pos player)))
                              (on-die player flame));;on die
                           )
                         (get-field inner-list players))
                   (send draw-class draw-bitmap-2
                         (send flame get-bitmap)
                         (* *blocksize* (send flame get-x-pos))
                         (* *blocksize* (send flame get-y-pos)))
                   (if(send flame gone-off?)
                      (send bomb-flames remove-from-list! flame)))
                 (get-field inner-list bomb-flames))
      
      
      ;;tarck all timers
      (for-each  (lambda (to-do)
                   (if(send to-do gone-off?)
                      (begin
                        (send to-do run-proc)
                        (send to-do-list remove-from-list! to-do)));;run proc
                   )
                 (get-field inner-list to-do-list))
      
      
      ;;track all powerups
      (for-each  (lambda (powerup)
                   (send draw-class draw-bitmap-2
                         (send powerup get-bitmap)
                         (* *blocksize* (get-field x-pos powerup))
                         (* *blocksize* (get-field y-pos powerup))))
                 (get-field inner-list powerups))
      
      ;;all players
      (for-each  (lambda (player)
                   (send draw-class draw-bitmap-2
                         (send player get-bitmap)
                         (- (send player get-x-pos-px) 5)
                         (- (send player get-y-pos-px) 35)))
                 (get-field inner-list players))
      
      )
    
    ))

