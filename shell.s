;for vasm assembler, oldstyle syntax

;#define sz SIZE
;#define type TYPE
;#define tabsz 12
;#define swap(x,y) {type t = x; x = y; y = t;}
;type data[sz];
;unsigned short gap2table[tabsz] = {1, 4, 10, 23, 57, 132, 301, 701, 1750, 4759, 12923, 30001};
;void shell() {
;    type *j2, *i2, *stack;
;    unsigned short gap2;
;    unsigned char x = tabsz;
;lss1:
;    if (x == 0) return;
;    j2 = data;
;    gap2 = gap2table[x - 1];
;    i2 = data + gap2;
;lss3:
;    if (i2 >= data + sz) {
;       x--;
;       goto lss1;
;    }
;    stack = j2;
;lss8:
;    if (*i2 < *j2) {
;        swap(*j2, *i2);
;        i2 = j2;
;        if ((j2 -= gap2) >= data)
;            goto lss8;
;    }
;    j2 = stack + 1;
;    i2 = j2 + gap2;
;    goto lss3;
;}

shellsort:     ;j - x, i - y
          sty .sz2+2
          stx .data1+1
          stx .data2+2
.lss1:    stu .lssm+1
          cmpu #0
          bne *+3
          rts

.data1:   ldx #0
          ldd .gaptable-2,u
          std .gap2+1
          std .gap2c+2
          leay d,x
.lss3:
.sz2:     cmpy #0
          bcs .lss2

.lssm:    ldu #0
          leau -2,u
          bra .lss1

.lss2:    stx .lssm1+1
.lss8:
      if ESZ==1
          lda ,y
          cmpa ,x
      else
          ldd ,y
          cmpd ,x
      endif
          bcc .lssm1

      if ESZ==1
          ldb ,x
          sta ,x
          stb ,y
      else
          ldu ,x
          std ,x
          stu ,y
      endif
          tfr x,d
.gap2:    subd #0
          bls .lssm1

          tfr x,y
.data2:   cmpd #>0
          tfr d,x
          bcc .lss8

.lssm1:   ldx #0
          leax ESZ,x
.gap2c:   leay >0,x
          bra .lss3

.gaptable: word 1*ESZ, 4*ESZ, 10*ESZ, 23*ESZ, 57*ESZ, 132*ESZ, 301*ESZ, 701*ESZ, 1750*ESZ, 4759*ESZ, 12923*ESZ
;    if ESZ==1
;     word 33001*ESZ
;    endif


