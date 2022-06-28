;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Author: Sebastián Romero Cruz                                                                       ;;
;; Summer 2022                                                                                         ;;
;; Cassette                                                                                            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 1. ines directives                                                                                  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    .inesprg 1
    .ineschr 1
    .inesmap 0
    .inesmir 1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 2. Helper and macros files                                                                          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    .include "assets/helper/addresses.h"
    .include "assets/helper/constants.h"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 3. Variables                                                                                        ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    .rsset VARLOC
backgroundLowByte   .rs 1
backgroundHighByte  .rs 1
NO_SKIP               .rs 1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 5. Reset                                                                                            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    .bank 0
    .org CPUADR

RESET:
    ;; Housecleaning
    SEI
    CLD

    ;; Disable APU
    LDX APU_RESET
    STX CNTRLRTWO

    ;; Initialise stack
    LDX STACK_INIT
    TXS                 ; transfer X register value to stack pointer

    ;; Disable NMI, PPU Mask, and DMC IRQ
    LDX #ZERO
    STX PPUCTRL
    STX PPUMASK
    STX DELMODADDR

    LDA #$00
    STA NO_SKIP

    ;; Subroutines
    JSR LoadBackground
    JSR LoadAttributes
    JSR LoadPalettes
    JSR LoadSprites

    ;; Re-enable NMI
    LDA #NMI_ENABLE
    STA PPUCTRL

    ;; Re-enable PPU Mask
    LDA #SPRT_ENBLE
    STA PPUMASK

    ;; Disabling scrolling
    LDA #ZERO
    STA PPUADDR
    STA PPUADDR
    STA PPUSCROLL
    STA PPUSCROLL

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 6. Vertical blanks and memory clear; we do this for every ROM                                       ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
VBlankOne:
    BIT PPUSTATUS
    BPL VBlankOne

ClearMem:
    LDA #ZERO
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 7. Subroutines (load background, palettes, etc.)                                                    ;;
;;      - IniniteLoop                                                                                  ;;
;;      - LoadBackground                                                                               ;;
;;      - LoadAttributes                                                                               ;;
;;      - LoadPalettes                                                                                 ;;
;;      - LoadSprites                                                                                  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
InfiniteLoop:
    JMP InfiniteLoop

LoadBackground:
    ;;;; TODO - load background
    ;; Reset PPU
    LDA PPUSTATUS

    ;; Tell the PPU where to load data (do it twice for necessary 2 bytes)
    LDA #BG_PORT
    STA PPUADDR
    LDA #ZERO
    STA PPUADDR

    ;; Load the low and high bytes of the background into our variables
    LDA #LOW(background)
    STA backgroundLowByte
    LDA #HIGH(background)
    STA backgroundHighByte

    ;; Loop through the background memory banks
    LDX #ZERO
    LDY #ZERO
.Loop:
    ;; Store that current byte into the PPU
    LDA [backgroundLowByte],Y
    STA PPUDATA

    ;; Keep y++ until overflow
    INY
    CPY #ZERO
    BNE .Loop

    ;; Keep x++ until .Loop iterates four times to cover the necessary bytes (1024)
    INC backgroundHighByte
    INX
    CPX #$04
    BNE .Loop

    ;; Returns
    RTS

LoadAttributes:
    LDA PPUSTATUS

    ;; Tell PPU where to store attribute data (16-bit address)
    LDA #ATTR_APORT
    STA PPUADDR
    LDA #ATTR_BPORT
    STA PPUADDR

    LDX #$00
.Loop:
    LDA attributes,X
    STA PPUDATA

    INX
    CPX #ATTRB_SIZE
    BNE .Loop

    RTS

LoadPalettes:
    LDA PPUSTATUS

    ;; Tell PPU where to store the palette data
    LDA #PLTTE_PORT
    STA PPUADDR
    LDA #$00
    STA PPUADDR

    LDX #$00
.Loop:
    LDA palettes,X
    STA PPUDATA

    INX
    CPX #PLTTE_SIZE
    BNE .Loop

    RTS

LoadSprites:
    LDX #$00
.Loop:
    LDA sprites,X
    STA SPRITE_RAM,X

    INX
    CPX SPRITE_SIZE
    BNE .Loop

    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 8. NMI                                                                                              ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
NMI:
    ;; Load the low and high sprite bytes to their respective addresses
    LDA #SPRITE_LOW
    STA NMI_LO_ADDR

    LDA #SPRITE_HI
    STA NMI_HI_ADDR

    JSR RotateText

    RTI

RotateText:
    LDA NO_SKIP
    CMP #$01
    BNE .Skip

    CLC
    LDA C_TL_X
    ADC #$01
    STA C_TL_X

    CLC
    LDA A_TL_X
    ADC #$01
    STA A_TL_X

    CLC
    LDA S1_TL_X
    ADC #$01
    STA S1_TL_X

    CLC
    LDA S2_TL_X
    ADC #$01
    STA S2_TL_X

    CLC
    LDA E1_TL_X
    ADC #$01
    STA E1_TL_X

    CLC
    LDA T1_TL_X
    ADC #$01
    STA T1_TL_X

    CLC
    LDA T2_TL_X
    ADC #$01
    STA T2_TL_X

    CLC
    LDA E2_TL_X
    ADC #$01
    STA E2_TL_X

    SEC
    LDA NO_SKIP
    SBC #$01
    STA NO_SKIP

    JMP .Move

.Skip:
    CLC
    LDA NO_SKIP
    ADC #$01
    STA NO_SKIP

.Move:
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 9. Sprite bank files                                                                                ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    .bank 1
    .org IRQRD

background:
    .include "assets/banks/background.asm"

attributes:
    .include "assets/banks/attributes.asm"

palettes:
    .include "assets/banks/palettes.asm"

sprites:
    .include "assets/banks/sprites.asm"

    .org IRQRE
    .dw NMI
    .dw RESET
    .dw 0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 10. Sprite bank data (chr file)                                                                     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    .bank 2
    .org $0000
    .incbin "assets/graphics/graphics.chr"