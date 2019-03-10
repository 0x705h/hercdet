; Hercdet by 0x705h
; Simple program for Hercules Video Card Adapters detection
; compile with MSDOS TASM

.model small
.stack 200h
.data
strheader db "Hercules detector by 0x705h$"
strnotdetected db 0ah, 0dh, "Hercules not detected! :($"
strdetected db 0ah, 0dh, "Hercules detected! :)$"
strincolor db 0ah, 0dh, "Adapter: In color$"
strhercplus db 0ah, 0dh, "Adapter: Hercules+$"
strhercnormal db 0ah, 0dh, "Adapter: Hercules or compatible$"
strunknown db 0ah, 0dh, "Adapter is unknown$"


.code
start:

        mov     ax, SEG strheader
        mov     ds, ax
        mov     dx, OFFSET strheader
        mov     ah, 09h
        int     21h
        
        call    detect_herc

; if bh is 00h then it is not detected, else if 0fh then herc detected
        
        cmp     bh, 0Fh
        jz      detected_herc
        mov     ax, SEG strnotdetected
        mov     ds, ax
        mov     dx, OFFSET strnotdetected
        mov     ah, 09h
        int     21h
        call    exit

detected_herc:
        
        mov ax, SEG strdetected
        mov ds, ax
        mov dx, OFFSET strdetected
        mov ah, 09h
        int 21h

; try to detect what kind of Hercules is

        mov     dx, 3BAh
        mov     bh, 0
        in      al, dx
        
        ; bit 6-4 = 000 Hercules or compatible
        ;         = 001 Hercules+
        ;         = 101 Hercules InColor
        ;         = otherwise, unknown
        and     al, 50h       ; 0b01010000
        cmp     al, 00000000b ; Hercules
        jz      herccompatible
        cmp     al, 00010000b  ; Hercules+
        jz      hercplus
        cmp     al, 01010000b  ; Hercules InColor
        jz      hercincolor
        jmp     hercunknown



hercincolor:
        mov ax, SEG strincolor
        mov dx, OFFSET strincolor

        jmp print_type
hercplus:
        mov ax, SEG strhercplus
        mov dx, OFFSET strhercplus

        jmp print_type
herccompatible:
        mov ax, SEG strhercnormal
        mov dx, OFFSET strhercnormal

        jmp print_type
hercunknown:
        mov ax, SEG strunknown
        mov dx, OFFSET strunknown

        
print_type:

; print adapter type

        mov ds, ax
        mov ah, 09h
        int 21h

        call exit

; detection routine
detect_herc:
        push    ds
        push    es
        xor     bh, bh
        mov     dx, 3BAh
        mov     bh, 0           
        in      al, dx          ; ask to 03BAh 
        and     al, 80h         ; if this bit is on or off
        mov     ah, al          ; and save it to ah register
        mov     cx, 8000h       ; prepare 8000h reads

poll_bit_flip:

        in      al, dx          ; ask to 03BAh
        and     al, 80h         ; if this bit is on or off
        cmp     ah, al          ; compare the previous result to this one
        loope   poll_bit_flip   ; until are different or reached 8000h reads
        jz      short no_change ; if the bit hasn't changed, then its
        mov     bh, 0fh         ; .. not a Hercules Adapter, so don't set
                                ; bh to 0fh
no_change:
        pop es
        pop ds
        retn

exit:

        ; exit to dos
        mov ah, 4ch
        mov al, 00h
        int 21h

end start
