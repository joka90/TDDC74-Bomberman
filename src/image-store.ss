;; ==== image-store.ss 
;; ---------------------------------------------------------------------
;; klass för enkelt ladda in bilder, samt retunera utifrån sök kriterier
;; ---------------------------------------------------------------------
(define make-image-store%
  (class object%
    (super-new)
    
    (define image-list '())
    (define anim 1)
    
    ;;add-rot-image name(symbol), load-list list ex:
    ;;'(('r . "img/r.bmp")('l . "img/l.bmp")
    ;;('d . "img/d.bmp")('u . "img/u.bmp"))
    (define/private (add-rot-image name load-list)
      (define temp-list '())
      
      (map  (lambda (image)
              (if(string? (cdr image))
                 (set! temp-list 
                       (cons
                        (cons (car image)
                              (make-object bitmap% (cdr image) 'png/alpha))
                        temp-list))
                 (set! temp-list 
                       (cons
                        (cons (car image) (add-anim-image (cdr image)))
                        temp-list))
                 ))
            load-list)
      ;;add to image list as (NAME .  '(('r . IMAGEDATA) ... ('u . IMAGEDATA)))
      (set! image-list (cons
                        (cons name temp-list)
                        image-list)))
    
    ;load data: ("img/red-player/r-" ".png" 5)
    ;returnerar '((0 . IMAGEDATA) ... (5 . IMAGEDATA)))
    (define/private (add-anim-image load-data)
      (define temp-list '())
      (define prefix (car load-data))
      (define file-ending (cadr load-data))
      
      (define (loop i)
        (if(<= i (caddr load-data))
           (begin
             (set! temp-list 
                   (cons
                    (cons i (make-object bitmap% 
                              (string-append 
                               prefix
                               (number->string i) 
                               file-ending) 'png/alpha))
                    temp-list))
             (loop (+ 1 i)))))
      
      (loop 0);;to load from 0
      temp-list)
    
    ;;detektera om ladda flera eller en bild
    ;;samt lägger till dessa i listor för senare bruk.
    (define/public (add-image name image)
      (cond
        ((list? image)
         (add-rot-image name image))
        (else
         (set! image-list (cons
                           (cons name (make-object bitmap% image 'png/alpha))
                           image-list)))))
    
    
    
    ;;retunera en bitmap av en bild från listorna i klassen.
    ;; Söks fram med hjälp av assq
    (define/public (get-image name . args)
      (let ((temp-cons (assq name image-list)))
        (cond
          ((not temp-cons)(error "error, wrong name " name))
          ((and
            (list? (cdr temp-cons));;kollar om det är flera bilder.
            (not (null? args))); och args inte tom
           (get-image-rot (car args) (cdr temp-cons) (cdr args)));; anropar sig själv med flera bild listan.
          ((list? (cdr temp-cons))(error "You need a argument to select image"))
          (else
           (cdr temp-cons)))))
    
    ;;detect if load one or more images. And load a single image
    (define/private (get-image-rot name image-list-2 . args)
      (let ((temp-cons (assq name image-list-2)))
        (cond
          ((not temp-cons)(error "error, wrong name 2"))
          ((and
            (list? (cdr temp-cons));;kollar om det är flera bilder.
            (not (null? args))); och args inte tom
           (get-image-anim (car args) (cdr temp-cons)))
          (else
           (cdr temp-cons)))))
    
    ;;detect if load one or more images. And load a single image
    (define/private (get-image-anim name image-list-2)
      (let ((temp-cons (assq (car name) image-list-2)))
        (cond
          ((not temp-cons)(error "error, wrong name 3" name))
          (else
           (cdr temp-cons)))))))

