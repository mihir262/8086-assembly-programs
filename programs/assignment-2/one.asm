; Write an ALP to perform 8-bit multiplication

.model small
.stack 100h

.data
    msg1 db 0dh, 0ah, "enter a 8-bit number: $"
    msg2 db 0dh, 0ah, "the 16-bit result is: $"
    
    var1 db ?
    var2 db ?
    result dw ?
    
.code
main proc
    mov ax, @data
    mov ds, ax
    
    lea dx, msg1 ; display msg
    mov ah, 09h
    int 21h
    
    call read_8
    mov var1, bl
    
    lea dx, msg1
    mov ah, 09h
    int 21h

    call read_8
    mov var2, bl

    ; main logic
    mov al, var1
    mul var2
    mov result, ax

    lea dx, msg2 ; result msg
    mov ah, 09h
    int 21h
    
    mov bx, result
    mov bl, bh
    call print_8

    mov bx, result
    call print_8

    jmp exit

main endp

read_8 proc
    mov ch, 02h ; loop
    mov cl, 04h ; shift
    xor bl, bl

read_loop:
    shl bl, cl
    mov ah, 01h ; keypress
    int 21h

    cmp al, 41h
    jb is_digit
    sub al, 07h ; align > 9 with hex values

is_digit:
    sub al, 30h
    
    add bl, al
    dec ch
    jnz read_loop

    ret
read_8 endp

print_8 proc
    mov ch, 02h ; loop
    mov cl, 04h ; rotate

print_loop:
    rol bl, cl
    mov dl, bl
    
    and dl, 0fh ; mask the upper bits
    
    cmp dl, 0ah ; 'A' to 'F' check
    jb is_num
    add dl, 07h ; hex

is_num:
    add dl, 30h

    mov ah, 02h
    int 21h

    dec ch
    jnz print_loop

    ret
print_8 endp

exit:
    mov dl, 0ah
    mov ah, 02h ;print char in dl
    int 21h

    mov dl, 0dh
    mov ah, 02h
    int 21h

    mov ah, 4ch
    int 21h

end main
