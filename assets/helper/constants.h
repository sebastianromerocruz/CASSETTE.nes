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
BBLE_TL_Y_1 = $0300
BBLE_TL_A_1 = $0302
BBLE_TL_Y_2 = $0304
BBLE_TL_Y_3 = $0308
BBLE_TL_Y_4 = $030C
BBLE_TL_Y_5 = $0310
BBLE_TL_Y_6 = $0314

BBLE_TL_X_1 = $0303
BBLE_TL_X_2 = $0307
BBLE_TL_X_3 = $030B
BBLE_TL_X_4 = $030F
BBLE_TL_X_5 = $0313
BBLE_TL_X_6 = $0317

C_TL_X  = $0333
A_TL_X  = $0337
S1_TL_X = $033B
S2_TL_X = $033F
E1_TL_X = $0343
T1_TL_X = $0347
T2_TL_X = $034B
E2_TL_X = $034F

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; BORDER BOUNDARIES     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;
BRDR_UP_LFT = $01
BORDER_DOWN = $E7
BORDER_RGHT = $FA