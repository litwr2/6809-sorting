;for vasm assembler, oldstyle syntax

;#define sz SIZE
;#define type TYPE
;#define swap(x,y) {type t = x; x = y; y = t;}
;type data[sz];
;void insertion() {
;    type *i = data + 1, *j, *k;
;l1: if (i >= data + sz) return;
;    j = i;
;l3: k = j - 1;
;    if (j == data || *k <= *j) goto l2;
;    swap(*k, *j);
;    j--;
;    goto l3;
;l2: i++;
;    goto l1;
;}

insertion:  ;i - y, j - x, k - u
            std .sz+2
            sty .data+1
            leay ESZ,y
.ll1:
.sz:        cmpy #0
            bcs *+3
            rts

            tfr y,x
.ll3:       leau -ESZ,x
.data:      cmpx #0
            beq .ll2

      if ESZ==1
            lda ,x
            cmpa ,u
      else
            ldd ,x
            cmpd ,u
      endif
            bcc .ll2

      if ESZ==1
            lda ,x
            ldb ,u
            sta ,u
            stb ,x
      else
            stu .m2+1
            ldd ,x
            ldu ,u
            stu ,x
.m2         std >0
      endif
            leax -ESZ,x
            bra .ll3

.ll2:       leay ESZ,y
            bra .ll1

