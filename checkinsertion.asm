ESZ = 2        ;the element size
data = $400    ;sorted array must start here
sz = 1000      ;number of elements in the array

        org $100
        ldy #data
        ldd #(data+sz*ESZ)
        jsr insertion
        swi               ;stop here

        include "insertion.s"

