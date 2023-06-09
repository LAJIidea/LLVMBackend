
//===----------------------------------------------------------------------===//
//
// 本文件定义了`MyCPUSubtarget`类，该
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_MYCPUSUBTARGET_H
#define LLVM_MYCPUSUBTARGET_H

#include "MyCPUInstrInfo.h"
#include "MCTargetDesc/MyCPUBaseInfo.h"

#include "llvm/CodeGen/TargetSubtargetInfo.h"
#include "llvm/CodeGen/GlobalISel/CallLowering.h"
#include "llvm/CodeGen/GlobalISel/InstructionSelector.h"
#include "llvm/CodeGen/GlobalISel/LegalizerInfo.h"
#include "llvm/CodeGen/GlobalISel/RegisterBankInfo.h"
#include "llvm/CodeGen/SelectionDAGTargetInfo.h"
#include "llvm/IR/DataLayout.h"
#include "llvm/Target/TargetMachine.h"

#define GET_SUBTARGETINFO_HEADER
#include "MyCPUGenSubtargetInfo.inc"

namespace llvm {
class StringRef;

class MyCPUSubTarget : public MyCPUGenSubtargetInfo {
  virtual void anchor();
  bool HasMU64 = false;
  bool IsMU32E = false;
  unsigned XLen = 32;
  MVT XLenVT = MVT::i32;


public:
  MyCPUSubTarget(const Triple &TT, StringRef CPU, StringRef TuneCPU,
                 StringRef FS, StringRef ABIName, const TargetMachine &TM);
};
} // namespace llvm

#endif // LLVM_MYCPUSUBTARGET_H

