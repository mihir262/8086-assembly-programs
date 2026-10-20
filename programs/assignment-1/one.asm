; perform 8-bit and 16-bit addition and subtraction

.model small
.stack 100h

.data
    ; Prompts & Titles
    title1    db 0dh, 0ah, "--- 8-BIT ADDITION ---$"
    title2    db 0dh, 0ah, "--- 8-BIT SUBTRACTION ---$"
    title3    db 0dh, 0ah, "--- 16-BIT ADDITION ---$"
    title4    db 0dh, 0ah, "--- 16-BIT SUBTRACTION ---$"

    msg_num8_1 db 0dh, 0ah, "Enter first 8-bit number  : $"
    msg_num8_2 db 0dh, 0ah, "Enter second 8-bit number : $"
    msg_sum8   db 0dh, 0ah, "Result (Sum)              : $"
    msg_diff8  db 0dh, 0ah, "Result (Difference)       : $"

    msg_num16_1 db 0dh, 0ah, "Enter first 16-bit number : $"
    msg_num16_2 db 0dh, 0ah, "Enter second 16-bit number: $"
    msg_sum16   db 0dh, 0ah, "Result (Sum)             : $"
    msg_diff16  db 0dh, 0ah, "Result (Difference)      : $"

    ; 8-bit variables
    num8_1    db 00h
    num8_2    db 00h
    res8      db 00h

    ; 16-bit variables
    num16_1   dw 0000h
    num16_2   dw 0000h
    res16     dw 0000h

.code
main proc
    ; Initialize Data Segment
    mov ax, @data
    mov ds, ax

; 8-bit addition
    lea dx, title1
    mov ah, 09h
    int 21h

    ; Input First 8-bit Number
    lea dx, msg_num8_1
    mov ah, 09h
    int 21h

    mov ch, 02h
    mov cl, 04h
    mov bl, 00h
read8_add1:
    shl bl, cl
    mov ah, 01h
    int 21h
    cmp al, 41h
    jb  next8_add1
    sub al, 07h
next8_add1:
    sub al, 30h
    add bl, al
    dec ch
    jnz read8_add1
    mov dl, 0ah
    mov ah, 02h
    int 21h
    mov dl, 0dh
    mov ah, 02h
    int 21h
    mov num8_1, bl

    ; Input Second 8-bit Number
    lea dx, msg_num8_2
    mov ah, 09h
    int 21h

    mov ch, 02h
    mov cl, 04h
    mov bl, 00h
read8_add2:
    shl bl, cl
    mov ah, 01h
    int 21h
    cmp al, 41h
    jb  next8_add2
    sub al, 07h
next8_add2:
    sub al, 30h
    add bl, al
    dec ch
    jnz read8_add2
    mov dl, 0ah
    mov ah, 02h
    int 21h
    mov dl, 0dh
    mov ah, 02h
    int 21h
    mov num8_2, bl

    ; Perform Addition
    mov al, num8_1
    add al, num8_2
    mov res8, al

    ; Display Result
    lea dx, msg_sum8
    mov ah, 09h
    int 21h

    mov ch, 02h
    mov cl, 04h
    mov bl, res8
disp8_add:
    rol bl, cl
    mov dl, bl
    and dl, 0fh
    cmp dl, 0ah
    jb  next8_disp_add
    add dl, 07h
next8_disp_add:
    add dl, 30h
    mov ah, 02h
    int 21h
    dec ch
    jnz disp8_add

; 8-bit subtraction
    lea dx, title2
    mov ah, 09h
    int 21h

    ; Input First 8-bit Number
    lea dx, msg_num8_1
    mov ah, 09h
    int 21h

    mov ch, 02h
    mov cl, 04h
    mov bl, 00h
read8_sub1:
    shl bl, cl
    mov ah, 01h
    int 21h
    cmp al, 41h
    jb  next8_sub1
    sub al, 07h
next8_sub1:
    sub al, 30h
    add bl, al
    dec ch
    jnz read8_sub1
    mov dl, 0ah
    mov ah, 02h
    int 21h
    mov dl, 0dh
    mov ah, 02h
    int 21h
    mov num8_1, bl

    ; Input Second 8-bit Number
    lea dx, msg_num8_2
    mov ah, 09h
    int 21h

    mov ch, 02h
    mov cl, 04h
    mov bl, 00h
read8_sub2:
    shl bl, cl
    mov ah, 01h
    int 21h
    cmp al, 41h
    jb  next8_sub2
    sub al, 07h
next8_sub2:
    sub al, 30h
    add bl, al
    dec ch
    jnz read8_sub2
    mov dl, 0ah
    mov ah, 02h
    int 21h
    mov dl, 0dh
    mov ah, 02h
    int 21h
    mov num8_2, bl

    ; Perform Subtraction
    mov al, num8_1
    sub al, num8_2
    mov res8, al

    ; Display Result
    lea dx, msg_diff8
    mov ah, 09h
    int 21h

    mov ch, 02h
    mov cl, 04h
    mov bl, res8
disp8_sub:
    rol bl, cl
    mov dl, bl
    and dl, 0fh
    cmp dl, 0ah
    jb  next8_disp_sub
    add dl, 07h
next8_disp_sub:
    add dl, 30h
    mov ah, 02h
    int 21h
    dec ch
    jnz disp8_sub

; 16-bit addition
    lea dx, title3
    mov ah, 09h
    int 21h

    ; Input First 16-bit Number (4 hex digits)
    lea dx, msg_num16_1
    mov ah, 09h
    int 21h

    mov ch, 04h
    mov cl, 04h
    mov bx, 0000h
read16_add1:
    shl bx, cl
    mov ah, 01h
    int 21h
    cmp al, 41h
    jb  next16_add1
    sub al, 07h
next16_add1:
    sub al, 30h
    mov ah, 00h
    add bx, ax
    dec ch
    jnz read16_add1
    mov dl, 0ah
    mov ah, 02h
    int 21h
    mov dl, 0dh
    mov ah, 02h
    int 21h
    mov num16_1, bx

    ; Input Second 16-bit Number (4 hex digits)
    lea dx, msg_num16_2
    mov ah, 09h
    int 21h

    mov ch, 04h
    mov cl, 04h
    mov bx, 0000h
read16_add2:
    shl bx, cl
    mov ah, 01h
    int 21h
    cmp al, 41h
    jb  next16_add2
    sub al, 07h
next16_add2:
    sub al, 30h
    mov ah, 00h
    add bx, ax
    dec ch
    jnz read16_add2
    mov dl, 0ah
    mov ah, 02h
    int 21h
    mov dl, 0dh
    mov ah, 02h
    int 21h
    mov num16_2, bx

    ; Perform Addition
    mov ax, num16_1
    add ax, num16_2
    mov res16, ax

    ; Display Result
    lea dx, msg_sum16
    mov ah, 09h
    int 21h

    mov ch, 04h
    mov cl, 04h
    mov bx, res16
disp16_add:
    rol bx, cl
    mov dl, bl
    and dl, 0fh
    cmp dl, 0ah
    jb  next16_disp_add
    add dl, 07h
next16_disp_add:
    add dl, 30h
    mov ah, 02h
    int 21h
    dec ch
    jnz disp16_add

; 16-bit subtraction
    lea dx, title4
    mov ah, 09h
    int 21h

    ; Input First 16-bit Number (4 hex digits)
    lea dx, msg_num16_1
    mov ah, 09h
    int 21h

    mov ch, 04h
    mov cl, 04h
    mov bx, 0000h
read16_sub1:
    shl bx, cl
    mov ah, 01h
    int 21h
    cmp al, 41h
    jb  next16_sub1
    sub al, 07h
next16_sub1:
    sub al, 30h
    mov ah, 00h
    add bx, ax
    dec ch
    jnz read16_sub1
    mov dl, 0ah
    mov ah, 02h
    int 21h
    mov dl, 0dh
    mov ah, 02h
    int 21h
    mov num16_1, bx

    ; Input Second 16-bit Number (4 hex digits)
    lea dx, msg_num16_2
    mov ah, 09h
    int 21h

    mov ch, 04h
    mov cl, 04h
    mov bx, 0000h
read16_sub2:
    shl bx, cl
    mov ah, 01h
    int 21h
    cmp al, 41h
    jb  next16_sub2
    sub al, 07h
next16_sub2:
    sub al, 30h
    mov ah, 00h
    add bx, ax
    dec ch
    jnz read16_sub2
    mov dl, 0ah
    mov ah, 02h
    int 21h
    mov dl, 0dh
    mov ah, 02h
    int 21h
    mov num16_2, bx

    ; Perform Subtraction
    mov ax, num16_1
    sub ax, num16_2
    mov res16, ax

    ; Display Result
    lea dx, msg_diff16
    mov ah, 09h
    int 21h

    mov ch, 04h
    mov cl, 04h
    mov bx, res16
disp16_sub:
    rol bx, cl
    mov dl, bl
    and dl, 0fh
    cmp dl, 0ah
    jb  next16_disp_sub
    add dl, 07h
next16_disp_sub:
    add dl, 30h
    mov ah, 02h
    int 21h
    dec ch
    jnz disp16_sub

;====================================================================
; exit to dos
;====================================================================
    mov dl, 0ah
    mov ah, 02h
    int 21h
    mov dl, 0dh
    mov ah, 02h
    int 21h

    mov ah, 4ch
    int 21h

main endp
end main
