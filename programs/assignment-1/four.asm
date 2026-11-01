.model small
.stack 100h

.data
    msg_count   db 0dh, 0ah, "Enter total count of 8-bit numbers (e.g. 03): $", 0
    msg_prompt  db 0dh, 0ah, "Enter 8-bit hex number: $", 0
    msg_sum     db 0dh, 0ah, "Total Sum (16-bit Hex): $", 0

    count       dw ?

.code
main proc
    mov ax, @data
    mov ds, ax

    ; --- Read Count N ---
    mov dx, offset msg_count
    mov ah, 09h
    int 21h

    call read_8           ; N returned in BL
    mov bh, 0
    mov count, bx         ; Store count in memory

    ; --- Accumulate Sum ---
    mov cx, count         ; Loop counter
    xor ax, ax            ; Clear AX to use as 16-bit sum accumulator

sum_8_loop:
    push ax               ; Save current running sum
    push cx               ; Save loop count

    mov dx, offset msg_prompt
    mov ah, 09h
    int 21h
    
    call read_8           ; Input byte returned in BL
    mov bh, 0             ; Zero-extend BL to BX

    pop cx                ; Restore loop count
    pop ax                ; Restore running sum

    add ax, bx            ; AX = AX + input number
    loop sum_8_loop

    ; --- Print 16-bit Result ---
    mov bx, ax            ; Move sum to BX for print_16
    mov dx, offset msg_sum
    mov ah, 09h
    int 21h

    call print_16

    ; --- Exit ---
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

end main