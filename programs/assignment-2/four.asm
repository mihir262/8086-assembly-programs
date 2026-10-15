; division of 32 bit number by 16 bit number


.model small
.stack 100h

.data
    msg1 db 0dh,0ah, "enter 32-bit dividend (8 hex digits): $"
    msg2 db 0dh,0ah, "enter 16-bit divisor (hex): $"
    msg3 db 0dh,0ah, "32-bit quotient: $"
    msg4 db 0dh,0ah, "16-bit remainder: $"

    dividend_hi dw ?
    dividend_lo dw ?
    divisor dw ?
    quotient_hi dw ?
    quotient_lo dw ?
    temp_rem dw ?
    remainder dw ?

.code
main proc
    mov ax, @data
    mov ds, ax

    lea dx, msg1
    mov ah, 09h
    int 21h
    call read_32
    mov dividend_hi, dx
    mov dividend_lo, bx

    lea dx, msg2
    mov ah, 09h
    int 21h
    call read_16
    mov divisor, bx

    ; divide high word
    mov ax, dividend_hi
    xor dx, dx
    div divisor

    mov quotient_hi, ax
    mov temp_rem, dx

    ; divide intermediate remainder : low word
    mov dx, temp_rem
    mov ax, dividend_lo
    div divisor

    mov quotient_lo, ax
    mov remainder, dx

    lea dx, msg3
    mov ah, 09h
    int 21h
    mov dx, quotient_hi
    mov bx, quotient_lo
    call print_32

    lea dx, msg4
    mov ah, 09h
    int 21h
    mov bx, remainder
    call print_16

    mov dl, 0ah
    mov ah, 02h
    int 21h

    mov dl, 0dh
    mov ah, 02h
    int 21h

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
