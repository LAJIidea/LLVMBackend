
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
  bool HasStdExtM = false;
  bool HasStdExtA = false;
  bool HasStdExtF = false;
  bool HasStdExtD = false;
  bool HasStdExtC = false;
  bool HasStdExtB = false;
  bool HasMU64 = false;
  bool IsMU32E = false;
  unsigned XLen = 32;
  MVT XLenVT = MVT::i32;
  MyCPUABI::ABI TargetABI = MyCPUABI::ABI_Unknown;
  BitVector UserReservedRegister;
  MyCPUInstrInfo InstrInfo;


public:
  MyCPUSubTarget(const Triple &TT, StringRef CPU, StringRef TuneCPU,
                 StringRef FS, StringRef ABIName, const TargetMachine &TM);

  const MyCPUInstrInfo *getInstrInfo() const override { return &InstrInfo; }

  bool hasStdExtM() const { return HasStdExtM; }
  bool hasStdExtA() const { return HasStdExtA; }
  bool hasStdExtF() const { return HasStdExtF; }
  bool hasStdExtD() const { return HasStdExtD; }
  bool hasStdExtC() const { return HasStdExtC; }
  bool hasStdExtB() const { return HasStdExtB; }
  MyCPUABI::ABI getTargetABI() const { return TargetABI; }
  bool isRegisterReservedByUser(Register i) const {
    assert(i < MyCPU::NUM_TARGET_REGS && "Register out of range");
    return UserReservedRegister[i];
  }
};
} // namespace llvm

#endif // LLVM_MYCPUSUBTARGET_H

