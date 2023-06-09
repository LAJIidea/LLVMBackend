//
// Created by BY210033 on 2023/6/9.
//

#ifndef LLVM_MYCPUREGISTERINFO_H
#define LLVM_MYCPUREGISTERINFO_H

#include "llvm/CodeGen/TargetRegisterInfo.h"

#define GET_REGINFO_HEADER
#include "MyCPUGenRegisterInfo.inc"

namespace llvm {

struct MyCPURegisterInfo : public MyCPUGenRegisterInfo {

  MyCPURegisterInfo(unsigned HwMode);

  const MCPhysReg *getCalleeSavedRegs(const MachineFunction *MF) const override;

  BitVector getReservedRegs(const MachineFunction &MF) const override;

  void eliminateFrameIndex(MachineBasicBlock::iterator MI, int SPAdj,
                           unsigned int FIOperandNum,
                           RegScavenger *RS) const override;
  Register getFrameRegister(const MachineFunction &MF) const override;

  const TargetRegisterClass *
  getPointerRegClass(const MachineFunction &MF,
                     unsigned int Kind) const override {
    return &MyCPU::GPRRegClass;
  }
};

} // namespace llvm

#endif // LLVM_MYCPUREGISTERINFO_H
