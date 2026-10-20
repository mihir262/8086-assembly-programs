; perform multibyte addition and subtraction

.model small
.stack 100h

.data
    LEN         EQU 04H                 ; Number of bytes (e.g., 4 bytes = 8 hex digits)

    title1      db 0dh, 0ah, "--- MULTIBYTE ADDITION ---$"
    title2      db 0dh, 0ah, "--- MULTIBYTE SUBTRACTION ---$"

    msg_num1    db 0dh, 0ah, "Enter first multibyte number  : $"
    msg_num2    db 0dh, 0ah, "Enter second multibyte number : $"
    msg_sum     db 0dh, 0ah, "Result (Sum)                  : $"
    msg_diff    db 0dh, 0ah, "Result (Difference)           : $"

    ; Arrays store bytes in Little-Endian format (Index 0 = LSB, Index LEN-1 = MSB)
    num1        db LEN dup(00h)
    num2        db LEN dup(00h)
    res         db LEN dup(00h)

.code
main proc
    mov ax, @data
    mov ds, ax

; multibyte addition
    lea dx, title1
    mov ah, 09h
    int 21h

    ; Input First Number (User types MSB to LSB; stored LSB at index 0)
    lea dx, msg_num1
    mov ah, 09h
    int 21h

    mov si, LEN - 1
read_add1_byte:
    mov ch, 02h
    mov cl, 04h
    mov bl, 00h
read_add1_digit:
    shl bl, cl
    mov ah, 01h
    int 21h
    cmp al, 41h
    jb  next_add1_digit
    sub al, 07h
next_add1_digit:
    sub al, 30h
    add bl, al
    dec ch
    jnz read_add1_digit
    mov num1[si], bl
    dec si
    jns read_add1_byte
    mov dl, 0ah
    mov ah, 02h
    int 21h
    mov dl, 0dh
    mov ah, 02h
    int 21h

    ; Input Second Number (User types MSB to LSB; stored LSB at index 0)
    lea dx, msg_num2
    mov ah, 09h
    int 21h

    mov si, LEN - 1
read_add2_byte:
    mov ch, 02h
    mov cl, 04h
    mov bl, 00h
read_add2_digit:
    shl bl, cl
    mov ah, 01h
    int 21h
    cmp al, 41h
    jb  next_add2_digit
    sub al, 07h
next_add2_digit:
    sub al, 30h
    add bl, al
    dec ch
    jnz read_add2_digit
    mov num2[si], bl
    dec si
    jns read_add2_byte
    mov dl, 0ah
    mov ah, 02h
    int 21h
    mov dl, 0dh
    mov ah, 02h
    int 21h

    ; Perform Multibyte Addition (from LSB to MSB using ADC)
    mov si, 0000h
    mov cx, LEN
    clc                                 ; Clear carry before addition loop
add_loop:
    mov al, num1[si]
    adc al, num2[si]
    mov res[si], al
    inc si
    loop add_loop

    ; Display Result (from MSB down to LSB)
    lea dx, msg_sum
    mov ah, 09h
    int 21h

    mov si, LEN - 1
disp_add_byte:
    mov ch, 02h
    mov cl, 04h
    mov bl, res[si]
disp_add_digit:
    rol bl, cl
    mov dl, bl
    and dl, 0fh
    cmp dl, 0ah
    jb  next_disp_add
    add dl, 07h
next_disp_add:
    add dl, 30h
    mov ah, 02h
    int 21h
    dec ch
    jnz disp_add_digit
    dec si
    jns disp_add_byte

; multibyte subtraction
    lea dx, title2
    mov ah, 09h
    int 21h

    ; Input First Number (User types MSB to LSB)
    lea dx, msg_num1
    mov ah, 09h
    int 21h

    mov si, LEN - 1
read_sub1_byte:
    mov ch, 02h
    mov cl, 04h
    mov bl, 00h
read_sub1_digit:
    shl bl, cl
    mov ah, 01h
    int 21h
    cmp al, 41h
    jb  next_sub1_digit
    sub al, 07h
next_sub1_digit:
    sub al, 30h
    add bl, al
    dec ch
    jnz read_sub1_digit
    mov num1[si], bl
    dec si
    jns read_sub1_byte
    mov dl, 0ah
    mov ah, 02h
    int 21h
    mov dl, 0dh
    mov ah, 02h
    int 21h

    ; Input Second Number (User types MSB to LSB)
    lea dx, msg_num2
    mov ah, 09h
    int 21h

    mov si, LEN - 1
read_sub2_byte:
    mov ch, 02h
    mov cl, 04h
    mov bl, 00h
read_sub2_digit:
    shl bl, cl
    mov ah, 01h
    int 21h
    cmp al, 41h
    jb  next_sub2_digit
    sub al, 07h
next_sub2_digit:
    sub al, 30h
    add bl, al
    dec ch
    jnz read_sub2_digit
    mov num2[si], bl
    dec si
    jns read_sub2_byte
    mov dl, 0ah
    mov ah, 02h
    int 21h
    mov dl, 0dh
    mov ah, 02h
    int 21h

    ; Perform Multibyte Subtraction (from LSB to MSB using SBB)
    mov si, 0000h
    mov cx, LEN
    clc                                 ; Clear borrow before subtraction loop
sub_loop:
    mov al, num1[si]
    sbb al, num2[si]
    mov res[si], al
    inc si
    loop sub_loop

    ; Display Result (from MSB down to LSB)
    lea dx, msg_diff
    mov ah, 09h
    int 21h

    mov si, LEN - 1
disp_sub_byte:
    mov ch, 02h
    mov cl, 04h
    mov bl, res[si]
disp_sub_digit:
    rol bl, cl
    mov dl, bl
    and dl, 0fh
    cmp dl, 0ah
    jb  next_disp_sub
    add dl, 07h
next_disp_sub:
    add dl, 30h
    mov ah, 02h
    int 21h
    dec ch
    jnz disp_sub_digit
    dec si
    jns disp_sub_byte

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
