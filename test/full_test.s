.text
.equ myval, 0x12122002
main:
  JAL     ra, imm             # immediate arithmetic, and test upper stuffs
  JAL     ra, store           # store cycles of values into DataMem
  JAL     ra, reg             # register arithmetic
  JAL     ra, load            # test loading these values into registers
  JAL     ra, branch          # just lots of branch conditions
  ADDI    a2, zero, 0x0FF     # setting up for f1thing
forever:
  JAL     ra, f1thing         # simplified ver. of f1 program
  J       forever

imm:
  LUI     a0, 0x12122
  ADDI    a0, a0, 0x002       # equiv to LI  a0, myval
  ADDI    a1, a0, 0x110       # a1 = 0x12122112
  SLLI    a2, a0, 0x003       # a2 = 0x90910010
  ADDI    a3, a2, 0xC78       # a2 = 0x9090FC88
  SLTI    t0, a0, 0xD0D       # t0 = 0
  SLTIU   t1, a0, 0xD0D       # t1 = 1
  XORI    a4, a3, 0xA67       # a4 = 0x6F6F06EF
  SRLI    a5, a4, 0x008       # a5 = 0x006F6F06
  SRAI    t2, a4, 0x6BB       # t2 = 0xDDEDEDE0
  ORI     a6, a3, 0x7A4       # a6 = 0x9090FFAC
  ANDI    a7, a4, 0x678       # a7 = 0x00000668
  AUIPC   s0, 0xBFC00         # s0 = 0xBFC00 + PC
  LUI     a1, 0xF7F78
  ADDI    a1, a1, 0x878       # a1 = 0xF7F77878
  RET

store:
  ADDI    a7, zero, 0x003     # loop_count a7 = 3
  ADDI    a6, zero, 0x91A     # can replace below with mul (*2)
  ADDI    a6, a6, 0x91A       # base_address = 0x00001234
_loop1:                         
  SB      a3, 0x002(a6)       # mem[[a6]+2] = 0x88
  SH      a5, 0x000(a6)       # mem[[a6]]   = 0x6F06
  SW      a7, 0xFFE(a6)       # mem[[a6]-2] = 0x00000003
  ADDI    t0, t0, 0x001       # increment t0
  ADD     a6, a6, t0          # increase a6
  BNE     t0, a7, _loop1      # until t0 = 3
  RET

reg:
  ADD     s1, zero, a0        # just keeping this val safe
  SUB     a3, a1, a2          # a3 = 0x67668868
  ADD     a0, a1, a2          # a0 = 0x88888888
  SLT     t0, a1, a2          # t0 = 0
  XOR     a4, a1, a2          # a4 = 0x67668868
  OR      a5, a1, a2          # a5 = 0xF7F78878
  AND     a6, a1, a2          # a6 = 0x90910010
  ADDI    a1, a1, 0x011       # a1 = 0xF7F77889
  SLL     a7, a0, a1          # a7 = 0x10F11000
  ADDI    a1, a1, 0x002       # a1 = 0xF7F7788B
  SRL     a3, a0, a1          # a0 = 0x22222222
  RET

load:
  LUI     a1, 0x00001
  ADDI    a1, a1, 0x236       # a1 = 0x00001236
  LB      a2, a1, 0xFFE       # a2 = 0xFFFFFFEF
  LH      a4, a1, 0x000       # a4 = 0x00000088
  LW      a5, a1, 0x001       # a5 = 0x6F6F06EF
  LBU     a6, a1, 0x003       # a6 = 0x00000088
  LHU     a7, a1, 0xFFD       # a7 = 0x00006F0D
  RET

# doesn't fully test branches, for lack of time
branch: 
  BEQ     a2, a3, branch      # shouldn't branch
  BGE     a4, a5, branch      # shouldn't branch
  BGEU    a1, a0, branch      # shouldn't branch
  BLT     a7, a0, branch      # shouldn't branch
  BLTU    a0, a1, branch      # shouldn't branch
  RET


f1thing:    # just to throw this in here
  ADDI    a0, zero, 0x000     # a0 = 0x00000000
_loop3:                       # repeat
  SLLI    a1, a0, 0x001       # a1 = a0, shifted left
  ADDI    a0, a1, 0x001       # a0 = prev a0, with one more 1 
  BNE     a0, a2, _loop3      # until a0 == 0x000000FF
  RET



file.elf:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 
:
   0:	020000ef          	jal	ra,20 
   4:	05c000ef          	jal	ra,60 
   8:	080000ef          	jal	ra,88 
   c:	0ac000ef          	jal	ra,b8 
  10:	0c8000ef          	jal	ra,d8 
  14:	0ff00613          	li	a2,255

0000000000000018 :
  18:	0d8000ef          	jal	ra,f0 
  1c:	ffdff06f          	j	18 

0000000000000020 :
  20:	12122537          	lui	a0,0x12122
  24:	00250513          	addi	a0,a0,2 # 12122002 
  28:	11050593          	addi	a1,a0,272
  2c:	00351613          	slli	a2,a0,0x3
  30:	c7860693          	addi	a3,a2,-904
  34:	d0d52293          	slti	t0,a0,-755
  38:	d0d53313          	sltiu	t1,a0,-755
  3c:	a676c713          	xori	a4,a3,-1433
  40:	00875793          	srli	a5,a4,0x8
  44:	40075393          	srai	t2,a4,0x0 **********test this
  48:	7a46e813          	ori	a6,a3,1956
  4c:	67877893          	andi	a7,a4,1656
  50:	bfc00417          	auipc	s0,0xbfc00 ******check this next run
  54:	f7f785b7          	lui	a1,0xf7f78
  58:	87858593          	addi	a1,a1,-1928 # fffffffff7f77878 
  5c:	00008067          	ret

0000000000000060 :
  60:	00300893          	li	a7,3
  64:	91a00813          	li	a6,-1766
  68:	91a80813          	addi	a6,a6,-1766

000000000000006c <_loop1>:
  6c:	00d80123          	sb	a3,2(a6)
  70:	00f81023          	sh	a5,0(a6)
  74:	ff182f23          	sw	a7,-2(a6)
  78:	00128293          	addi	t0,t0,1
  7c:	00580833          	add	a6,a6,t0
  80:	ff1296e3          	bne	t0,a7,6c <_loop1>
  84:	00008067          	ret

0000000000000088 :
  88:	00a004b3          	add	s1,zero,a0
  8c:	40c586b3          	sub	a3,a1,a2
  90:	00c58533          	add	a0,a1,a2
  94:	00c5a2b3          	slt	t0,a1,a2
  98:	00c5c733          	xor	a4,a1,a2
  9c:	00c5e7b3          	or	a5,a1,a2
  a0:	00c5f833          	and	a6,a1,a2
  a4:	01158593          	addi	a1,a1,17
  a8:	00b518b3          	sll	a7,a0,a1
  ac:	00258593          	addi	a1,a1,2
  b0:	00b556b3          	srl	a3,a0,a1
  b4:	00008067          	ret

00000000000000b8 :
  b8:	000015b7          	lui	a1,0x1
  bc:	23658593          	addi	a1,a1,566 # 1236 <_loop3+0x1142>
  c0:	ffe58603          	lb	a2,-2(a1)
  c4:	00059703          	lh	a4,0(a1)
  c8:	0015a783          	lw	a5,1(a1)
  cc:	0035c803          	lbu	a6,3(a1)
  d0:	ffd5d883          	lhu	a7,-3(a1)
  d4:	00008067          	ret

00000000000000d8 :
  d8:	00d60063          	beq	a2,a3,d8 
  dc:	fef75ee3          	ble	a5,a4,d8 
  e0:	fea5fce3          	bleu	a0,a1,d8 
  e4:	fea8cae3          	blt	a7,a0,d8 
  e8:	feb568e3          	bltu	a0,a1,d8 
  ec:	00008067          	ret

00000000000000f0 :
  f0:	00000513          	li	a0,0

00000000000000f4 <_loop3>:
  f4:	00151593          	slli	a1,a0,0x1
  f8:	00158513          	addi	a0,a1,1
  fc:	fec51ce3          	bne	a0,a2,f4 <_loop3>
 100:	00008067          	ret