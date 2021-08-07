ESZ = 1      ;an element size
data = $400  ;sorted array must start here
sz = 1000   ;number of elements in the array

ODD_OFFSET = (data & 1) && ESZ=2  ;1 makes code larger and slower

     org $200
        ldd #data
        ldx #(data+sz*ESZ-ESZ)
        jsr quicksort     ;C=1 means fail
        bcs *+2           ;error, not enough stack space
        swi               ;stop here

     ;include "quick.s"
     include "quick-nr.s"

