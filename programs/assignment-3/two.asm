; write a alp to sort numbers in ascending and descending order

.model small
.stack 100h

.data
	msg1 db 0dh, 0ah, "enter 5 hexadecimal numbers: $"
	msg2 db 0dh, 0ah, "ascending: $"
	msg3 db 0dh, 0ah, "descending: $"
	newline db 0dh, 0ah, "$"

	count db 05h
	pass_count db ?
	numbers db 5 dup(?)

.code 
main proc
	mov ax, @data
	mov ds, ax

	lea dx, msg1
	mov ah, 09h
	int 21h

	;input nums
	xor si, si
	mov cl, count
	xor ch, ch

input_loop:
    push cx
    call read_8
    pop cx

    mov numbers[si], bl
    inc si
    loop input_loop

    ; bubble sort
    mov al, count
    dec al
    mov pass_count, al

outer_loop:
    xor si, si
    mov cl, count
    xor ch, ch
    dec cx

inner_loop:
    mov al, numbers[si]
    mov bl, numbers[si+1]

    cmp al, bl
    jbe no_swap

    mov numbers[si], bl
    mov numbers[si+1], al

no_swap:
    inc si
    loop inner_loop

    dec pass_count
    jnz outer_loop

    ; print ascending
    lea dx, msg2
    mov ah, 09h
    int 21h

    xor si, si
    mov cl, count
    xor ch, ch

asc_loop:
    push cx
    mov bl, numbers[si]
    call print_8
    pop cx

    mov dl, ' '
    mov ah, 02h
    int 21h

    inc si
    loop asc_loop

    lea dx, newline
    mov ah, 09h
    int 21h

    ; print descending order by traversing backwards
    lea dx, msg3
    mov ah, 09h
    int 21h

    mov al, count
    xor ah, ah
    mov si, ax
    dec si

    mov cl, count
    xor ch, ch

desc_loop:
    push cx
    mov bl, numbers[si]
    call print_8
    pop cx

    mov dl, ' '
    mov ah, 02h
    int 21h

    dec si
    loop desc_loop

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