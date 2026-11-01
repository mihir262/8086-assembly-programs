.model small
.stack 100h

.data
    msg_prompt1 db 0dh, 0ah, "Enter first 8-bit hex number (e.g. 1A): $", 0
    msg_prompt2 db 0dh, 0ah, "Enter second 8-bit hex number (e.g. 05): $", 0
    msg_add     db 0dh, 0ah, "Addition Result (SUM): $", 0
    msg_sub     db 0dh, 0ah, "Subtraction Result (DIFF): $", 0
    
    num1 db ?
    num2 db ?

.code
main proc
    mov ax, @data
    mov ds, ax

    ; --- Read First Number ---
    mov dx, offset msg_prompt1
    mov ah, 09h
    int 21h
    
    call read_8           ; Input returned in BL
    mov num1, bl

    ; --- Read Second Number ---
    mov dx, offset msg_prompt2
    mov ah, 09h
    int 21h
    
    call read_8           ; Input returned in BL
    mov num2, bl

    ; --- Perform Addition ---
    mov dx, offset msg_add
    mov ah, 09h
    int 21h

    mov bl, num1
    add bl, num2          ; BL = num1 + num2
    call print_8          ; Print result in BL

    ; --- Perform Subtraction ---
    mov dx, offset msg_sub
    mov ah, 09h
    int 21h

    mov bl, num1
    sub bl, num2          ; BL = num1 - num2
    call print_8          ; Print result in BL

    ; --- Exit Program ---
    mov ax, 4c00h
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
    push bx                ; save upper word

    call read_16           ; lower word returned in BX
    pop dx                 ; upper word returned in DX
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