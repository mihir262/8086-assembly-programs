; Strobe I/O (Mode 1)
; Address: 1400H

    STI            ; Enable Interrupts

    MOV AL, 0A6H   ; Mode 1 Configuration Word
    OUT 33H, AL    ; Control Register

    MOV AL, 5AH    ; Data value 5AH
    OUT 30H, AL    ; Output to Port A

    MOV AL, 05H    ; BSR Set command (PC2 = 1)
    OUT 33H, AL

    MOV AL, 0DH    ; BSR Set command (PC6 = 1)
    OUT 33H, AL

    IN AL, 31H     ; Read Port B into AL
    INT 3          ; Breakpoint / Return to Monitor
