;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Author: Sebastián Romero Cruz ;;
;; Spring 2022                   ;;
;; Constants                     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ZERO        = $00

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; APU RESET AND STACK   ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;
APU_RESET   = $40
STACK_INIT  = $FF
NMI_ENABLE  = %10000000
SPRT_ENBLE  = %00011110

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SUBROUTINES           ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Background
BG_PORT     = $20

; Palette
PLTTE_PORT  = $3F
PLTTE_SIZE  = $20

; Attributes
ATTR_APORT  = $23
ATTR_BPORT  = $C0
ATTRB_SIZE  = $40

; Sprites
SPRITE_RAM  = $0300
SPRITE_SIZE = $18
SPRITE_LOW  = $00
SPRITE_HI   = $03
NMI_LO_ADDR = OAMADDR
NMI_HI_ADDR = SPRITEDMA

; Controller Input
CTRL_1_PORT = $01
BINARY_ONE  = %00000001

CASSETTE_STRT = $0300
CASSETTE_SIZE = $30
BNCE_ANIM_TMR = $06

STRNG_STRT = $0333
STRNG_SIZE = $20
CHAR_GAP   = $04

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; BORDER BOUNDARIES     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;
BRDR_UP_LFT = $01
BORDER_DOWN = $E7
BORDER_RGHT = $FA