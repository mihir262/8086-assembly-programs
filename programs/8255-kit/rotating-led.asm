; Rotating LED Program

    MOV AL, 80H    ; Mode 0, PA/PB/PC Output
    OUT 33H, AL    ; Write to Control Register
    MOV AL, 01H    ; Start with LED 0 ON (0000 0001b)

L1: 
    OUT 30H, AL    ; Output pattern to Port A
    CALL DLY       ; Call Delay Subroutine
    ROL AL, 1      ; Rotate bit left by 1 position
    JMP L1         ; Loop continuously

; Delay Subroutine
DLY:
    MOV CX, FFFFH
D2:
    NOP
    LOOP D2
    RET
