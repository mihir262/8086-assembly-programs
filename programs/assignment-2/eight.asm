; matrix addition and subtraction

.model small
.stack 100h

.data
    msg_a db 0dh,0ah, "enter next element of matrix A (4 hex digits): $"
    msg_b db 0dh,0ah, "enter next element of matrix B (4 hex digits): $"
    msg_sum db 0dh,0ah, "A + B:",0dh,0ah,'$'
    msg_diff db 0dh,0ah, "A - B:",0dh,0ah,'$'
    crlf db 0dh,0ah,'$'

    mat_a dw 4 dup(?)
    mat_b dw 4 dup(?)
    mat_sum dw 4 dup(?)
    mat_diff dw 4 dup(?)

.code
main proc
    mov ax, @data
    mov ds, ax

    ; read matrix A
    xor si, si
    mov bp, 4

read_a:
    lea dx, msg_a
    mov ah, 09h
    int 21h

    call read_16
    mov mat_a[si], bx

    add si, 2
    dec bp
    jnz read_a

    ; read matrix B
    xor si, si
    mov bp, 4

read_b:
    lea dx, msg_b
    mov ah, 09h
    int 21h

    call read_16
    mov mat_b[si], bx

    add si, 2
    dec bp
    jnz read_b

    ; calculate A+B and A-B
    xor si, si
    mov bp, 4

calculate:
    mov ax, mat_a[si]
    add ax, mat_b[si]
    mov mat_sum[si], ax

    mov ax, mat_a[si]
    sub ax, mat_b[si]
    mov mat_diff[si], ax

    add si, 2
    dec bp
    jnz calculate

    ; print A+B
    lea dx, msg_sum
    mov ah, 09h
    int 21h

    xor si, si
    mov bp, 4

print_sum:
    mov bx, mat_sum[si]
    call print_16

    mov dl, ' '
    mov ah, 02h
    int 21h

    add si, 2
    cmp si, 4
    jne sum_no_newline

    lea dx, crlf
    mov ah, 09h
    int 21h

sum_no_newline:
    dec bp
    jnz print_sum

    ; print A-B
    lea dx, msg_diff
    mov ah, 09h
    int 21h

    xor si, si
    mov bp, 4

print_diff:
    mov bx, mat_diff[si]
    call print_16

    mov dl, ' '
    mov ah, 02h
    int 21h

    add si, 2
    cmp si, 4
    jne diff_no_newline

    lea dx, crlf
    mov ah, 09h
    int 21h

diff_no_newline:
    dec bp
    jnz print_diff

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
