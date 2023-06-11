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
}

Register MyCPURegisterInfo::getFrameRegister(const MachineFunction &MF) const {
  return Register();
}

const MCPhysReg *
MyCPURegisterInfo::getCalleeSavedRegs(const MachineFunction *MF) const {
  auto &Subtarget = MF->getSubtarget<MyCPUSubTarget>();
  if (MF->getFunction().getCallingConv() == CallingConv::GHC)
    return CSR_NoRegs_SaveList;
  if (MF->getFunction().hasFnAttribute("interrupt")) {
    if (Subtarget.hasStdExtD())
      return CSR_XLEN_F64_Interrupt_SaveList;
    if (Subtarget.hasStdExtF())
      return CSR_XLEN_F32_Interrupt_SaveList;
    return CSR_Interrupt_SaveList;
  }

  switch (Subtarget.getTargetABI()) {
  default:
    llvm_unreachable("Unrecognized ABI");
  case MyCPUABI::ABI_ILP32:
  case MyCPUABI::ABI_LP64:
    return CSR_ILP32_LP64_SaveList;
  case MyCPUABI::ABI_ILP32F:
  case MyCPUABI::ABI_LP64F:
    return CSR_ILP32F_LP64F_SaveList;
  case MyCPUABI::ABI_ILP32D:
  case MyCPUABI::ABI_LP64D:
    return CSR_ILP32D_LP64D_SaveList;
  }
}

BitVector MyCPURegisterInfo::getReservedRegs(const MachineFunction &MF) const {
  return BitVector();
}
