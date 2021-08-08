ESZ = 2        ;the element size
data = $400    ;sorted array must start here
sz = 1000     ;number of elements in the array

        org $100
        ldx #data
        ldd #(data+sz*ESZ)
        jsr selsort
        swi               ;stop here

        include "selsort.s"

