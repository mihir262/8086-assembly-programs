; alp to find length of string

.model small
.stack 100h

.data
    msg db 'enter string: $'
    ans db 0dh,0ah,'length: $'
    s1 db 51,0,52 dup(0)

.code
main proc
    mov ax, @data
    mov ds, ax

    lea dx, msg
    mov ah, 09h
    int 21h

    lea dx, s1
    call readstr

    lea dx, ans
    mov ah, 09h
    int 21h

    mov al, s1[1]
    aam
    mov bl, al
    mov dl, ah
    add dl, 30h
    cmp dl, 30h
    je ones
    mov ah, 02h
    int 21h

ones:
    mov dl, bl
    add dl, 30h
    mov ah, 02h
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
