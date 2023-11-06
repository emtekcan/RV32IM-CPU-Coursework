start:
 addi t0, zero, 0xFF
 addi t1, zero, 0x11
 addi a0, zero, 0x000
 addi a1, zero, 0x00

 floop:
 slli a1, a1, 0x001
 addi a1, a1, 0x001
 addi a0, a1, 0x000
 jal ra, delay
 beq t0, a0, start
jal ra,floop 

delay:
    addi a2, zero, 0xa
    addi t2, zero, 0 

_innerdelay:
    addi t2, t2, 1
    bne a2, t2, _innerdelay
    ret
