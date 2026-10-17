; change case of a string

.model small
.stack 100h

.data
    msg db 'enter string: $'
    ans db 0dh,0ah,'changed case: $'
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

    lea si, s1[2]
    xor cx, cx
    mov cl, s1[1]
    jcxz done

case_loop:
    mov al, [si]

    cmp al, 'a'
    jb check_upper
    cmp al, 'z'
    ja check_upper
    sub al, 20h
    jmp print_char

check_upper:
    cmp al, 'A'
    jb print_char
    cmp al, 'Z'
    ja print_char
    add al, 20h

print_char:
    mov dl, al
    mov ah, 02h
    int 21h
    inc si
    loop case_loop

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