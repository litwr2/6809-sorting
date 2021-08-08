;for vasm assembler, oldstyle syntax
stacklvl = 26   ;stacklvl*6+stackint is amount of free stack space required for successful work of this routine
stackint = 24   ;stack space reserved for irq and nmi

;#include <setjmp.h>
;#define sz 30000
;#define splimit 20
;#define type unsigned short
;#define ssz 200
;#define swap(x,y) {type t = x; x = y; y = t;}
;jmp_buf jmp_point;
;type *sa[ssz], **sp;
;void push(type *d) {
;    *sp-- = d;
;}
;type* pop() {
;    return *++sp;
;}
;type data[sz];
;type x, *ub, *lb, *i2, *j2;
;void quick0() {
;    sp--;
;    if (sp - sa < splimit) longjmp(jmp_point, 1);
;    i2 = lb;
;    j2 = ub;
;    x = *(type*)(((unsigned long)j2 + (unsigned long)i2) >> 1 & ~((1 << sizeof(type)) - 1));
;qsloop1:
;    if (*i2 >= x) goto qs_l1;
;    i2 += 1;
;    goto qsloop1;
;qs_l1:
;    if (x >= *j2) goto qs_l3;
;    j2 -= 1;
;    goto qs_l1;
;qs_l3:
;    if (j2 < i2) goto qs_l8;
;    if (j2 != i2) swap(*i2, *j2);
;    i2 += 1;
;    j2 -= 1;
;    if (j2 >= i2) goto qsloop1;
;qs_l8:
;    if (lb >= j2) goto qs_l5;
;    push(i2);
;    push(ub);
;    ub = j2;
;    quick0();
;    ub = pop();
;    i2 = pop();
;qs_l5:
;    if (i2 >= ub) goto quit;
;    lb = i2;
;    quick0();
;quit:
;    sp++;
;}
;void quick() {
;    type *gub = ub, *glb = lb;
;    setjmp(jmp_point);
;    sp = sa + ssz - 1;
;    ub = gub;
;    lb = glb;
;    quick0();
;}

quicksort:  ;i - x, j - y
           std .data+1
      if ODD_OFFSET
           andb #1
           stb .evenness+1
      endif
           stx .sz+2
           sts .qs_csp+2
           tfr s,d
           subd #stacklvl*6
           bcc *+3
           rts        C=1 - error: not enough stack space

           std .stacklim+2
           cmpd #stackint   ;this check may be skipped if irq are disabled and nmi are impossible
           bcc *+3
           rts        ;error: irq may get not enough space, C=1 - error

.qs_csp:   lds #0
.sz:       ldy #0
           sty .ub+1
.data:     ldx #0
           stx .lb+2

.quicksort0:
.stacklim: cmps #0
           bcs .qs_csp

           ldx .lb+2
           ;ldy .ub+1
           tfr y,d
           addd .lb+2
       if ESZ=2
           andb #$fc
       endif
           rora
           rorb
       if ODD_OFFSET
.evenness:orb #0
       endif
           tfr d,u
       if ESZ==1
           ldb ,u
           stb .x+1
       else
           ldd ,u
           std .x+2
       endif
.qsloop1:
       if ESZ==1
           ldb ,x     ;compare array[i] and x
.x:        cmpb #0
       else
           ldd ,x
.x:        cmpd #0
       endif
           bcc .qs_l1

           leax ESZ,x
           bra .qsloop1
.qs_l1:
       if ESZ==1
           ldb ,y    ;compare array[j] and x
           cmpb .x+1
       else
           ldd ,y
           cmpd .x+2
       endif
           bls .qs_l3

           leay -ESZ,y
           bra .qs_l1

.qs_l3:    sty .tmp1+1    ;compare i and j
.tmp1:     cmpx #0
           bhi .qs_l8
           beq .qs_l9

       if ESZ==1
           lda ,y    ;exchange elements with i and j indices
           ldb ,x
           sta ,x
           stb ,y
       else
           ldd ,y
           ldu ,x
           std ,x
           stu ,y
      endif

.qs_l9:    leax ESZ,x
           leay -ESZ,y
           stx .tmp2+2
.tmp2:     cmpy #0
           bcc .qsloop1
.qs_l8:
.lb:       cmpy #0
           bls .qs_l5

           ldd .ub+1
           pshs d,x
           sty .ub+1
           ;ldx .lb+2
           jsr .quicksort0
           puls d,x
           std .ub+1
.qs_l5:
.ub:       cmpx #0
           bcc .quit

           stx .lb+2
           ldy .ub+1
           jsr .quicksort0   ;don't use the tail call optimization! it can be much slower for some data
.quit:     rts       ;C=0 - ok

