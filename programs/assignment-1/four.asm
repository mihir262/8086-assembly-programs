; find the sum of series of 8-bit and 16-bit numbers

.model small
.stack 100h

.data
    title1      db 0dh, 0ah, "--- SUM OF SERIES OF 8-BIT NUMBERS ---$"
    title2      db 0dh, 0ah, "--- SUM OF SERIES OF 16-BIT NUMBERS ---$"

    msg_count8  db 0dh, 0ah, "Enter count of 8-bit numbers (2 hex digits): $"
    msg_elem8   db 0dh, 0ah, "Enter 8-bit number : $"
    msg_res8    db 0dh, 0ah, "Sum of 8-bit series (16-bit result)       : $"

    msg_count16 db 0dh, 0ah, "Enter count of 16-bit numbers (2 hex digits): $"
    msg_elem16  db 0dh, 0ah, "Enter 16-bit number: $"
    msg_res16   db 0dh, 0ah, "Sum of 16-bit series (32-bit result)      : $"

    ; 8-bit series variables
    count8      db 00h
    sum8        dw 0000h        ; 16-bit accumulator to handle carries from byte additions

    ; 16-bit series variables
    count16     db 00h
    sum16_ls    dw 0000h        ; Lower 16 bits of 32-bit accumulator
    sum16_ms    dw 0000h        ; Higher 16 bits of 32-bit accumulator

.code
main proc
    ; Initialize Data Segment
    mov ax, @data
    mov ds, ax

; sum of series of 8-bit numbers
    lea dx, title1
    mov ah, 09h
    int 21h

    ; Input Count of Numbers
    lea dx, msg_count8
    mov ah, 09h
    int 21h

    mov ch, 02h
    mov cl, 04h
    mov bl, 00h
read_cnt8:
    shl bl, cl
    mov ah, 01h
    int 21h
    cmp al, 41h
    jb  next_cnt8
    sub al, 07h
next_cnt8:
    sub al, 30h
    add bl, al
    dec ch
    jnz read_cnt8
    mov dl, 0ah
    mov ah, 02h
    int 21h
    mov dl, 0dh
    mov ah, 02h
    int 21h
    mov count8, bl

    ; Initialize 16-bit accumulator to 0000H
    mov word ptr sum8, 0000h

    ; Loop to read each 8-bit number and accumulate
series8_loop:
    cmp count8, 00h
    jz  disp_series8

    lea dx, msg_elem8
    mov ah, 09h
    int 21h

    mov ch, 02h
    mov cl, 04h
    mov bl, 00h
read_elem8:
    shl bl, cl
    mov ah, 01h
    int 21h
    cmp al, 41h
    jb  next_elem8
    sub al, 07h
next_elem8:
    sub al, 30h
    add bl, al
    dec ch
    jnz read_elem8
    mov dl, 0ah
    mov ah, 02h
    int 21h
    mov dl, 0dh
    mov ah, 02h
    int 21h

    ; Zero-extend 8-bit input to 16 bits and add to accumulator
    mov bh, 00h
    add sum8, bx

    dec count8
    jnz series8_loop

disp_series8:
    ; Display 16-bit Result
    lea dx, msg_res8
    mov ah, 09h
    int 21h

    mov ch, 04h
    mov cl, 04h
    mov bx, sum8
disp8_res:
    rol bx, cl
    mov dl, bl
    and dl, 0fh
    cmp dl, 0ah
    jb  next_disp8_res
    add dl, 07h
next_disp8_res:
    add dl, 30h
    mov ah, 02h
    int 21h
    dec ch
    jnz disp8_res

; sum of series of 16-bit numbers
    lea dx, title2
    mov ah, 09h
    int 21h

    ; Input Count of Numbers
    lea dx, msg_count16
    mov ah, 09h
    int 21h

    mov ch, 02h
    mov cl, 04h
    mov bl, 00h
read_cnt16:
    shl bl, cl
    mov ah, 01h
    int 21h
    cmp al, 41h
    jb  next_cnt16
    sub al, 07h
next_cnt16:
    sub al, 30h
    add bl, al
    dec ch
    jnz read_cnt16
    mov dl, 0ah
    mov ah, 02h
    int 21h
    mov dl, 0dh
    mov ah, 02h
    int 21h
    mov count16, bl

    ; Initialize 32-bit accumulator (MSW:LSW) to 0000:0000H
    mov word ptr sum16_ls, 0000h
    mov word ptr sum16_ms, 0000h

    ; Loop to read each 16-bit number and accumulate
series16_loop:
    cmp count16, 00h
    jz  disp_series16

    lea dx, msg_elem16
    mov ah, 09h
    int 21h

    mov ch, 04h
    mov cl, 04h
    mov bx, 0000h
read_elem16:
    shl bx, cl
    mov ah, 01h
    int 21h
    cmp al, 41h
    jb  next_elem16
    sub al, 07h
next_elem16:
    sub al, 30h
    mov ah, 00h
    add bx, ax
    dec ch
    jnz read_elem16
    mov dl, 0ah
    mov ah, 02h
    int 21h
    mov dl, 0dh
    mov ah, 02h
    int 21h

    ; Add 16-bit input to 32-bit accumulator with carry propagation
    add sum16_ls, bx
    adc sum16_ms, 0000h

    dec count16
    jnz series16_loop

disp_series16:
    ; Display 32-bit Result
    lea dx, msg_res16
    mov ah, 09h
    int 21h

    ; Display MSW (Higher 16 bits)
    mov ch, 04h
    mov cl, 04h
    mov bx, sum16_ms
disp16_res_ms:
    rol bx, cl
    mov dl, bl
    and dl, 0fh
    cmp dl, 0ah
    jb  next_disp16_ms
    add dl, 07h
next_disp16_ms:
    add dl, 30h
    mov ah, 02h
    int 21h
    dec ch
    jnz disp16_res_ms

    ; Display LSW (Lower 16 bits)
    mov ch, 04h
    mov cl, 04h
    mov bx, sum16_ls
disp16_res_ls:
    rol bx, cl
    mov dl, bl
    and dl, 0fh
    cmp dl, 0ah
    jb  next_disp16_ls
    add dl, 07h
next_disp16_ls:
    add dl, 30h
    mov ah, 02h
    int 21h
    dec ch
    jnz disp16_res_ls

;====================================================================
; exit to dos
;====================================================================
    mov dl, 0ah
    mov ah, 02h
    int 21h
    mov dl, 0dh
    mov ah, 02h
    int 21h

    mov ah, 4ch
    int 21h

main endp
end main
