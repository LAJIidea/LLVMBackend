//
// Created by BY210033 on 2023/6/9.
//
#include "MyCPURegisterInfo.h"
#include "MyCPU.h"
#include "MyCPUSubtarget.h"
#include "MyCPUMachineFunction.h"
#include "llvm/CodeGen/MachineFrameInfo.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/RegisterScavenging.h"
#include "llvm/CodeGen/TargetFrameLowering.h"
#include "llvm/Support/ErrorHandling.h"

#define GET_REGINFO_TARGET_DESC
#include "MyCPUGenRegisterInfo.inc"

using namespace llvm;

MyCPURegisterInfo::MyCPURegisterInfo(unsigned int HwMode)
    : MyCPUGenRegisterInfo(MyCPU::X1, 0, 0, 0, HwMode) {}

void MyCPURegisterInfo::eliminateFrameIndex(
    MachineBasicBlock::iterator MI, int SPAdj, unsigned int FIOperandNum,
    RegScavenger *RS) const {
  return CSR_NoRegs_SaveList;
}

Register MyCPURegisterInfo::getFrameRegister(const MachineFunction &MF) const {
  return Register();
}

const MCPhysReg *
MyCPURegisterInfo::getCalleeSavedRegs(const MachineFunction *MF) const {
  return nullptr;
}

BitVector MyCPURegisterInfo::getReservedRegs(const MachineFunction &MF) const {
  return BitVector();
}
