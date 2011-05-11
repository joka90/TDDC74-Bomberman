;; ---------------------------------------------------------------------
;; GUI
;; ---------------------------------------------------------------------
(define make-gui%
  (class object%
    (super-new)
    (init-field window-name width height image-buffer image-buffer-status logic-class)
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
    
    ;; get new canvas from global draw class on redraw
    (define (draw-status-canvas canvas dc)
      (send image-buffer-status get-image canvas dc))
    
    ;;Anropas utifrån för att skicka vidare key-events från canvasen i denna klass.
    (define/public (update-keys-down)
      (send gui-canvas send-key-events))
    
    ;;the panel where the two collums is placed
    (define contentpanel (new horizontal-panel% 
                                [parent gui-frame]
                                [alignment '(right center)]))
    
    (define leftpanel (new panel% 
                            [parent contentpanel]
                            [min-width (get-field width image-buffer)]	 
                            [min-height (get-field height image-buffer)]
                            [alignment '(left center)]))
    (define rightpanel (new panel% 
                           [parent contentpanel]
                           [min-height (get-field height image-buffer)]
                           [alignment '(right center)]))
    ;;a colleciton of buttons
    (define controllpanel (new horizontal-panel% 
                                [parent rightpanel]
                                [alignment '(center bottom)]))
    
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
    ;;FIXME reset button, make some logic here!!!!1
    (new button% [parent controllpanel]
         [label "Reset"]
         [callback (lambda (button event)
                     (send main-loop stop-loop))])
   
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
    

    (define gui-canvas
      (new user-interact-canvas% 
           [parent leftpanel]
           [paint-callback draw-canvas]
           [on-key-event-callback (lambda(key)(send logic-class handle-key-event key))];; flyttar lite seda
           [min-height (get-field height image-buffer)]
           [min-width (get-field width image-buffer)]
           [stretchable-width #f]
           [stretchable-height #f]))
    
     (define gui-status-canvas
      (new user-interact-canvas% 
           [parent rightpanel]
           [paint-callback draw-status-canvas]
           [on-key-event-callback (lambda(key)(send logic-class handle-key-event key))];; flyttar lite seda
           [min-height (- height 100)]
           [min-width (- width (get-field width image-buffer))]
           [stretchable-width #f]
           [stretchable-height #f]))
    
    ))


