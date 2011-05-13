;; ---------------------------------------------------------------------
;; GUI
;; ---------------------------------------------------------------------
(define make-gui%
  (class object%
    (super-new)
    (init-field window-name width height image-buffer logic-class)
    (define gui-frame (new frame% 
                           [label window-name]
                           [min-width width]
                           [min-height height]))
    
   	 
    
    ;; show gui
    (define/public (show-gui)
      (send gui-frame show #t)
      (send gui-canvas focus));; move focus to canvas, to get key events
    
    ;; hide gui and stops main-loop
    (define/public (hide-gui)
      (send gui-frame show #f)
      (send main-loop stop-loop))
    
    ;; update canvas to see changes in draw buffer
    (define/public (redraw)
      (send gui-canvas on-paint))
    
    (define/public (get-width)
      (send gui-canvas get-width))
    
    (define/public (get-height)
      (send gui-canvas get-height))
    
    ;; get new canvas from global draw class on redraw
    (define (draw-canvas canvas dc)
      (send image-buffer get-image canvas dc))
    

    
    ;;Anropas utifrån för att skicka vidare key-events från canvasen i denna klass.
    (define/public (update-keys-down)
      (send gui-canvas send-key-events))
    
    ;;the panel where the two collums is placed
    (define top-panel (new vertical-panel% 
                                [parent gui-frame]
                                [alignment '(center center)]
                                [min-height (get-field height image-buffer)]
                                [min-width (get-field width image-buffer)]))
    
    ;;a colleciton of buttons
    (define bottom-panel (new vertical-panel% 
                                [parent gui-frame]
                                [alignment '(right top)]))
    
    (define gui-canvas
      (new user-interact-canvas% 
           [parent top-panel]
           [paint-callback draw-canvas]
           [on-key-event-callback (lambda(key)(send logic-class handle-key-event key))];; flyttar lite seda
           [min-height (get-field height image-buffer)]
           [min-width (get-field width image-buffer)]
           [stretchable-width #f]
           [stretchable-height #f]))
    
    ;;a colleciton of buttons
    (define controllpanel (new horizontal-panel% 
                                [parent bottom-panel]
                                [alignment '(right center)]))
    
    ;;the start / paus button
    (define startbutton (new button% [parent controllpanel]
                             [label "Paus"]
                             [callback (lambda (button event)
                                         (if(send main-loop running?)
                                            (begin
                                              (send main-loop stop-loop)
                                              (send startbutton set-label "Start"))
                                            (begin
                                              (send main-loop start-loop)
                                              (send startbutton set-label "Paus"))))]))

   
    ;;Quit button, stops main-loop, to save cpu.
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
      ("Quit" gui-menu (lambda (a b) (hide-gui))))

    
    
    ))


