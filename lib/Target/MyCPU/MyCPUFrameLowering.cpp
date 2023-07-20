//
// Created by BY210033 on 2023/6/9.
//
#include "MyCPUFrameLowering.h"
#include "MyCPUMachineFunction.h"
#include "MyCPUSubtarget.h"
#include "llvm/CodeGen/MachineFrameInfo.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/MachineRegionInfo.h"
#include "llvm/CodeGen/RegisterScavenging.h"
#include "llvm/IR/DiagnosticInfo.h"
#include "llvm/MC/MCDwarf.h"

using namespace llvm;

bool MyCPUFrameLowering::hasFP(const MachineFunction &MF) const {
  return false;
}
bool MyCPUFrameLowering::hasBP(const MachineFunction &MF) const {
  return false;
}
