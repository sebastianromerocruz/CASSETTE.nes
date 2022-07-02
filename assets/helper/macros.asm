;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; M A C R O S                                                    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Title:           Boolean NOT (!)                               ;;
;; Name:            NOT                                           ;;
;;                                                                ;;
;; Purpose:         Negates a binary flag, representing a boolean ;;
;;                  true (1) and false (0) i.e. flag = !flag      ;;
;;                                                                ;;
;; Parameters:      VAL: The address of the binary flag           ;;
;; Time:            9 Cycles                                      ;;
;; Size:            8 bytes                                       ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
NOT    .MACRO VAL
        LDA VAL
        EOR #$FF
        AND #$01
        STA VAL 
       .ENDM