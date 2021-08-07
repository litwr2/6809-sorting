;for vasm assembler, oldstyle syntax

;#define sz SIZE
;type data[sz];
;void radix8(uint8_t *a) {
;    for (int i = 0; i < 256; i++) c[i] = 0;
;    for (int j = 0; j < sz; j++)
;        c[a[j]]++;
;    int j = 0;
;    for (int i = 0; i < 256; i++)
;        for (int k = 0; k < c[i]; k++)
;            a[j++] = i;
;}

radix8:  pshs d,x,y
         pshs y
         sta .c3hi+2
         tfr d,x
         ldy #128
         ldd #0
.loop1:  std ,x++
         leay -1,y
         bne .loop1

         puls x,u
         puls y
.loop3:  ldb ,x+
         lda #0
         aslb
         rola
         incb
         inc d,u
         bne .l1

         decb
         inc d,u
.l1:     leay -1,y
         bne .loop3

         puls y
         ldu #0   ;i
.loop4:  ldx #0   ;k
.loop2:
.c3hi:   cmpx >0,u
         bcc .cont4

         tfr u,d
         lsra
         rorb
         stb ,y+
         leax 1,x
         bra .loop2

.cont4:  leau 2,u
         cmpu #512
         bne .loop4
         rts
