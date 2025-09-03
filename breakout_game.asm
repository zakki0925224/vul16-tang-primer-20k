; https://github.com/zakki0925224/vul16-asm - vul16 assembler
; Breakout Game

; Button 2 - Move paddle right
; Button 3 - Move paddle left

; Game state at 0xe000
;  +0: paddle_x_offset (i16) (default: 0) (original position)
;  +2: ball_x_offset (u16) (default: 29) (global position)
;  +4: ball_y_offset (u16) (default: 13)
;  +6: ball_move_direction (u16) (default: 0)
;       bit2: 0=vertical-major, 1=horizontal-major (reserved)
;       bit1: vertical dir (0=up, 1=down)
;       bit0: horizontal dir (0=right, 1=left)
;  +8: ball_step_accum (u16) (0..2) (default: 0)
; +10: block_map_0 (u16) (default: 0x7fff)
; +12: block_map_1 (u16) (default: 0x7fff)
; +14: block_map_2 (u16) (default: 0x7fff)
; +16: block_map_3 (u16) (default: 0x7fff)
; +18: block_map_4 (u16) (default: 0x7fff)
; +20: block_map_5 (u16) (default: 0x7fff)
; +22: game_over_flag (u16) (default: 0)

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

.macro SET_MMIO_LCD_ASCII_G_TO_R3()
    addi r3, r0, 4 ; 0x04
    slli r3, r3, 4 ; 0x40
    addi r3, r3, 7 ; 0x47 - ascii 'G'
.end_macro

.macro SET_MMIO_LCD_ASCII_A_TO_R3()
    addi r3, r0, 4 ; 0x04
    slli r3, r3, 4 ; 0x40
    addi r3, r3, 1 ; 0x41 - ascii 'A'
.end_macro

.macro SET_MMIO_LCD_ASCII_M_TO_R3()
    addi r3, r0, 4 ; 0x04
    slli r3, r3, 4 ; 0x40
    addi r3, r3, 0xd ; 0x4d - ascii 'M'
.end_macro

.macro SET_MMIO_LCD_ASCII_E_TO_R3()
    addi r3, r0, 4 ; 0x04
    slli r3, r3, 4 ; 0x40
    addi r3, r3, 5 ; 0x45 - ascii 'E'
.end_macro

.macro SET_MMIO_LCD_ASCII_O_TO_R3()
    addi r3, r0, 4 ; 0x04
    slli r3, r3, 4 ; 0x40
    addi r3, r3, 0xf ; 0x4f - ascii 'O'
.end_macro

.macro SET_MMIO_LCD_ASCII_V_TO_R3()
    addi r3, r0, 5 ; 0x05
    slli r3, r3, 4 ; 0x50
    addi r3, r3, 6 ; 0x56 - ascii 'V'
.end_macro

.macro SET_MMIO_LCD_ASCII_R_TO_R3()
    addi r3, r0, 5 ; 0x05
    slli r3, r3, 4 ; 0x50
    addi r3, r3, 2 ; 0x52 - ascii 'R'
.end_macro

.macro SET_MMIO_LCD_ASCII_EX_TO_R3()
    addi r3, r0, 2 ; 0x02
    slli r3, r3, 4 ; 0x20
    addi r3, r3, 1 ; 0x21 - ascii '!'
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

.macro SET_MMIO_LCD_BGFG_DEFAULT_TO_R4()
    addi r4, r0, 0xf ; BG: 0x0 (black) | FG: 0xf (white)
    slli r4, r4, 8
.end_macro

.macro SET_MMIO_LCD_BGFG_CUSTOM_TO_R4($bg, $fg)
    addi r4, r0, $bg
    slli r4, r4, 4
    addi r4, r4, $fg
    slli r4, r4, 8
.end_macro

.macro SET_GAME_STATE_ADDR_TO_R5()
    addi r5, r0, 0xe ; 0x000e
    slli r5, r5, 12  ; 0xe000
.end_macro

; 32767 * 8 counts delay
.macro DELAY()
    addi r6, r0, 0x7   ; 0x0007
    slli r6, r6, 4     ; 0x0070
    addi r6, r6, 0xf   ; 0x007f
    slli r6, r6, 4     ; 0x07f0
    addi r6, r6, 0xf   ; 0x07ff
    slli r6, r6, 4     ; 0x7ff0
    addi r6, r6, 0xf   ; 0x7fff

    addi r7, r0, 0x8   ; 0x0008

    addi r6, r6, -1

    beq  r6, r0, 4
    jmp  r0, -4

    addi r7, r7, -1

    beq  r7, r0, 4
    jmp  r0, -10
.end_macro

.macro WRITE_BLOCK()
    ; r2 = MMIO_LCD_ADDR
    ; r4 = BGFG

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

.macro CLEAR_BLOCK()
    ; r2 = MMIO_LCD_ADDR
    SET_MMIO_LCD_BGFG_DEFAULT_TO_R4()
    ; space
    SET_MMIO_LCD_ASCII_SPACE_TO_R3()
    or r3, r3, r4
    sw r3, r2, 0 ; set
    sw r3, r2, 2 ; set
    sw r3, r2, 4 ; set
    sw r3, r2, 6 ; set
.end_macro

.macro RESET_TITLE()
    SET_MMIO_LCD_ADDR_TO_R2()
    ; offset + 50
    addi r4, r0, 0x3
    slli r4, r4, 4
    addi r4, r4, 0x2
    add r2, r2, r4

    SET_MMIO_LCD_BGFG_DEFAULT_TO_R4()

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

.macro SET_GAME_OVER_TITLE()
    SET_MMIO_LCD_ADDR_TO_R2()
    ; offset + 50
    addi r4, r0, 0x3
    slli r4, r4, 4
    addi r4, r4, 0x2
    add r2, r2, r4

    SET_MMIO_LCD_BGFG_DEFAULT_TO_R4()

    ; ===== G =====
    SET_MMIO_LCD_ASCII_G_TO_R3()
    or r3, r3, r4
    sw r3, r2, 0 ; set
    addi r2, r2, 2

    ; ===== A =====
    SET_MMIO_LCD_ASCII_A_TO_R3()
    or r3, r3, r4
    sw r3, r2, 0 ; set
    addi r2, r2, 2

    ; ===== M =====
    SET_MMIO_LCD_ASCII_M_TO_R3()
    or r3, r3, r4
    sw r3, r2, 0 ; set
    addi r2, r2, 2

    ; ===== E =====
    SET_MMIO_LCD_ASCII_E_TO_R3()
    or r3, r3, r4
    sw r3, r2, 0 ; set
    addi r2, r2, 2

    ; ===== space =====
    SET_MMIO_LCD_ASCII_SPACE_TO_R3()
    or r3, r3, r4
    sw r3, r2, 0 ; set
    addi r2, r2, 2

    ; ===== O =====
    SET_MMIO_LCD_ASCII_O_TO_R3()
    or r3, r3, r4
    sw r3, r2, 0 ; set
    addi r2, r2, 2

    ; ===== V =====
    SET_MMIO_LCD_ASCII_V_TO_R3()
    or r3, r3, r4
    sw r3, r2, 0 ; set
    addi r2, r2, 2

    ; ===== E =====
    SET_MMIO_LCD_ASCII_E_TO_R3()
    or r3, r3, r4
    sw r3, r2, 0 ; set
    addi r2, r2, 2

    ; ===== R =====
    SET_MMIO_LCD_ASCII_R_TO_R3()
    or r3, r3, r4
    sw r3, r2, 0 ; set
    addi r2, r2, 2

    ; ===== ! =====
    SET_MMIO_LCD_ASCII_EX_TO_R3()
    or r3, r3, r4
    sw r3, r2, 0 ; set
    addi r2, r2, 2
.end_macro

.macro CLEAR_DISPLAY()
    SET_MMIO_LCD_ADDR_TO_R2()
    ; clear 60 chars * 17 lines
    ; 60 * 17 = 1020 counts loop
    ; set counter to r3
    addi r3, r0, 0x3 ; 0x0003
    slli r3, r3, 4   ; 0x0030
    addi r3, r3, 0xf ; 0x003f
    slli r3, r3, 4   ; 0x03f0
    addi r3, r3, 0xc ; 0x03fc

    sw r0, r2, 0 ; set zero
    addi r2, r2, 2
    ; decrement counter
    addi r3, r3, -1

    ; if r3 == 0, pc += 4
    beq r3, r0, 4
    jmp r0, -8
.end_macro

.macro RESET_GAME()
    ; reset game state
    SET_GAME_STATE_ADDR_TO_R5()
    sw r0, r5, 0   ; paddle_x_offset
    addi r5, r5, 2

    addi r1, r0, 0x1
    slli r1, r1, 4
    addi r1, r1, 0xd
    sw r1, r5, 0     ; ball_x_offset
    addi r5, r5, 2

    addi r2, r0, 0xd
    sw r2, r5, 0     ; ball_y_offset
    addi r5, r5, 2

    sw r0, r5, 0   ; ball_move_direction
    addi r5, r5, 2

    sw r0, r5, 0   ; ball_step_accum
    addi r5, r5, 2

    addi r1, r0, 0x7 ; 0x0007
    slli r1, r1, 4   ; 0x0070
    addi r1, r1, 0xf ; 0x007f
    slli r1, r1, 4   ; 0x07f0
    addi r1, r1, 0xf ; 0x07ff
    slli r1, r1, 4   ; 0x7ff0
    addi r1, r1, 0xf ; 0x7fff
    sw r1, r5, 0     ; block_map_0
    addi r5, r5, 2
    sw r1, r5, 0     ; block_map_1
    addi r5, r5, 2
    sw r1, r5, 0     ; block_map_2
    addi r5, r5, 2
    sw r1, r5, 0     ; block_map_3
    addi r5, r5, 2
    sw r1, r5, 0     ; block_map_4
    addi r5, r5, 2
    sw r1, r5, 0     ; block_map_5
    addi r5, r5, 2
    sw r0, r5, 0   ; game_over_flag

    SET_MMIO_LCD_ADDR_TO_R2()
    ; offset + 240
    addi r4, r0, 0xf
    slli r4, r4, 4
    add r2, r2, r4

    ; =========== write 15 blocks (line 1) ===========
    ; set counter to r5
    addi r5, r0, 0xf

    ; loop
    SET_MMIO_LCD_BGFG_CUSTOM_TO_R4(0x0, 0xc) ; FG = light red, 3 instructions
    WRITE_BLOCK() ; 20 instructions
    ; decrement counter
    addi r5, r5, -1

    ; if r5 == 0, pc += 4
    beq r5, r0, 4

    ; jump to loop top (offset -50)
    jmp r0, -50

    ; =========== write 15 blocks (line 2) ===========
    ; set counter to r5
    addi r5, r0, 0xf

    ; loop
    SET_MMIO_LCD_BGFG_CUSTOM_TO_R4(0x0, 0xa) ; FG = light green, 3 instructions
    WRITE_BLOCK() ; 20 instructions
    ; decrement counter
    addi r5, r5, -1

    ; if r5 == 0, pc += 4
    beq r5, r0, 4

    ; jump to loop top (offset -52)
    jmp r0, -52

    ; =========== write 15 blocks (line 3) ===========
    ; set counter to r5
    addi r5, r0, 0xf

    ; loop
    SET_MMIO_LCD_BGFG_CUSTOM_TO_R4(0x0, 0xb) ; FG = light cyan, 3 instructions
    WRITE_BLOCK() ; 20 instructions
    ; decrement counter
    addi r5, r5, -1

    ; if r5 == 0, pc += 4
    beq r5, r0, 4

    ; jump to loop top (offset -52)
    jmp r0, -52

    ; =========== write 15 blocks (line 4) ===========
    ; set counter to r5
    addi r5, r0, 0xf

    ; loop
    SET_MMIO_LCD_BGFG_CUSTOM_TO_R4(0x0, 0xd) ; FG = light magenta, 3 instructions
    WRITE_BLOCK() ; 20 instructions
    ; decrement counter
    addi r5, r5, -1

    ; if r5 == 0, pc += 4
    beq r5, r0, 4

    ; jump to loop top (offset -52)
    jmp r0, -52

    ; =========== write 15 blocks (line 5) ===========
    ; set counter to r5
    addi r5, r0, 0xf

    ; loop
    SET_MMIO_LCD_BGFG_CUSTOM_TO_R4(0x0, 0x9) ; FG = light blue, 3 instructions
    WRITE_BLOCK() ; 20 instructions
    ; decrement counter
    addi r5, r5, -1

    ; if r5 == 0, pc += 4
    beq r5, r0, 4

    ; jump to loop top (offset -52)
    jmp r0, -52

    ; =========== write 15 blocks (line 6) ===========
    ; set counter to r5
    addi r5, r0, 0xf

    ; loop
    SET_MMIO_LCD_BGFG_CUSTOM_TO_R4(0x0, 0xe) ; FG = yellow, 3 instructions
    WRITE_BLOCK() ; 20 instructions
    ; decrement counter
    addi r5, r5, -1

    ; if r5 == 0, pc += 4
    beq r5, r0, 4

    ; jump to loop top (offset -52)
    jmp r0, -52
.end_macro

.macro MOVE_PADDLE()
    ; read game state paddle_x_offset to r6
    SET_GAME_STATE_ADDR_TO_R5()
    lw r6, r5, 0

    ; read button state to r7
    SET_MMIO_BTN_ADDR_TO_R2()
    lbu r7, r2, 0

    ; button 2 (bit 1) - move right
    andi r4, r7, 0b10
    addi r3, r0, 0b10

    ; r6 clip min = -28
    addi r1, r0, 0xf ; 0x000f
    slli r1, r1, 4   ; 0x00f0
    addi r1, r1, 0xf ; 0x00ff
    slli r1, r1, 4   ; 0x0ff0
    addi r1, r1, 0xe ; 0x0ffe
    slli r1, r1, 4   ; 0xffe0
    addi r1, r1, 0x4 ; 0xffe4

    ; if r4 != r3, pc += 6
    bne r4, r3, 6

    ; if r1 >= r6, pc += 4
    bge r1, r6, 4

    addi r6, r6, -1

    ; button 3 (bit 2) - move left
    andi r4, r7, 0b100
    addi r3, r0, 0b100

    ; r6 clip max = 27
    addi r7, r0, 0x1 ; 0x0001
    slli r7, r7, 4   ; 0x0010
    addi r7, r7, 0xb ; 0x001b

    ; if r4 != r3, pc += 6
    bne r4, r3, 6

    ; if r6 >= r7, pc += 4
    bge r6, r7, 4

    addi r6, r6, 1

    ; update state
    sw r6, r5, 0

    ; clear paddle
    SET_MMIO_LCD_ADDR_TO_R2()
    ; offset + 60 chars * 14 lines * 2 bytes = 1680 (0x690)
    addi r1, r0, 6 ; 0x0006
    slli r1, r1, 4 ; 0x0060
    addi r1, r1, 9 ; 0x0069
    slli r1, r1, 4 ; 0x0690
    add r2, r2, r1  ; 0xf004 + 0x0690 = 0xf694

    SET_MMIO_LCD_ASCII_SPACE_TO_R3()
    SET_MMIO_LCD_BGFG_DEFAULT_TO_R4()
    or r3, r3, r4

    ; set decrement counter 60
    addi r5, r0, 3   ; 0x0003
    slli r5, r5, 4   ; 0x0030
    addi r5, r5, 0xc ; 0x003c

    sw r3, r2, 0 ; set

    ; decrement counter
    addi r5, r5, -1
    ; increment offset
    addi r2, r2, 2
    ; if r5 == 0, pc += 4
    beq r5, r0, 4
    jmp r0, -8

    ; write paddle
    ; offset - 33 chars * 2 = 66 (0x42)
    addi r5, r0, 4 ; 0x0004
    slli r5, r5, 4 ; 0x0040
    addi r5, r5, 2 ; 0x0042
    sub r2, r2, r5
    ; offset - r6 * 2 chars
    slli r6, r6, 1
    sub r2, r2, r6

    SET_MMIO_LCD_ASCII_EQ_TO_R3()
    or r3, r3, r4

    sw r3, r2, 0 ; set
    addi r2, r2, 2
    sw r3, r2, 0 ; set
    addi r2, r2, 2
    sw r3, r2, 0 ; set
    addi r2, r2, 2
    sw r3, r2, 0 ; set
    addi r2, r2, 2
    sw r3, r2, 0 ; set
.end_macro

.macro MOVE_BALL()
    ; read game state (ball_x_offset, ball_y_offset)
    SET_GAME_STATE_ADDR_TO_R5()
    addi r5, r5, 2          ; point to ball_x_offset
    lw   r6, r5, 0          ; r6 = ball_x
    lw   r7, r5, 2          ; r7 = ball_y

    ; clear old ball
    SET_MMIO_LCD_ADDR_TO_R2()
    addi r3, r0, 0          ; accumulator = 0
    addi r4, r0, 0x3
    slli r4, r4, 4
    addi r4, r4, 0xc        ; r4 = 60
    add  r1, r0, r7         ; r1 = y (loop counter)

    ; y * 60 (does not destroy r7)
    beq  r1, r0, 8
    add  r3, r3, r4
    addi r1, r1, -1
    jmp  r0, -6

    add  r3, r3, r6
    slli r3, r3, 1          ; *2 (bytes per cell)
    add  r2, r2, r3         ; address of old ball

    SET_MMIO_LCD_ASCII_SPACE_TO_R3()
    SET_MMIO_LCD_BGFG_DEFAULT_TO_R4()
    or   r3, r3, r4
    sw   r3, r2, 0          ; clear old ball

    ; update ball position
    lw r3, r5, 4            ; r3 = ball_move_direction
    lw r4, r5, 6            ; r4 = ball_step_accum

    ; if not reached the screen top (y = 2)
    addi r1, r0, 2
    ; r7 != r0, pc += 4
    bne r7, r1, 4
    ; ===== reached the screen top =====
    ; if moving up, reverse vertical dir
    xori r3, r3, 0b10
    ; ==================================
    ; if reached the screen right
    ; r6 < 59, pc += 4
    addi r1, r0, 3
    slli r1, r1, 4
    addi r1, r1, 0xb
    blt r6, r1, 4
    ; ===== reached the screen right =====
    ; horizontal dir = 1 (left)
    ori r3, r3, 0b1
    ; ====================================

    ; if reached the screen left
    ; r6 != 0, pc += 4
    bne r6, r0, 4
    ; ===== reached the screen right =====
    ; horizontal dir = 0 (right)
    andi r3, r3, 0b110
    ; ====================================

    ; if reached the screen bottom -> game over
    ; r7 < 16, pc += 12
    addi r1, r0, 1
    slli r1, r1, 4
    blt r7, r1, 12
    addi r1, r0, 1
    addi r5, r5, 15
    addi r5, r5, 5
    sw r1, r5, 0
    jmp r0, 122

    ; paddle_x
    ; if moving down && ball_y == 13 && (-paddle_x + 27 <= ball_x <= -paddle_x + 31)
    addi r1, r0, 0b10
    and r1, r1, r3
    ; if r1 != r0, pc += 4
    bne r1, r0, 4
    jmp r0, 32

    ; if ball_y == 13, pc += 4
    addi r1, r0, 13
    beq r7, r1, 4
    jmp r0, 26

    ; read paddle_x
    lw r1, r5, -2           ; r1 = paddle_x_offset
    sub r1, r0, r1          ; r1 = -paddle_x_offset
    addi r2, r0, 1
    slli r2, r2, 4
    addi r2, r2, 0xb        ; 0x1b + 27
    add r1, r1, r2

    ; if ball_x >= paddle_x
    bge r6, r1, 4
    jmp r0, 10

    addi r1, r1, 4
    ; if paddle_x >= ball_x
    bge r1, r6, 4
    jmp r0, 4

    ; if moving down and ball on paddle, reverse vertical dir
    xori r3, r3, 0b10

    ; =======================================
    andi r2, r3, 0b10
    beq r2, r0, 6
    addi r7, r7, 1
    jmp r0, 4
    addi r7, r7, -1

    addi r4, r4, 1

    addi r2, r0, 3
    ; if r4 == r2, pc += 4
    beq  r4, r2, 4
    jmp r0, 14
    ; reset accum
    addi r4, r0, 0

    andi r2, r3, 1
    bne r2, r0, 6
    addi r6, r6, 1
    jmp r0, 4
    addi r6, r6, -1

    ; store new state
    sw  r3, r5, 4
    sw  r4, r5, 6

    ; draw new ball
    SET_MMIO_LCD_ADDR_TO_R2()
    addi r3, r0, 0
    addi r4, r0, 0x3
    slli r4, r4, 4
    addi r4, r4, 0xc        ; r4 = 60
    add  r1, r0, r7         ; r1 = new y (loop counter)

    ; new_y * 60
    beq  r1, r0, 8
    add  r3, r3, r4
    addi r1, r1, -1
    jmp  r0, -6

    add  r3, r3, r6
    slli r3, r3, 1
    add  r2, r2, r3

    SET_MMIO_LCD_ASCII_o_TO_R3()
    SET_MMIO_LCD_BGFG_DEFAULT_TO_R4()
    or   r3, r3, r4
    sw   r3, r2, 0          ; draw new ball

    ; store new state
    sw   r6, r5, 0          ; ball_x (unchanged yet)
    sw   r7, r5, 2          ; ball_y (updated)
.end_macro

.macro BLOCK_COLLISION()
    ; read ball_x_offset, ball_y_offset, ball_move_direction
    SET_GAME_STATE_ADDR_TO_R5()
    addi r5, r5, 2          ; point to ball_x_offset
    lw r4, r5, 0            ; r4 = ball_x
    lw r6, r5, 2            ; r6 = ball_y
    lw r7, r5, 4            ; r7 = ball_move_direction

    ; convert to block position
    srli r4, r4, 2          ; block_x = ball_x / 4
    addi r6, r6, -2         ; block_y = ball_y - 2

    ; read block_map[block_y]
    addi r5, r5, 8
    slli r6, r6, 1          ; block_y * 2 (byte offset)
    add r5, r5, r6
    lw r3, r5, 0           ; r3 = block_map[block_y]
    srl r3, r3, r4         ; r3 = block_map[block_y] >> block_x
    andi r3, r3, 1         ; r3 = block_map[block_y] >> block_x & 1

    ; if block is not empty, pc += 4
    bne r3, r0, 4
    jmp r0, 64

    ; remove target block from block map
    lw r3, r5, 0     ; reload
    addi r2, r0, 1   ; bit mask
    sll r2, r2, r4
    addi r1, r0, -1
    xor r2, r2, r1   ; reverse mask
    and r3, r3, r2   ; clear
    sw r3, r5, 0     ; store back

    ; remove target block from lcd
    ; offset + ((block_y + 2) * 60 + block_x * 4) * 2
    srli r6, r6, 1         ; block_y / 2
    addi r6, r6, 2         ; block_y + 2
    add r2, r0, r6         ; copy r6
    slli r6, r6, 6         ; (block_y + 2) * 64
    slli r2, r2, 2         ; (block_y + 2) * 4
    sub r6, r6, r2         ; (block_y + 2) * 60
    slli r4, r4, 2         ; block_x * 4
    add r6, r6, r4
    slli r6, r6, 1         ; * 2

    SET_MMIO_LCD_ADDR_TO_R2() ; 2 instructions
    add r2, r2, r6
    CLEAR_BLOCK() ; 9 instructions

    ; update ball move direction
    ; reverse vertical dir (bit 1)
    xori r7, r7, 0b10
    SET_GAME_STATE_ADDR_TO_R5() ; 2 instructions
    sw r7, r5, 6
.end_macro

.macro GAME_OVER()
    ; read game_over_flag
    SET_GAME_STATE_ADDR_TO_R5()
    addi r5, r5, 15
    addi r5, r5, 7
    lw r1, r5, 0
    addi r2, r0, 1

    ; if r1 == 1, pc += 14
    beq r1, r2, 14
    ; jump to BLOCK_COLLISION (0x458)
    addi r1, r0, 0x4
    slli r1, r1, 4
    addi r1, r1, 0x5
    slli r1, r1, 4
    addi r1, r1, 0x8
    jmpr r0, r1, 0
    CLEAR_DISPLAY() ; 13 instructions
    SET_GAME_OVER_TITLE() ; 69 instructions
    nop
    jmp r0, -2
.end_macro

CLEAR_DISPLAY()
RESET_TITLE()
RESET_GAME()
j #loop


loop:
    MOVE_PADDLE()
    MOVE_BALL()
    GAME_OVER()
    BLOCK_COLLISION()
    DELAY()
    ; jump to loop top (0x23c)
    addi r1, r0, 0x2
    slli r1, r1, 4
    addi r1, r1, 0x3
    slli r1, r1, 4
    addi r1, r1, 0xc
    jmpr r0, r1, 0
