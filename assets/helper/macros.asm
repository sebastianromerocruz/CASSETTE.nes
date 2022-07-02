;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; M A C R O S . a s m                                                                                 ;;
;; ——————————————————————————————————————————————————————————————————————————————————————————————————— ;;
;; Author: Sebastián Romero Cruz                                                                       ;;
;; Summer 2022                                                                                         ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Title:           Clear Memory                                  ;;
;; Name:            CLEARMEM                                      ;;
;; —————————————————————————————————————————————————————————————— ;;
;; Purpose:         Performs routine vertical blanks and memory   ;;
;;                  clearing at the beginning of every ROM run.   ;;
;;                                                                ;;
;; Parameters:      None                                          ;;
;; Time:            Varies                                        ;;
;; Size:            ~30 bytes                                     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CLEARMEM   .MACRO
            VBlankOne:
                BIT PPUSTATUS
                BPL VBlankOne

            ClearMem:
                LDA #$00
                STA $0100,X
                STA $0200,X
                STA $0400,X
                STA $0500,X
                STA $0600,X
                STA $0700,X
                LDA #$FE
                STA $0300,X

                INX
                BNE ClearMem

            VBlankTwo:
                BIT PPUSTATUS
                BPL VBlankTwo
           .ENDM

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Title:           Boolean NOT (!)                               ;;
;; Name:            NOT                                           ;;
;; —————————————————————————————————————————————————————————————— ;;
;; Purpose:         Negates a binary flag, where 1 represents a   ;;
;;                  boolean true and 0 a boolean false.           ;; 
;;                      i.e. flag = !flag                         ;;
;;                                                                ;;
;; Parameters:      \1: The address of the binary flag            ;;
;; Time:            9 Cycles                                      ;;
;; Size:            8 bytes                                       ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
NOT     .MACRO
         LDA \1
         EOR #$FF
         AND #$01
         STA \1
        .ENDM