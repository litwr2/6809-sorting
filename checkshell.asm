ESZ = 1      ;the element size
shelltabidx = 7  ;the default index to the gap table, the first index is equal to 1
                  ;for the best speed, the indexed value should be maximal but close to sz/2
                  ;it is safe to always set it to the max value 11
data = $400  ;sorted array must start here
sz = 1000   ;number of elements in the array

        org $100
        ldx #data
        ldy #data+sz*ESZ
        ldu #shelltabidx*2  ;may be less
        jsr shellsort
        swi               ;stop here

        include "shell.s"
