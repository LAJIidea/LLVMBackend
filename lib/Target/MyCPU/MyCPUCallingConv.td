def CSR_ILP32_LP64
    : CalleeSavedRegs<(add X1, X3, X4, X8, X9, (sequence "X%u", 18, 27))>;

def CSR_ILP32F_LP64F
    : CalleeSavedRegs<(add CSR_ILP32_LP64,
                       F8_F, F9_F, (sequence "F%u_F", 18, 27))>;

def CSR_ILP32D_LP64D
    : CalleeSavedRegs<(add CSR_ILP32_LP64,
                       F8_D, F9_D, (sequence "F%u_D", 18, 27))>;

def CSR_NoRegs : CalleeSavedRegs<(add)>;

def CSR_Interrupt : CalleeSavedRegs<(add X1,
    (sequence "X%u", 3, 9),
    (sequence "X%u", 10, 11),
    (sequence "X%u", 12, 17),
    (sequence "X%u", 18, 27),
    (sequence "X%u", 28, 31))>;

def CSR_XLEN_F32_Interrupt: CalleeSavedRegs<(add X1,
    (sequence "X%u", 3, 9),
    (sequence "X%u", 10, 11),
    (sequence "X%u", 12, 17),
    (sequence "X%u", 18, 27),
    (sequence "X%u", 28, 31),
    (sequence "F%u_F", 0, 7),
    (sequence "F%u_F", 10, 11),
    (sequence "F%u_F", 12, 17),
    (sequence "F%u_F", 28, 31),
    (sequence "F%u_F", 8, 9),
    (sequence "F%u_F", 18, 27))>;

def CSR_XLEN_F64_Interrupt: CalleeSavedRegs<(add X1,
    (sequence "X%u", 3, 9),
    (sequence "X%u", 10, 11),
    (sequence "X%u", 12, 17),
    (sequence "X%u", 18, 27),
    (sequence "X%u", 28, 31),
    (sequence "F%u_D", 0, 7),
    (sequence "F%u_D", 10, 11),
    (sequence "F%u_D", 12, 17),
    (sequence "F%u_D", 28, 31),
    (sequence "F%u_D", 8, 9),
    (sequence "F%u_D", 18, 27))>;
