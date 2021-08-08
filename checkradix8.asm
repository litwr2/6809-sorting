ESZ = 1       ;do not change this value!
data = $400   ;sorted array must start here
auxtable = $200  ;address of the auxilary 512 byte array, it must be page aligned
sz = 60000    ;number of elements in the array

        org $100
        ldd #auxtable
        ldy #data
        ldx #sz
        jsr radix8
        swi               ;stop here

        include "radix8.s"
