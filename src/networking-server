(require racket/tcp)



(define client%
  (class object%
    (super-new)
    (init-field name inport outport listen-thread)))

(define server%
  (class object%
    (super-new)
    (init-field port)
    ;;list of clients, representet as in client%
    (define clients '())
    (define server-listen-thread null)
    
    ;; starts the server
    (define/public (start-server)  
      (set! server-listen-thread (thread listen-loop))
      (display "Server started.") (newline))
    
    (define/public (shutdown-server)
      ;;make brodcast function to inform clients
      (kill-thread server-listen-thread)
      (map  (lambda (proc)
              (kill-thread (get-field listen-thread proc));;kill tread
              (tcp-abandon-port (get-field inport proc));;kill ports
              (tcp-abandon-port (get-field outport proc))
              (remove-client proc);;remove client
              )
            clients))
    
    ;; sends a message to all clients, where name is the sender
    (define (broadcast name message)
      (map  (lambda (proc)
              (display (string-append "Broadcasting message to " (get-field name proc) ".")) (newline)
              (write (string-append name " says: " message) (get-field outport proc))
              (newline (get-field outport proc))
              (flush-output (get-field outport proc))
              )
            clients)
      )
    
    ;; used for threads for each connection
    (define/private (listen-for-messages client inport outport) 
      (define (loop) 
        (let ((message (read inport)))
          (if (eof-object? message)
              (begin 
                (display (string-append client " sent <eof>. Closing.")) (newline)
                (tcp-abandon-port inport)
                (tcp-abandon-port outport)
                (remove-client client)
                (broadcast "Server" (string-append "Goodbye " client "."))
                (display (string-append client " removed.")) (newline)
                (kill-thread (current-thread)))
              (begin
                (display (string-append client " sent: " message)) (newline)
                (broadcast client message)
                (loop)))))
      (loop))
    
    ;; add client
    (define/private (add-client client)  
      (set! clients (cons client clients)))
    ;; remove client
    (define/private (remove-client client)  
      (set! clients (remv client clients)))
    
    ;; thread for listening and accepting clients
    (define (listen-loop) 
      (let ((listener (tcp-listen port 10 #t)))
        (define (loop)
          (display "Listener waiting for connections attempts.") (newline)
          ;;waiting and if connection, setting these values:
          (let*-values (((temp-inport temp-outport) (tcp-accept listener))
                        ((temp-name) (read temp-inport)) ;; we assume that the client will send a name when connecting
                        ((temp-listen-thread) (thread (lambda () (listen-for-messages temp-name temp-inport temp-outport))))
                        ((temp-client) (new client% 
                                            [name temp-name]
                                            [inport temp-inport]
                                            [outport temp-outport]
                                            [listen-thread temp-listen-thread]))
                        )
            (add-client temp-client);;adding newly connected client.
            (display (string-append temp-name " connected.")) (newline)
            (broadcast "Server" (string-append "Hello " temp-name "."))))
          (loop))
      (loop))
    
    
    ))

(define my-server (new server% 
                       [port 65009]))
(send my-server start-server)
