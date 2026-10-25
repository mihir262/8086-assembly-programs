; LED Blinking Program
; Main Program starting at default address (e.g., 1000H)

    MOV AL, 80H    ; 8255 Control Word: Mode 0, PA/PB/PC all Output
    OUT 33H, AL    ; Send control word to Control Register (33H)

L1: 
    MOV AL, 00H    ; ALL LEDs OFF (00H)
    OUT 30H, AL    ; Port A OFF
    OUT 31H, AL    ; Port B OFF
    OUT 32H, AL    ; Port C OFF

    CALL DLY       ; Call Delay subroutine
    
    MOV AL, FFH    ; ALL LEDs ON (FFH)
    OUT 30H, AL    ; Port A ON
    OUT 31H, AL    ; Port B ON
    OUT 32H, AL    ; Port C ON
    
    CALL DLY       ; Call Delay subroutine
    JMP L1         ; Repeat continuous blinking

; Delay Subroutine (Can be placed directly after or at 2000H)
DLY:
    MOV CX, FFFFH
D1:
    NOP
    LOOP D1
    RET
