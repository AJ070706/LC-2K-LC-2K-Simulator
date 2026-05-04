        noop        r1 stores PC at all times.
        noop        r2 always stores the unmodified current instruction.
        noop        r3 temp (usually instr)
        noop        r4 temp (usually regA)
        noop        r5 temp (usually retAddr, regB)
        noop        r6 temp (usually destReg, offset)
        noop        r7 temp
        lw  0   1   sZERO   r1 = PC
sLOOP   lw  1   2   sMEM    r2 = MEM[PC]
        add 0   2   3       r3 = MEM[PC] (working)
        nor 3   3   3       
        lw  0   7   sOMASK  r7 = Opcode mask
        nor 7   7   7
        nor 3   7   3
        lw  0   7   sADD
        beq 3   7   sdADD
        lw  0   7   sNOR
        beq 3   7   sdNOR
        lw  0   7   sLW
        beq 3   7   sdLW
        lw  0   7   sSW
        beq 3   7   sdSW
        lw  0   7   sBEQ
        beq 3   7   sdBEQ
        lw  0   7   sJALR
        beq 3   7   sdJALR
        lw  0   7   sHALT
        beq 3   7   sdHALT
        beq 0   0   sEnd    noop -> skip to PC += 1
sddRA   add 0   2   3       finds regA. modifies r3, 6, 7. assumes r5 holds return addr.
        nor 3   3   3       
        lw  0   7   sAMASK  r7 = regA mask
        nor 7   7   7
        nor 3   7   7       r7 = regA << 19
        lw  0   6   sAA
        beq 6   7   sdRAA
        lw  0   6   sAB
        beq 6   7   sdRAB
        lw  0   6   sAC
        beq 6   7   sdRAC
        lw  0   6   sAD
        beq 6   7   sdRAD
        lw  0   6   sAE
        beq 6   7   sdRAE
        lw  0   6   sAF
        beq 6   7   sdRAF
        lw  0   6   sAG
        beq 6   7   sdRAG
        lw  0   6   sAH
        beq 6   7   sdRAH
sdRAA   lw  0   7   sZERO
        beq 0   0   sdRAZ
sdRAB   lw  0   7   sONE
        beq 0   0   sdRAZ
sdRAC   lw  0   7   sTWO
        beq 0   0   sdRAZ
sdRAD   lw  0   7   sTHREE
        beq 0   0   sdRAZ
sdRAE   lw  0   7   sFOUR
        beq 0   0   sdRAZ
sdRAF   lw  0   7   sFIVE
        beq 0   0   sdRAZ
sdRAG   lw  0   7   sSIX
        beq 0   0   sdRAZ
sdRAH   lw  0   7   sSEVEN
        beq 0   0   sdRAZ
sdRAZ   sw  0   7   sRA
        jalr    5   7
sddRB   add 0   2   3       finds regB. modifies r3, 6, 7. assumes r5 holds return addr.
        nor 3   3   3       
        lw  0   7   sBMASK  r7 = regB mask
        nor 7   7   7
        nor 3   7   7       r7 = regB << 16
        lw  0   6   sBA
        beq 6   7   sdRBA
        lw  0   6   sBB
        beq 6   7   sdRBB
        lw  0   6   sBC
        beq 6   7   sdRBC
        lw  0   6   sBD
        beq 6   7   sdRBD
        lw  0   6   sBE
        beq 6   7   sdRBE
        lw  0   6   sBF
        beq 6   7   sdRBF
        lw  0   6   sBG
        beq 6   7   sdRBG
        lw  0   6   sBH
        beq 6   7   sdRBH
sdRBA   lw  0   7   sZERO
        beq 0   0   sdRBZ
sdRBB   lw  0   7   sONE
        beq 0   0   sdRBZ
sdRBC   lw  0   7   sTWO
        beq 0   0   sdRBZ
sdRBD   lw  0   7   sTHREE
        beq 0   0   sdRBZ
sdRBE   lw  0   7   sFOUR
        beq 0   0   sdRBZ
sdRBF   lw  0   7   sFIVE
        beq 0   0   sdRBZ
sdRBG   lw  0   7   sSIX
        beq 0   0   sdRBZ
sdRBH   lw  0   7   sSEVEN
        beq 0   0   sdRBZ
sdRBZ   sw  0   7   sRB
        jalr    5   7
sddRD   add 0   2   3       finds destReg. modifies r3, 7. assumes r5 holds return addr.
        nor 3   3   3  
        lw  0   7   sDMASK  r7 = destReg mask
        nor 7   7   7
        nor 3   7   7
        sw  0   7   sRDest
        jalr    5   7
sddOff  add 0   2   3       finds offset. modifies r3, 4, 6, 7. assumes r5 holds return addr.
        nor 3   3   3
        lw  0   7   sOFFM   r7 = offset mask
        nor 7   7   7
        nor 3   7   7
        lw  0   6   sSIGN   sign extension
        nor 7   7   3
        nor 6   6   4
        nor 3   4   3       r3 = offset & signBit
        beq 3   0   sdOffz
        lw  0   6   sNEG6
        add 7   6   7       offset -= 65536
sdOffz  sw  0   7   sOff
        jalr    5   7
sdADD   lw  0   7   sdRA    finds regA, regB, and destReg
        jalr    7   5
        lw  0   7   sdRB
        jalr    7   5
        lw  0   7   sdRD
        jalr    7   5
        lw  0   3   sRA
        lw  3   4   sR0     loads reg[A] using offset from reg0
        lw  0   3   sRB
        lw  3   5   sR0
        lw  0   3   sRDest
        add 4   5   6
        sw  3   6   sR0
        beq 0   0   sEnd
sdNOR   lw  0   7   sdRA
        jalr    7   5
        lw  0   7   sdRB
        jalr    7   5
        lw  0   7   sdRD
        jalr    7   5
        lw  0   3   sRA
        lw  3   4   sR0
        lw  0   3   sRB
        lw  3   5   sR0
        lw  0   3   sRDest
        nor 4   5   6
        sw  3   6   sR0
        beq 0   0   sEnd
sdLW    lw  0   7   sdRA
        jalr    7   5
        lw  0   7   sdRB
        jalr    7   5
        lw  0   7   sdOff
        jalr    7   5
        lw  0   3   sRA
        lw  3   4   sR0
        lw  0   7   sOff
        add 4   7   4
        lw  0   3   sRB
        lw  4   5   sMEM
        sw  3   5   sR0
        beq 0   0   sEnd
sdSW    lw  0   7   sdRA
        jalr    7   5
        lw  0   7   sdRB
        jalr    7   5
        lw  0   7   sdOff
        jalr    7   5
        lw  0   3   sRA
        lw  3   4   sR0
        lw  0   7   sOff
        add 4   7   4
        lw  0   3   sRB
        lw  3   5   sR0
        sw  4   5   sMEM
        beq 0   0   sEnd
sdBEQ   lw  0   7   sdRA
        jalr    7   5
        lw  0   7   sdRB
        jalr    7   5
        lw  0   7   sdOff
        jalr    7   5
        lw  0   3   sRA
        lw  3   4   sR0
        lw  0   3   sRB
        lw  3   5   sR0
        beq 4   5   sdBEQA
        beq 0   0   sEnd
sdBEQA  lw  0   7   sOff
        add 1   7   1
        beq 0   0   sEnd
sdJALR  lw  0   7   sdRA
        jalr    7   5
        lw  0   7   sdRB
        jalr    7   5
        lw  0   3   sRB
        lw  0   7   sONE
        add 1   7   5
        sw  3   5   sR0
        lw  0   3   sRA
        lw  3   4   sR0
        add 0   4   1
        beq 0   0   sLOOP       skip adding 1 to PC due to nature of jalr
sdHALT  lw  0   3   sONE                 perform pc + 1 code (copied) then halt
        add 1   3   1
        halt
sEnd    lw  0   3   sONE                 perform pc + 1 then loop
        add 1   3   1
        beq 0   0   sLOOP
sR0     .fill   0
sR1     .fill   0
sR2     .fill   0
sR3     .fill   0
sR4     .fill   0
sR5     .fill   0
sR6     .fill   0
sR7     .fill   0
sdRA    .fill   sddRA
sdRB    .fill   sddRB
sdRD    .fill   sddRD
sdOff   .fill   sddOff
sZERO   .fill   0
sONE    .fill   1
sTWO    .fill   2
sTHREE  .fill   3
sFOUR   .fill   4
sFIVE   .fill   5
sSIX    .fill   6
sSEVEN  .fill   7
sRA     .fill   0
sRB     .fill   0
sRDest  .fill   0
sOff    .fill   0
sOMASK  .fill   29360128    7 << 22
sAMASK  .fill   3670016     7 << 19
sBMASK  .fill   458752      7 << 16
sDMASK  .fill   7
sOFFM   .fill   65535
sSIGN   .fill   32768       1 << 15
sNEG6   .fill   -65536
sADD    .fill   0
sNOR    .fill   4194304     1 << 22
sLW     .fill   8388608     2 << 22
sSW     .fill   12582912    3 << 22
sBEQ    .fill   16777216    4 << 22
sJALR   .fill   20971520    5 << 22
sHALT   .fill   25165824    6 << 22
sAA     .fill   0
sAB     .fill   524288      1 << 19
sAC     .fill   1048576     2 << 19
sAD     .fill   1572864
sAE     .fill   2097152
sAF     .fill   2621440
sAG     .fill   3145728
sAH     .fill   3670016
sBA     .fill   0
sBB     .fill   65536       1 << 16
sBC     .fill   131072      2 << 16
sBD     .fill   196608
sBE     .fill   262144
sBF     .fill   327680
sBG     .fill   393216
sBH     .fill   458752
SMEM    .fill   0
