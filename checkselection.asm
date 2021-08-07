ESZ = 2        ;the element size
data = $400    ;sorted array must start here
sz = 30000     ;number of elements in the array

        org $200
        ldx #data
        ldd #(data+sz*ESZ)
        jsr selsort
        swi               ;stop here

        include "selsort.s"

