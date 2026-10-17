; compare two strings

.model small
.stack 100h

.data
    msg1 db 'enter first string: $'
    msg2 db 0dh,0ah,'enter second string: $'
    same db 0dh,0ah,'strings are equal$'
    diff db 0dh,0ah,'strings are not equal$'

    s1 db 51,0,52 dup(0)
    s2 db 51,0,52 dup(0)

.code
main proc
    mov ax, @data
    mov ds, ax
    mov es, ax

    lea dx, msg1
    mov ah, 09h
    int 21h
    lea dx, s1
    call readstr

    lea dx, msg2
    mov ah, 09h
    int 21h
    lea dx, s2
    call readstr

    mov al, s1[1]
    cmp al, s2[1]
    jne not_equal

    xor cx, cx
    mov cl, s1[1]
    lea si, s1[2]
    lea di, s2[2]
    repe cmpsb
    jne not_equal

    lea dx, same
    jmp display

not_equal:
    lea dx, diff

display:
    mov ah, 09h
    int 21h

    mov ah, 4ch
    int 21h
main endp

readstr proc
    mov ah, 0ah
    int 21h
    ret
readstr endp

printstr proc
    jcxz ps_done
ps_loop:
    mov dl, [si]
    mov ah, 02h
    int 21h
    inc si
    loop ps_loop
ps_done:
    ret
printstr endp

end main