(define make-image-store%
  (class object%
    (super-new)
    
    (define image-list '())
    
    ;;add-rot-image name(symbol), load-list list ex:
    ;    '(('r . "img/r.bmp")('l . "img/l.bmp")('d . "img/d.bmp")('u . "img/u.bmp"))
    (define/private (add-rot-image name load-list)
      (define temp-list '())
      
      (map  (lambda (image)
              (set! temp-list (cons
                                (cons (car image) (make-object bitmap% (cdr image) 'unknown #f))
                                temp-list)))
              load-list)
      ;;add to image list as (NAME .  '(('r . IMAGEDATA) ... ('u . IMAGEDATA)))
      (set! image-list (cons
                        (cons name temp-list)
                        image-list))
      )
    
    ;;detect if load one or more images. And load a single image
    (define/public (add-image name image)
      (cond
        ((list? image)
         (add-rot-image name image))
        (else
         (set! image-list (cons
                           (cons name (make-object bitmap% image 'unknown #f))
                           image-list)))
        ))
    
    
    
    ;;detect if load one or more images. And load a single image
    (define/public (get-image name . args)
      (let ((temp-cons (assq name image-list)))
        (cond
          ((not temp-cons)(error "error, wrong name"))
          ((and
            (list? (cdr temp-cons));;kollar om det är flera bilder.
            (not (null? args))); och args inte tom
           (get-image-rot (car args) (cdr temp-cons)));; anropar sig själv med flera bild listan.
          ((list? (cdr temp-cons))(error "You need a argument to select image"))
          (else
           (cdr temp-cons)))
      ))
    
     ;;detect if load one or more images. And load a single image
    (define/private (get-image-rot name image-list-2)
      (let ((temp-cons (assq name image-list-2)))
        (cond
          ((not temp-cons)(error "error, wrong name 2"))
          (else
           (cdr temp-cons)))
      ))
    
    ))

;(define *image-store*
;  (new make-image-store%))

;(send *image-store* add-image 'player '((r . "img/r.bmp")(l . "img/l.bmp")(d . "img/d.bmp")(u . "img/u.bmp")))
;(send *image-store* get-image 'player 'r)
;(assq 'u (list (list 'r "img/r.bmp")(list 'l "img/l.bmp")(list 'd "img/d.bmp")(list 'u "img/u.bmp")))
;(list? (cadr (list (list 'r "img/r.bmp")(list 'l "img/l.bmp")(list 'd "img/d.bmp")(list 'u "img/u.bmp"))))