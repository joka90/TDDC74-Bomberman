;; ---------------------------------------------------------------------
;; GUI
;; ---------------------------------------------------------------------
(define make-gui%
  (class object%
    (super-new)
    (init-field window-name width height image-buffer)
    (define gui-frame (new frame% 
                           [label window-name]
                           [min-width width]
                           [min-height height]))
    
   	 
    
    ;; show gui
    (define/public (show-gui)
      (send gui-frame show #t)
      (send gui-canvas focus));; move focus to canvas, to get key events
    ;; hide gui
    (define/public (hide-gui)
      (send gui-frame show #f))
    
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
    
    (define/public (update-keys-down)
      (send gui-canvas send-key-events))
    
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
  
    (define controllpanel (new horizontal-panel% 
                                [parent rightpanel]
                                [alignment '(center bottom)]))
    
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
    
    (new button% [parent controllpanel]
         [label "Reset"]
         [callback (lambda (button event)
                     (send main-loop stop-loop))])
   
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
           [on-key-event-callback (lambda(key)(send test-logic handle-key-event key))];; flyttar lite seda
           [min-height (get-field height image-buffer)]
           [min-width (get-field width image-buffer)]
           [stretchable-width #f]
           [stretchable-height #f]))))


