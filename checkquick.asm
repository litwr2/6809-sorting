ESZ = 2      ;an element size
data = $400  ;sorted array must start here
sz = 30000   ;number of elements in the array

ODD_OFFSET = (data & 1) && ESZ=2  ;1 makes code larger and slower

     org $100
        ldd #data
        ldx #(data+sz*ESZ-ESZ)
        jsr quicksort
        swi               ;stop here

     ;include "quick.s"
     include "quick-nr.s"

