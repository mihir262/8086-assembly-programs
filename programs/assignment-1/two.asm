; perform 32-bit addition and subtraction

.model small
.stack 100h

.data
    ; Prompts & Titles
    title1      db 0dh, 0ah, "--- 32-BIT ADDITION ---$"
    title2      db 0dh, 0ah, "--- 32-BIT SUBTRACTION ---$"

    msg_num32_1 db 0dh, 0ah, "Enter first 32-bit number (8 hex digits) : $"
    msg_num32_2 db 0dh, 0ah, "Enter second 32-bit number (8 hex digits): $"
    msg_sum32   db 0dh, 0ah, "Result (Sum)                            : $"
    msg_diff32  db 0dh, 0ah, "Result (Difference)                     : $"

    ; 32-bit operands stored as Lower Word (LSW) and Higher Word (MSW)
    num32_1_ls dw 0000h
    num32_1_ms dw 0000h

    num32_2_ls dw 0000h
    num32_2_ms dw 0000h

    res32_ls   dw 0000h
    res32_ms   dw 0000h

.code
main proc
    ; Initialize Data Segment
    mov ax, @data
    mov ds, ax

; 32-bit addition
    lea dx, title1
    mov ah, 09h
    int 21h

    ; Input First 32-bit Number (MSW first, then LSW)
    lea dx, msg_num32_1
    mov ah, 09h
    int 21h

    ; Read Higher 16 bits
    mov ch, 04h
    mov cl, 04h
    mov bx, 0000h
read32_add1_ms:
    shl bx, cl
    mov ah, 01h
    int 21h
    cmp al, 41h
    jb  next32_add1_ms
    sub al, 07h
next32_add1_ms:
    sub al, 30h
    mov ah, 00h
    add bx, ax
    dec ch
    jnz read32_add1_ms
    mov num32_1_ms, bx

    ; Read Lower 16 bits
    mov ch, 04h
    mov cl, 04h
    mov bx, 0000h
read32_add1_ls:
    shl bx, cl
    mov ah, 01h
    int 21h
    cmp al, 41h
    jb  next32_add1_ls
    sub al, 07h
next32_add1_ls:
    sub al, 30h
    mov ah, 00h
    add bx, ax
    dec ch
    jnz read32_add1_ls
    mov dl, 0ah
    mov ah, 02h
    int 21h
    mov dl, 0dh
    mov ah, 02h
    int 21h
    mov num32_1_ls, bx

    ; Input Second 32-bit Number (MSW first, then LSW)
    lea dx, msg_num32_2
    mov ah, 09h
    int 21h

    ; Read Higher 16 bits
    mov ch, 04h
    mov cl, 04h
    mov bx, 0000h
read32_add2_ms:
    shl bx, cl
    mov ah, 01h
    int 21h
    cmp al, 41h
    jb  next32_add2_ms
    sub al, 07h
next32_add2_ms:
    sub al, 30h
    mov ah, 00h
    add bx, ax
    dec ch
    jnz read32_add2_ms
    mov num32_2_ms, bx

    ; Read Lower 16 bits
    mov ch, 04h
    mov cl, 04h
    mov bx, 0000h
read32_add2_ls:
    shl bx, cl
    mov ah, 01h
    int 21h
    cmp al, 41h
    jb  next32_add2_ls
    sub al, 07h
next32_add2_ls:
    sub al, 30h
    mov ah, 00h
    add bx, ax
    dec ch
    jnz read32_add2_ls
    mov dl, 0ah
    mov ah, 02h
    int 21h
    mov dl, 0dh
    mov ah, 02h
    int 21h
    mov num32_2_ls, bx

    ; Perform 32-Bit Addition
    mov ax, num32_1_ls
    add ax, num32_2_ls
    mov res32_ls, ax

    mov ax, num32_1_ms
    adc ax, num32_2_ms
    mov res32_ms, ax

    ; Display Result
    lea dx, msg_sum32
    mov ah, 09h
    int 21h

    ; Display Higher 16 bits
    mov ch, 04h
    mov cl, 04h
    mov bx, res32_ms
disp32_add_ms:
    rol bx, cl
    mov dl, bl
    and dl, 0fh
    cmp dl, 0ah
    jb  next32_disp_add_ms
    add dl, 07h
next32_disp_add_ms:
    add dl, 30h
    mov ah, 02h
    int 21h
    dec ch
    jnz disp32_add_ms

    ; Display Lower 16 bits
    mov ch, 04h
    mov cl, 04h
    mov bx, res32_ls
disp32_add_ls:
    rol bx, cl
    mov dl, bl
    and dl, 0fh
    cmp dl, 0ah
    jb  next32_disp_add_ls
    add dl, 07h
next32_disp_add_ls:
    add dl, 30h
    mov ah, 02h
    int 21h
    dec ch
    jnz disp32_add_ls

; 32-bit subtraction
    lea dx, title2
    mov ah, 09h
    int 21h

    ; Input First 32-bit Number (MSW first, then LSW)
    lea dx, msg_num32_1
    mov ah, 09h
    int 21h

    ; Read Higher 16 bits
    mov ch, 04h
    mov cl, 04h
    mov bx, 0000h
read32_sub1_ms:
    shl bx, cl
    mov ah, 01h
    int 21h
    cmp al, 41h
    jb  next32_sub1_ms
    sub al, 07h
next32_sub1_ms:
    sub al, 30h
    mov ah, 00h
    add bx, ax
    dec ch
    jnz read32_sub1_ms
    mov num32_1_ms, bx

    ; Read Lower 16 bits
    mov ch, 04h
    mov cl, 04h
    mov bx, 0000h
read32_sub1_ls:
    shl bx, cl
    mov ah, 01h
    int 21h
    cmp al, 41h
    jb  next32_sub1_ls
    sub al, 07h
next32_sub1_ls:
    sub al, 30h
    mov ah, 00h
    add bx, ax
    dec ch
    jnz read32_sub1_ls
    mov dl, 0ah
    mov ah, 02h
    int 21h
    mov dl, 0dh
    mov ah, 02h
    int 21h
    mov num32_1_ls, bx

    ; Input Second 32-bit Number (MSW first, then LSW)
    lea dx, msg_num32_2
    mov ah, 09h
    int 21h

    ; Read Higher 16 bits
    mov ch, 04h
    mov cl, 04h
    mov bx, 0000h
read32_sub2_ms:
    shl bx, cl
    mov ah, 01h
    int 21h
    cmp al, 41h
    jb  next32_sub2_ms
    sub al, 07h
next32_sub2_ms:
    sub al, 30h
    mov ah, 00h
    add bx, ax
    dec ch
    jnz read32_sub2_ms
    mov num32_2_ms, bx

    ; Read Lower 16 bits
    mov ch, 04h
    mov cl, 04h
    mov bx, 0000h
read32_sub2_ls:
    shl bx, cl
    mov ah, 01h
    int 21h
    cmp al, 41h
    jb  next32_sub2_ls
    sub al, 07h
next32_sub2_ls:
    sub al, 30h
    mov ah, 00h
    add bx, ax
    dec ch
    jnz read32_sub2_ls
    mov dl, 0ah
    mov ah, 02h
    int 21h
    mov dl, 0dh
    mov ah, 02h
    int 21h
    mov num32_2_ls, bx

    ; Perform 32-Bit Subtraction
    mov ax, num32_1_ls
    sub ax, num32_2_ls
    mov res32_ls, ax

    mov ax, num32_1_ms
    sbb ax, num32_2_ms
    mov res32_ms, ax

    ; Display Result
    lea dx, msg_diff32
    mov ah, 09h
    int 21h

    ; Display Higher 16 bits
    mov ch, 04h
    mov cl, 04h
    mov bx, res32_ms
disp32_sub_ms:
    rol bx, cl
    mov dl, bl
    and dl, 0fh
    cmp dl, 0ah
    jb  next32_disp_sub_ms
    add dl, 07h
next32_disp_sub_ms:
    add dl, 30h
    mov ah, 02h
    int 21h
    dec ch
    jnz disp32_sub_ms

    ; Display Lower 16 bits
    mov ch, 04h
    mov cl, 04h
    mov bx, res32_ls
disp32_sub_ls:
    rol bx, cl
    mov dl, bl
    and dl, 0fh
    cmp dl, 0ah
    jb  next32_disp_sub_ls
    add dl, 07h
next32_disp_sub_ls:
    add dl, 30h
    mov ah, 02h
    int 21h
    dec ch
    jnz disp32_sub_ls

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
