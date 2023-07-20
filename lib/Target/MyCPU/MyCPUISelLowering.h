//
// Created by BY210033 on 2023/6/9.
//

#ifndef LLVM_MYCPUISELLOWERING_H
#define LLVM_MYCPUISELLOWERING_H

#include "MyCPU.h"
#include "llvm/CodeGen/SelectionDAG.h"
#include "llvm/CodeGen/TargetLowering.h"

namespace llvm {

class MyCPUSubtarget;
namespace MyCPUISD {
enum NodeType : unsigned {
  FIRST_NUMBER = ISD::BUILTIN_OP_END,
  RET_FLAG,
  URET_FLAG,
  SRET_FLAG,
  MRET_FLAG,
  CALL,
  SELECT_CC,
  BuildPairF64,
  SplitF64,
  TAIL,
  SLLW,
  SRAW,
  SRLW,
  DIVW,
  DIVUW,
  REMUW,
  ROLW,
  RORW,
  FSRW,
  FSLW,
  FMV_H_X,
  FMV_X_ANYEXTH,
  FMV_W_X_MU64,
  FMV_X_ANYEXTW_MU54,
  READ_CYCLE_WIND,
  GREVI,
  GREVIW,
  GORCI,
  GORCIW,
  VMV_X_S,
  SPLAT_VECTOR_I64,
  READ_VLENB,
  TRUNCATE_VECTOR,
  VLEFF,
  VLEFF_MASK,
  READ_VL,
  VSLIDEUP,
  VSLIDEDOWN,
  VID,
};
} // namespace MyCPUISD

class MyCPUTargetLowering : public TargetLowering {
  const MyCPUSubtarget &Subtarget;

public:
  explicit MyCPUTargetLowering(const TargetMachine &TM,
                               const MyCPUSubtarget &STI);

  const MyCPUSubtarget &getSubtarget() const { return Subtarget; }

  bool getTgtMemIntrinsic(IntrinsicInfo &info, const CallInst &inst,
                          MachineFunction &function,
                          unsigned int i) const override;
  bool isLegalAddressingMode(const DataLayout &DL, const AddrMode &AM, Type *Ty,
                             unsigned int AddrSpace,
                             Instruction *I) const override;
  bool isLegalICmpImmediate(int64_t int64) const override;
  bool isLegalAddImmediate(int64_t int64) const override;
};

}

#endif // LLVM_MYCPUISELLOWERING_H
