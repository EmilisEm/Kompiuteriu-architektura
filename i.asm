; Emilis Kleinas 1 kursas 2 grupė
; Pertraukimas turi gauti ASCIIZ eilutės adresą registrų poroje DS:SI ir išspausdinti ją atbulai.
; 
%include 'yasmmac.inc'          ; Pagalbiniai makrosai
%define PERTRAUKIMAS 0x88
;------------------------------------------------------------------------
org 100h                        ; visos COM programos prasideda nuo 100h
                                ; Be to, DS=CS=ES=SS !

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section .text                   ; kodas prasideda cia 
    Pradzia:
      jmp Nustatymas                           ;Pirmas paleidimas
    SenasPertraukimas:
      dw      0, 0

    procRasyk:                   ;Naudosime doroklyje 
      jmp .toliau

      .toliau:
        xor bx, bx

        .looper:
        mov dl, [ds:si + bx]
        cmp dl, 0
        jz .handle
        inc bx
        jmp .looper

      .handle:
        dec bx
        jmp .rasymas
      .rasymas:
        mov ah, 0x02
        cmp bx, 0
        jl .quit
        mov dl, [ds:si + bx]
        int 0x21
        dec bx
        jmp .rasymas
        
      .quit:
        ret                                          ; griztame is proceduros
;end procRasyk

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
NaujasPertraukimas:                                      ; Doroklis prasideda cia
    
      macPushAll                                      ; Sagome registrus
      call procRasyk
      macPopAll
      cli
      pop ax
      pop bx
      pop cx
      pushf
      push bx
      push ax
      sti
      iret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Rezidentinio bloko pabaiga
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;  Nustatymo (po pirmo paleidimo) blokas: jis NELIEKA atmintyje
;
;

 
Nustatymas:
        ; Gauname sena   vektoriu
        push    cs
        pop     ds
       ; macPutString "Iki ...", crlf, '$'
        mov     ah, 0x35
        mov     al, PERTRAUKIMAS                 ; gauname sena pertraukimo vektoriu
        int     0x21
        
        ; Saugome sena vektoriu 
        mov     [cs:SenasPertraukimas], bx             ; issaugome seno doroklio poslinki    
        mov     [cs:SenasPertraukimas + 2], es         ; issaugome seno doroklio segmenta
        
      ;  macPutString "Nustatome ...", crlf, '$'
        
        ; Nustatome nauja  vektoriu
        mov     dx, NaujasPertraukimas
        mov     ah, 0x25
        mov     al, PERTRAUKIMAS                       ; nustatome pertraukimo vektoriu
        int     21h
        
       ; macPutString "OK ...", crlf, '$'
        
        mov dx, Nustatymas + 1
        int     27h                       ; Padarome rezidentu

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section .bss                    ; neinicializuoti duomenys  


