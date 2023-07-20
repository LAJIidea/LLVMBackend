//
// Created by BY210033 on 2023/6/9.
//
#include "MyCPUBaseInfo.h"
#include "llvm/ADT/ArrayRef.h"
#include "llvm/ADT/Triple.h"
#include "llvm/Support/raw_os_ostream.h"

namespace llvm {

namespace MyCPUABI {

MCRegister getBPReg() { return MyCPU::X9; }

}

}
