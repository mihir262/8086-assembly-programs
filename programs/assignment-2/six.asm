; performing (a+b) * (c+d)

.model small
.stack 100h

.data
    msg1 db 0dh,0ah, "enter a (hex): $"
    msg2 db 0dh,0ah, "enter b (hex): $"
    msg3 db 0dh,0ah, "enter c (hex): $"
    msg4 db 0dh,0ah, "enter d (hex): $"
    msg5 db 0dh,0ah, "result: $"

    a db ?
    b db ?
    c db ?
    d db ?
    sum_ab dw ?
    sum_cd dw ?
    result_lo dw ?
    result_hi dw ?

.code
main proc
    mov ax, @data
    mov ds, ax

    lea dx, msg1
    mov ah, 09h
    int 21h
    call read_8
    mov a, bl

    lea dx, msg2
    mov ah, 09h
    int 21h
    call read_8
    mov b, bl

    lea dx, msg3
    mov ah, 09h
    int 21h
    call read_8
    mov c, bl

    lea dx, msg4
    mov ah, 09h
    int 21h
    call read_8
    mov d, bl

    ; sum_ab = a + b
    xor ax, ax
    mov al, a
    xor bx, bx
    mov bl, b
    add ax, bx
    mov sum_ab, ax

    ; sum_cd = c + d
    xor ax, ax
    mov al, c
    xor bx, bx
    mov bl, d
    add ax, bx
    mov sum_cd, ax

    ; result = sum_ab * sum_cd
    mov ax, sum_ab
    mov bx, sum_cd
    mul bx

    mov result_lo, ax
    mov result_hi, dx

    lea dx, msg5
    mov ah, 09h
    int 21h

    mov dx, result_hi
    mov bx, result_lo
    call print_32

    mov ah, 4ch
    int 21h
main endp


read_8 proc
    mov ch, 02h
    mov cl, 04h
    xor bl, bl

r8_next:
    mov ah, 01h
    int 21h

    cmp al, 0dh
    je r8_next
    cmp al, 0ah
    je r8_next
    cmp al, ' '
    je r8_next

    shl bl, cl

    cmp al, '9'
    jbe r8_digit
    sub al, 07h

r8_digit:
    sub al, 30h
    add bl, al

    dec ch
    jnz r8_next
    ret
read_8 endp


read_16 proc
    call read_8
    mov bh, bl

    call read_8
    ret
read_16 endp


read_32 proc
    call read_16
    push bx                 ; save upper word

    call read_16            ; lower word returned in BX
    pop dx                  ; upper word returned in DX
    ret
read_32 endp


print_8 proc
    mov ch, 02h
    mov cl, 04h

p8_loop:
    rol bl, cl
    mov dl, bl
    and dl, 0fh

    cmp dl, 09h
    jbe p8_digit
    add dl, 07h

p8_digit:
    add dl, 30h
    mov ah, 02h
    int 21h

    dec ch
    jnz p8_loop
    ret
print_8 endp


print_16 proc
    push bx

    mov bl, bh
    call print_8

    pop bx
    call print_8
    ret
print_16 endp


print_32 proc
    push dx
    push bx

    mov bx, dx
    call print_16

    pop bx
    call print_16
    pop dx
    ret
print_32 endp

end main
