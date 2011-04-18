;; -------------------------------------------------------------------------
;; client-example.scm - version 0.1
;; A scheme chat client. See server-example.scm for the server
;;
;; Created by: Joakim Hellsten joahe@ida.liu.se 
;; Last updated: 2003-11-06
;; -------------------------------------------------------------------------
;; Instructions:
;;
;; Change *hostname* and *port* if needed. 
;; Connect to the server with (connect "username").
;; Send messages with (send "a message string").
;; Disconnect with (disconnect)
;;
;; Obviously the server has to be started before you can connect
;; to it, so do that first. 

;; -------------------------------------------------------------------------
;; Some useful global variables 
;; -------------------------------------------------------------------------   
(define client%
  (class object%
    (super-new)
    (init-field hostname port)
    (define inport '())
    (define outport '())
    
    (define listen-thread '()) 
    
    ;; -------------------------------------------------------------------------
    
    ;; sends a message, message should be a string.
    (define/public (send  message) 
      (write message outport)
      (flush-output outport))
    
    ;; act as client - connect to a listening computer
    (define/public (connect name)
      (set!-values (inport outport) (tcp-connect hostname port))
      (write name outport)
      (flush-output outport)
      (set! listen-thread (thread listen-for-data))
      (display "Connected to server") (newline))
    
    ;; used for reading incoming messages continously
    ;; (with the help of a thread, otherwise (read inport) would block).
    (define (listen-for-data)
      (when (null? inport) (error "Not connected to a server"))
      (let ((message ""))
        (define (loop)
          (set! message (read inport))
          (if (eof-object? message) 
              (begin 
                (tcp-abandon-port inport)
                (tcp-abandon-port outport)
                (display "Connection closed by server.") (newline)
                (kill-thread (current-thread))) ;; probably not needed ...
              (begin
                (display message) (newline)
                (loop))))
        (loop)))
    
    ;; stop listening and disconnect from the server.
    (define/private (disconnect)
      (kill-thread listen-thread)
      (tcp-abandon-port inport)
      (tcp-abandon-port outport)
      (display "Disconnected from server.") (newline))))
  
(define my-client (new client% 
                       [hostname "localhost"]
                       [port 65009]))
(define my-client2 (new client% 
                       [hostname "localhost"]
                       [port 65009]))

(send my-client connect "Johan")

(send my-client2 connect "Johan2")
		     
(send my-client send "hej")
(send my-client2 send "hej hej hej")
