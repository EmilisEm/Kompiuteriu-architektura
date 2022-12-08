; Emilis Kleinas 1 kursas 2 grupė
; Pertraukimas turi gauti ASCIIZ eilutės adresą registrų poroje DS:SI ir išspausdinti ją atbulai.
; 
;------------------------------------------------------------------------
%include 'yasmmac.inc'  
org 100h                        ; visos COM programos prasideda nuo 100h
                                ; Be to, DS=CS=ES=SS !

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section .text                   ; kodas prasideda cia 

   startas:                     ; nuo cia vykdomas kodas
      mov dx, eilute
      mov al, 79
      xor bx, bx

      macPutString "Ivesk teksto eilute patalpiaafsfnti i DS:SI $"
      macNewLine
      call procGetStr
    
      .while:
        mov cl, [eilute + bx]
        mov [ds:si+bx], cl
        cmp cl, 0
        jz .end
        inc bx
        jmp .while

      .end:
      macNewLine
      macPutString "Apversta eilute$"
      macNewLine
      
      int 0x88
      macNewLine
      exit
      

%include 'yasmlib.asm'
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section .data                   ; duomenys

   eilute:
      times 80 db 00

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section .bss                    ; neinicializuoti duomenys  


