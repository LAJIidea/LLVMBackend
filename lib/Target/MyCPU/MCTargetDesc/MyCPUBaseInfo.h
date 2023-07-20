//
// Created by BY210033 on 2023/6/9.
//

#ifndef LLVM_MYCPUBASEINFO_H
#define LLVM_MYCPUBASEINFO_H

#include "MCTargetDesc/MyCPUTargetDesc.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/ADT/StringSwitch.h"
#include "llvm/MC/MCInstrDesc.h"
#include "llvm/MC/SubtargetFeature.h"
#include "llvm/Support/MachineValueType.h"

namespace llvm {

namespace MyCPUII {

} // namespace MyCPUII

namespace MyCPUABI {

enum ABI {
  ABI_ILP32,
  ABI_ILP32F,
  ABI_ILP32D,
  ABI_ILP32E,
  ABI_LP64,
  ABI_LP64F,
  ABI_LP64D,
  ABI_Unknown
};

MCRegister getBPReg();

} // namespace MyCPUABI


} // namespace llvm

#endif // LLVM_MYCPUBASEINFO_H
