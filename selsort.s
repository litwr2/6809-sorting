;for vasm assembler, oldstyle syntax

;#define sz SIZE
;#define type TYPE
;#define swap(x,y) {type t = x; x = y; y = t;}
;type data[sz];
;void selection() {
;    type *i = data, *k, *min;
;l7: min = i;
;    k = i + 1;
;l3: if (k == data + sz) goto l8;
;    if (*k >= *min) goto l4;
;    min = k;
;l4: k++;
;    goto l3;
;l8: //if (min != i)
;    swap(*min, *i);
;    i++;
;    if (i != k) goto l7;
;}

selsort:      ;i - x, k - y, min - u
          std .sz2+2
.ll7:     tfr x,u
          leay ESZ,x
.ll3:
.sz2:     cmpy #0
          beq .ll8

     if ESZ==1
          lda ,y
          cmpa ,u
     else 
          ldd ,y     ;ESZ==2
          cmpd ,u
     endif
          bcc .ll4

          tfr y,u
.ll4:     leay ESZ,y
          bra .ll3

.ll8:     sty .m+1
      if ESZ==1
          lda ,u
          ldb ,x
          sta ,x
          stb ,u
      else
          ldd ,u   ;ESZ==2
          ldy ,x
          std ,x
          sty ,u
      endif
          leax ESZ,x
.m:       cmpx #0
          bne .ll7
          rts
