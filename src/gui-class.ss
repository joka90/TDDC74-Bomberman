;; ==== gui-class.ss 
;; ---------------------------------------------------------------------
;; GUI, skapa gui för spelet.
;; ---------------------------------------------------------------------
(define game-gui%
  (class object%
    (super-new)
    (init-field window-name width height image-buffer logic-class)
    (define gui-frame (new frame% 
                           [label window-name]
                           [min-width width]
                           [min-height height]))
    
   	 
    
    ;; visa gui och fokusera tangentbord på canvas
    (define/public (show-gui)
      (send gui-frame show #t)
      (send gui-canvas focus));; flytta fokus till canvas, för att ta key events
    
    ;; göm gui och stoppar *game-loop*
    (define/public (hide-gui)
      (send gui-frame show #f)
      (send *game-loop* stop-loop))
    
    ;; uppdatera guit för att ladda om nya bitmaps
    (define/public (redraw)
      (send gui-canvas on-paint))
    
    ;;retunera bredd
    (define/public (get-width)
      (send gui-canvas get-width))
    
    ;;retunera höjd
    (define/public (get-height)
      (send gui-canvas get-height))
    

    ;;Hämta en ny bitmap från den globala bitmappen
    ;; som sattes via image-buffer-argumentet när objektet skapades. 
    (define (draw-canvas canvas dc)
      (send image-buffer get-image canvas dc))
    

    
    ;;Anropas utifrån för att skicka vidare 
    ;;key-events från canvasen i denna klass.
    (define/public (update-keys-down)
      (send gui-canvas send-key-events))
    
    ;;panelen där canvas är placerad
    (define top-panel (new vertical-panel% 
                                [parent gui-frame]
                                [alignment '(center center)]
                                [min-height (get-field height image-buffer)]
                                [min-width (get-field width image-buffer)]))
    
    ;;en samling av knappar
    (define bottom-panel (new vertical-panel% 
                                [parent gui-frame]
                                [alignment '(right top)]))
    
    (define gui-canvas
      (new user-interact-canvas% 
           [parent top-panel]
           [paint-callback draw-canvas]
           [on-key-event-callback 
            (lambda(key)(send logic-class handle-key-event key))]
           [min-height (get-field height image-buffer)]
           [min-width (get-field width image-buffer)]
           [stretchable-width #f]
           [stretchable-height #f]))
    
    ;;en samling av knappar
    (define controllpanel (new horizontal-panel% 
                                [parent bottom-panel]
                                [alignment '(right center)]))
    
    ;;start-/pausknapp
    (define startbutton (new button% [parent controllpanel]
                             [label "Paus"]
                             [callback (lambda (button event)
                                         (if(send *game-loop* running?)
                                            (begin
                                              (send *game-loop* stop-loop)
                                              (send startbutton set-label "Start"))
                                            (begin
                                              (send *game-loop* start-loop)
                                              (send startbutton set-label "Paus"))))]))

   
    ;;Stängknapp, stoppar *game-loop* för att spara cpu
    (new button%
         [parent controllpanel]
         [label "Quit"]
         [callback (lambda (a b) (hide-gui))])
    
    (define gui-menu-bar
      (instantiate menu-bar%
        (gui-frame)))
    
    (define gui-menu
      (instantiate menu%
        ("Menu" gui-menu-bar)))
    
    (instantiate menu-item%
      ("Quit" gui-menu (lambda (a b) (hide-gui))))))


