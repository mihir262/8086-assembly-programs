.model small
.stack 100h

.data
    msg_len     db 0dh, 0ah, "Enter length in bytes (2 hex digits, e.g. 04 for 32-bit): $", 0
    msg_prompt1 db 0dh, 0ah, "Enter First Number: $", 0
    msg_prompt2 db 0dh, 0ah, "Enter Second Number: $", 0
    msg_add     db 0dh, 0ah, "Addition Result: $", 0
    msg_sub     db 0dh, 0ah, "Subtraction Result: $", 0

    byte_len    db ?
    
    ; Buffers stored in Little-Endian order (lowest byte first)
    num1        db 16 dup(0)
    num2        db 16 dup(0)
    res_add     db 16 dup(0)
    res_sub     db 16 dup(0)

.code
main proc
    mov ax, @data
    mov ds, ax

    ; --- Read Byte Length ---
    mov dx, offset msg_len
    mov ah, 09h
    int 21h
    
    call read_8
    mov byte_len, bl

    ; --- Read First Multibyte Number ---
    mov dx, offset msg_prompt1
    mov ah, 09h
    int 21h

    mov cl, byte_len
    mov ch, 0
    mov si, cx
    dec si                  ; Start filling from highest byte index to lowest byte

read_num1_loop:
    call read_8
    mov num1[si], bl
    dec si
    loop read_num1_loop

    ; --- Read Second Multibyte Number ---
    mov dx, offset msg_prompt2
    mov ah, 09h
    int 21h

    mov cl, byte_len
    mov ch, 0
    mov si, cx
    dec si

read_num2_loop:
    call read_8
    mov num2[si], bl
    dec si
    loop read_num2_loop


    ; =========================================================
    ; MULTIBYTE ADDITION (num1 + num2)
    ; =========================================================
    mov cl, byte_len
    mov ch, 0
    xor si, si              ; Start from lowest byte (index 0)
    clc                     ; Clear Carry Flag before starting

add_loop:
    mov al, num1[si]
    adc al, num2[si]        ; Add byte with Carry Flag from previous byte
    mov res_add[si], al
    inc si
    loop add_loop


    ; =========================================================
    ; MULTIBYTE SUBTRACTION (num1 - num2)
    ; =========================================================
    mov cl, byte_len
    mov ch, 0
    xor si, si              ; Start from lowest byte (index 0)
    clc                     ; Clear Carry (Borrow) Flag before starting

sub_loop:
    mov al, num1[si]
    sbb al, num2[si]        ; Subtract byte with Borrow Flag from previous byte
    mov res_sub[si], al
    inc si
    loop sub_loop


    ; --- Print Addition Result ---
    mov dx, offset msg_add
    mov ah, 09h
    int 21h

    mov cl, byte_len
    mov ch, 0
    mov si, cx
    dec si                  ; Print from highest byte index down to 0

print_add_loop:
    mov bl, res_add[si]
    call print_8
    dec si
    loop print_add_loop


    ; --- Print Subtraction Result ---
    mov dx, offset msg_sub
    mov ah, 09h
    int 21h

    mov cl, byte_len
    mov ch, 0
    mov si, cx
    dec si

print_sub_loop:
    mov bl, res_sub[si]
    call print_8
    dec si
    loop print_sub_loop


    ; --- Exit Program ---
    mov ax, 4c00h
    int 21h
main endp


; =========================================================
; USER PROCEDURES
; =========================================================

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