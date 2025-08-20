; https://github.com/zakki0925224/vul16-asm - vul16 assembler
; Breakout Game

; MMIO_BTN = 0xf002
; MMIO_LCD = 0xf004~

; LCD reference
; +0: Ascii code (8bit)
; +1: Background color (4bit) | Foreground color (4bit)
; 4bit Color code:
;   0: Black
;   1: Blue
;   2: Green
;   3: Cyan
;   4: Red
;   5: Magenta
;   6: Brown
;   7: Light Gray
;   8: Dark Gray
;   9: Light Blue
;   a: Light Green
;   b: Light Cyan
;   c: Light Red
;   d: Light Magenta
;   e: Yellow
;   f: White

.macro SET_MMIO_BTN_ADDR_TO_R2()
    addi r2, r0, 0xf ; 0x000f
    slli r2, r2, 12  ; 0xf000
    addi r2, r2, 2   ; 0xf002
.end_macro

.macro SET_MMIO_LCD_ADDR_TO_R2()
    addi r2, r0, 0xf ; 0x000f
    slli r2, r2, 12  ; 0xf000
    addi r2, r2, 4   ; 0xf004
.end_macro

.macro SET_MMIO_LCD_ASCII_SPACE_TO_R3()
    addi r3, r0, 1  ; 0x01
    slli r3, r3, 5  ; 0x20 - ascii ' '
.end_macro

.macro SET_MMIO_LCD_ASCII_B_TO_R3()
    addi r3, r0, 1 ; 0x01
    slli r3, r3, 6 ; 0x40
    addi r3, r3, 2 ; 0x42 - ascii 'B'
.end_macro

.macro SET_MMIO_LCD_ASCII_r_TO_R3()
    addi r3, r0, 7 ; 0x07
    slli r3, r3, 4 ; 0x70
    addi r3, r3, 2 ; 0x72 - ascii 'r'
.end_macro

.macro SET_MMIO_LCD_ASCII_e_TO_R3()
    addi r3, r0, 6 ; 0x06
    slli r3, r3, 4 ; 0x60
    addi r3, r3, 5 ; 0x65 - ascii 'e'
.end_macro

.macro SET_MMIO_LCD_ASCII_a_TO_R3()
    addi r3, r0, 6 ; 0x06
    slli r3, r3, 4 ; 0x60
    addi r3, r3, 1 ; 0x61 - ascii 'a'
.end_macro

.macro SET_MMIO_LCD_ASCII_k_TO_R3()
    addi r3, r0, 6   ; 0x06
    slli r3, r3, 4   ; 0x60
    addi r3, r3, 0xb ; 0x6b - ascii 'k'
.end_macro

.macro SET_MMIO_LCD_ASCII_o_TO_R3()
    addi r3, r0, 6   ; 0x06
    slli r3, r3, 4   ; 0x60
    addi r3, r3, 0xf ; 0x6f - ascii 'o'
.end_macro

.macro SET_MMIO_LCD_ASCII_u_TO_R3()
    addi r3, r0, 7 ; 0x07
    slli r3, r3, 4 ; 0x70
    addi r3, r3, 5 ; 0x75 - ascii 'u'
.end_macro

.macro SET_MMIO_LCD_ASCII_t_TO_R3()
    addi r3, r0, 7 ; 0x07
    slli r3, r3, 4 ; 0x70
    addi r3, r3, 4 ; 0x74 - ascii 't'
.end_macro

.macro SET_MMIO_LCD_ASCII_EQ_TO_R3()
    addi r3, r0, 3   ; 0x03
    slli r3, r3, 4   ; 0x30
    addi r3, r3, 0xd ; 0x3d - ascii '='
.end_macro

.macro SET_MMIO_LCD_ASCII_SHARP_TO_R3()
    addi r3, r0, 2 ; 0x02
    slli r3, r3, 4 ; 0x20
    addi r3, r3, 3 ; 0x23 - ascii '#'
.end_macro

.macro SET_MMIO_LCD_ASCII_L_SB_TO_R3()
    addi r3, r0, 5   ; 0x05
    slli r3, r3, 4   ; 0x50
    addi r3, r3, 0xb ; 0x5b - ascii '['
.end_macro

.macro SET_MMIO_LCD_ASCII_R_SB_TO_R3()
    addi r3, r0, 5   ; 0x05
    slli r3, r3, 4   ; 0x50
    addi r3, r3, 0xd ; 0x5d - ascii ']'
.end_macro

.macro SET_MMIO_LCD_BGFG_TO_R4()
    addi r4, r0, 0xf ; BG: 0x0 (black) | FG: 0xf (white)
    slli r4, r4, 8
.end_macro

.macro WRITE_BLOCK()
    ; r2 = MMIO_LCD_ADDR
    SET_MMIO_LCD_BGFG_TO_R4()

    ; ===== [ =====
    SET_MMIO_LCD_ASCII_L_SB_TO_R3()
    or r3, r3, r4
    sw r3, r2, 0 ; set
    addi r2, r2, 2

    ; ===== # =====
    SET_MMIO_LCD_ASCII_SHARP_TO_R3()
    or r3, r3, r4
    sw r3, r2, 0 ; set
    addi r2, r2, 2

    ; ===== # =====
    sw r3, r2, 0 ; set
    addi r2, r2, 2

    ; ===== ] =====
    SET_MMIO_LCD_ASCII_R_SB_TO_R3()
    or r3, r3, r4
    sw r3, r2, 0 ; set
    addi r2, r2, 2
.end_macro

.macro RESET_TITLE()
    SET_MMIO_LCD_ADDR_TO_R2()
    addi r4, r0, 3 ; 0x03
    slli r4, r4, 4 ; 0x30
    addi r4, r4, 4 ; 0x34
    add r2, r2, r4 ; offset + 0x34

    SET_MMIO_LCD_BGFG_TO_R4()

    ; ===== space =====
    SET_MMIO_LCD_ASCII_SPACE_TO_R3()
    or r3, r3, r4
    sw r3, r2, 0 ; set
    addi r2, r2, 2

    ; ===== B =====
    SET_MMIO_LCD_ASCII_B_TO_R3()
    or r3, r3, r4
    sw r3, r2, 0 ; set
    addi r2, r2, 2

    ; ===== r =====
    SET_MMIO_LCD_ASCII_r_TO_R3()
    or r3, r3, r4
    sw r3, r2, 0 ; set
    addi r2, r2, 2

    ; ===== e =====
    SET_MMIO_LCD_ASCII_e_TO_R3()
    or r3, r3, r4
    sw r3, r2, 0 ; set
    addi r2, r2, 2

    ; ===== a =====
    SET_MMIO_LCD_ASCII_a_TO_R3()
    or r3, r3, r4
    sw r3, r2, 0 ; set
    addi r2, r2, 2

    ; ===== k =====
    SET_MMIO_LCD_ASCII_k_TO_R3()
    or r3, r3, r4
    sw r3, r2, 0 ; set
    addi r2, r2, 2

    ; ===== o =====
    SET_MMIO_LCD_ASCII_o_TO_R3()
    or r3, r3, r4
    sw r3, r2, 0 ; set
    addi r2, r2, 2

    ; ===== u =====
    SET_MMIO_LCD_ASCII_u_TO_R3()
    or r3, r3, r4
    sw r3, r2, 0 ; set
    addi r2, r2, 2

    ; ===== t =====
    SET_MMIO_LCD_ASCII_t_TO_R3()
    or r3, r3, r4
    sw r3, r2, 0 ; set
    addi r2, r2, 2
.end_macro

.macro RESET_BLOCKS()
    SET_MMIO_LCD_ADDR_TO_R2()
    ; offset + 240
    addi r4, r0, 0xf
    slli r4, r4, 4
    add r2, r2, r4

    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()

    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()

    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()

    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()

    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()

    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
    WRITE_BLOCK()
.end_macro

j #main

main:
    RESET_TITLE()
    RESET_BLOCKS()
