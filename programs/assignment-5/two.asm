; reversing a string

.model small
.stack 100h

.data
    msg db 'enter string: $'
    ans db 0dh,0ah,'reversed: $'
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

    xor cx, cx
    mov cl, s1[1]
    jcxz done

    lea si, s1[2]
    add si, cx
    dec si

rev_loop:
    mov dl, [si]
    mov ah, 02h
    int 21h
    dec si
    loop rev_loop

done:
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