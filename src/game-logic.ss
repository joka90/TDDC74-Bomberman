;; ==== game-board-class.ss 
;; ---------------------------------------------------------------------
;; class game-logic%, huvudlogiken samt 
;; hanterar utritning av bitmaps av alla object
;; ---------------------------------------------------------------------
(define game-logic%
  (class object%
    (super-new)
    (init-field height width height-px width-px)
    (field
     ;; lista med alla aktiva bomber sparade som list-object%
     (bombs (new list-object%))
     ;;  lista med alla aktiva players sparade som list-object%
     (players (new list-object%))
     ;;  lista med alla aktiva keyboard-players sparade som list-object%
     (keyboard-players (new list-object%))
     (powerups (new list-object%))
     (to-do-list (new list-object%))
     (bomb-flames (new list-object%)))
    
    ;;bitmap för statuspanelen
    (define game-status-bitmap
      (new drawing%
           [width 170];;canvas-/bitmapsstorlek
           [height height-px])) 
    
    ;;bitmap för spelet
    (define game-board-bitmap
      (new drawing%
           [width width-px];;canvas-/bitmapsstorlek
           [height height-px])) 
    
    ;;själva spelplanen
    (define game-board
      (new board%
           [height height]
           [width width]
           [height-px height-px]
           [width-px width-px]))
    
    ;;initiera spelplanen, sätt bg och randomisera stenar
    (define/public (init-gameboard)
      (send game-board randomize-stones)
      (send game-board set-bg!))
    
    
    
    ;;metod som tar emot key events från gui-delen
    ;; key - lista med knappar nedtryckta
    ;; Key events skickas hit från gui-klassen en gång per loop
    (define/public (handle-key-event key)
      (for-each
       (lambda (proc)
         (let((action (assq key (cdr proc))))
           (if action
               (move-dir (cdr action) (car proc)))))
       (get-field inner-list keyboard-players)))
    

    ;;Metod som lägger till keyboard-players
    ;;new-name - sträng
    ;;x y - start koordinater
    ;; number-of-lives - int
    ;;keybord-bindings - lista med tangenter och korisponderande händelse-
    ;;'((#\w . u)(#\a . l)(#\s . d)(#\d . r)(#\space . drop)
    ;; u=upp, l = vänster, d = ner, r = höger, drop = anropar drop-bomb-metoden.
    (define/public (add-key-board-player new-name
                                         x y dxy 
                                         number-of-lives 
                                         player-color 
                                         keybord-bindings)
      (let((temp-player 
            (new player%
                 [x-pos x]
                 [y-pos y]
                 [dxdy dxy]
                 [name new-name]
                 [lives number-of-lives]
                 [color player-color])))
        
        (send players add-to-list! temp-player)
        (send keyboard-players add-to-list! 
              (cons temp-player keybord-bindings))))
    
    ;;metod för att kolla om möjligt att förflytta sig
    ;; samt hanterar kollisioner med objekt. 
    ;;Retunerar #t om möjligt att förflytta sig. 
    (define (move? player dir)
      (let((collition #f)
           (new-x (get-field x-pos player))
           (new-y (get-field y-pos player)))
        
        (cond
          ((and (eq? 'd dir) 
                (not (= 0 (remainder (send player get-x-pos-px) *blocksize*))))
           (set! collition #t))
          ((and (eq? 'r dir) 
                (not (= 0 (remainder (send player get-y-pos-px) *blocksize*))))
           (set! collition #t))
          ((and (eq? 'u dir) 
                (not (= 0 (remainder (send player get-x-pos-px) *blocksize*))))
           (set! collition #t))
          ((and (eq? 'l dir) 
                (not (= 0 (remainder (send player get-y-pos-px) *blocksize*))))
           (set! collition #t))
          ((eq? 'u dir)(set! new-y (-(get-field y-pos player) 1)))
          ((eq? 'd dir)(set! new-y (+(get-field y-pos player) 1)))
          ((eq? 'l dir)(set! new-x (-(get-field x-pos player) 1)))
          ((eq? 'r dir)(set! new-x (+(get-field x-pos player) 1))))
        
        (for-each
         (lambda (powerup)
           (if(and 
               (send powerup collition? new-x new-y) 
               (not collition);; F = ingen kollision
               )
              (begin
                (send powerup use-power-up player)
                (send powerups remove-from-list! powerup))))              
         (get-field inner-list powerups))
        
        (for-each
         (lambda (bomb)
           (if(and 
               (send bomb collition? new-x new-y) 
               (not collition))
                (set! collition #t)))
         (get-field inner-list bombs))
        
        (if(and 
            (send game-board collision? new-x new-y) 
            (not collition))
           (set! collition #t))
        
        (not collition)))
    
    ;;Flytta spelaren
    (define/private (move-dir dir player)
      (if (move? player dir)
          (cond
            ((eq? 'u dir)
             (send player set-y-pos-px! 
                   (-(send player get-y-pos-px) (get-field dxdy player))))
            ((eq? 'd dir)
             (send player set-y-pos-px! 
                   (+(send player get-y-pos-px) (get-field dxdy player))))
            ((eq? 'l dir)
             (send player set-x-pos-px! 
                   (-(send player get-x-pos-px) (get-field dxdy player))))
            ((eq? 'r dir)
             (send player set-x-pos-px! 
                   (+(send player get-x-pos-px) (get-field dxdy player))))
            ((eq? 'drop dir)
             (add-bomb 
              (get-field x-pos player) (get-field y-pos player) player)))
          (cond;;flytta om möjligt i rutan
            ((and (eq? 'u dir) 
                  (<= (get-field dxdy player)  
                      (remainder (send player get-y-pos-px) *blocksize*)))
             (send player set-y-pos-px! 
                   (-(send player get-y-pos-px) (get-field dxdy player))))
            ((and (eq? 'd dir) 
                  (<= (get-field dxdy player)  
                      (remainder (send player get-y-pos-px) *blocksize*)))
             (send player set-y-pos-px! 
                   (+(send player get-y-pos-px) (get-field dxdy player))))
            ((and
              (eq? 'l dir)
              (<= (get-field dxdy player)  
                  (remainder (send player get-x-pos-px) *blocksize*)))
             (send player set-x-pos-px! 
                   (-(send player get-x-pos-px) (get-field dxdy player))))
            ((and
              (eq? 'r dir)
              (<= (get-field dxdy player)  
                  (remainder (send player get-x-pos-px) *blocksize*)))
             (send player set-x-pos-px! 
                   (+(send player get-x-pos-px) (get-field dxdy player))))))
      
      (if(not (eq? 'drop dir))
         (send player set-dir! dir)))
    
    ;;Metod  för att lägga till bomber till en position och ge bomben en ägare
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
                 [delay (get-field delay own)]
                 [radius (get-field radius own)]
                 [owner own])))
        (send bombs add-to-list! temp-bomb)))
    
  
    (define/private (on-bomb-explosion bomb)
      (define result 
        (send game-board 
              delete-destruct-from-board-radius! 
              (get-field x-pos bomb)
              (get-field y-pos bomb)
              (get-field radius bomb)))
      
      (define flames (car result))
      (define to-blow-up (cadr result))
      (define flame-limits (caddr result))
      
      ;;sätt antal bomber ute på spelaren
      (send (get-field owner bomb) remv-bomb)
      
      ;; ta bort bomben från bomberna
      (send bombs remove-from-list! bomb)
      
      ;;kolla mot olika powerups och bomber för kedjesprängning
      (for-each  (lambda (flame)
                   
                   ;;spräng alla bomber
                   (for-each  (lambda (bomb-to-check)
                                (if(send bomb-to-check collition? 
                                         (car flame) 
                                         (cadr flame))
                                   (on-bomb-explosion bomb-to-check));;spräng
                                )
                              (get-field inner-list bombs))
                   
                   ;;spräng alla powerups
                   (for-each  (lambda (powerup-to-check)
                                (if(send powerup-to-check collition? 
                                         (car flame) 
                                         (cadr flame))
                                   (send powerups remove-from-list!
                                         powerup-to-check)))
                              (get-field inner-list powerups)))
                 flames)
	
      ;;Gör en ny flammgrupp och lägg till den i flammlistan
      (send bomb-flames add-to-list! 
            (new flame% 
                 [center-x-pos (get-field x-pos bomb)]
                 [center-y-pos (get-field y-pos bomb)]
                 [delay 1500] 
                 [owner (get-field owner bomb)]
                 [limits flame-limits]))
     
      ;;lägg till att-göra-listan, för att ta bort nästa loop
      (send to-do-list add-to-list!
            (new make-timer% 
                 [delay 0];;spräng så fort som möjligt
                 [proc (lambda (arg)(remove-blocks arg))]
                 [args (list to-blow-up)])))
    
    (define/private (remove-blocks block-list)
      (for-each  (lambda (block)
                   (if (and  
                        (send game-board;;kolla om borttagning lyckades och ta bort
                              delete-object-from-board!
                              (car block);x
                              (cadr block));y
                        (= 2 (random 5)));en på fem
                       (send powerups add-to-list! 
                             (new powerup% 
                                  [x-pos (car block)] 
                                  [y-pos (cadr block)]))))
                 block-list))
    
    (define/private (on-die player flame)
      (if (send player possible-to-die?)
          (send player die))
      
      (if (= (get-field lives player) 0)
          (begin
            (send player set-x! 10000)
            (send player set-y! 10000))))
    
    ;; skickar in alla trackade objekt bitmaps i en viss positon.
    (define/public (update-scene draw-class)
      (send game-board update-bitmap)
      (update-game-logic)
      (update-game-status-bitmap)
      (send draw-class draw-bitmap-on-bitmap 
            (send game-board get-bitmap) 0 0)
      (send draw-class draw-bitmap-on-bitmap 
            (send game-board-bitmap get-bitmap) 0 0)
      (send draw-class draw-bitmap-on-bitmap 
            (send game-status-bitmap get-bitmap) width-px 0))
    
    ;;uppdatera statuspanelens bitmap
    (define/private (update-game-status-bitmap)
      (send game-status-bitmap clear)
      (send game-status-bitmap draw-bitmap-on-bitmap 
            (send *image-store* get-image 'bg-status) 0 0)

      (define row-px 140)
      
      (for-each  (lambda (player)
                   (send game-status-bitmap draw-bitmap-on-bitmap
                         (send player get-status-bitmap)
                         0
                         row-px)
                   (set! row-px (+ row-px 100)))
                 (get-field inner-list players)))
    
    ;;updatera spelplanen och allas objektposition i olika bitmaps.
    ;; Samt kollar om spelaren kolliderar med flammorna
    (define/private (update-game-logic)
      (send game-board-bitmap clear)
      
      ;;håll koll på alla bomberna i bomblistan
      (for-each  (lambda (bomb)
                   (send game-board-bitmap draw-bitmap-on-bitmap
                         (send bomb get-bitmap)
                         (* *blocksize* (get-field x-pos bomb))
                         (* *blocksize* (get-field y-pos bomb)))
                   (if(send bomb gone-off?)
                      (on-bomb-explosion bomb)))
                 (get-field inner-list bombs))
      
      ;;håll koll på alla bomberna i flammlistan och
      ;;kolla kollisioner mellan spelare och flammor
      (for-each  (lambda (flame)
                   (map  (lambda (player)
                           (if(eq? 'flame ;;
                                   (send flame collition?
                                         (get-field x-pos player)
                                         (get-field y-pos player)))
                              (on-die player flame)))
                         (get-field inner-list players))
                   (send game-board-bitmap draw-bitmap-on-bitmap
                         (send flame get-bitmap)
                         (* *blocksize* (send flame get-x-pos))
                         (* *blocksize* (send flame get-y-pos)))
                   (if(send flame gone-off?)
                      (send bomb-flames remove-from-list! flame)))
                 (get-field inner-list bomb-flames))
      
      ;;håll koll på timers
      (for-each  (lambda (to-do)
                   (if(send to-do gone-off?)
                      (begin
                        (send to-do run-proc)
                        (send to-do-list remove-from-list! to-do))));;run proc
                 (get-field inner-list to-do-list))
      
      
      ;;håll koll på powerups
      (for-each  (lambda (powerup)
                   (send game-board-bitmap draw-bitmap-on-bitmap
                         (send powerup get-bitmap)
                         (* *blocksize* (get-field x-pos powerup))
                         (* *blocksize* (get-field y-pos powerup))))
                 (get-field inner-list powerups))
      
      ;;alla spelare
      (for-each  (lambda (player)
                   (send game-board-bitmap draw-bitmap-on-bitmap
                         (send player get-bitmap)
                         (- (send player get-x-pos-px) 5)
                         (- (send player get-y-pos-px) 35)))
                 (get-field inner-list players)))))

