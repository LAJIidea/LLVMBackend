//
// Created by BY210033 on 2023/6/9.
//
#include "MyCPUISelLowering.h"
#include "MyCPU.h"
#include "MyCPUMachineFunction.h"
#include "MyCPURegisterInfo.h"
#include "MyCPUSubtarget.h"
#include "llvm/ADT/SmallSet.h"
#include "llvm/ADT/Statistic.h"
#include "llvm/CodeGen/CallingConvLower.h"
#include "llvm/CodeGen/MachineFrameInfo.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"
#include "llvm/CodeGen/TargetLoweringObjectFileImpl.h"
#include "llvm/CodeGen/ValueTypes.h"
#include "llvm/IR/DiagnosticInfo.h"
#include "llvm/IR/DiagnosticHandler.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/KnownBits.h"
#include "llvm/Support/MathExtras.h"
#include "llvm/Support/raw_ostream.h"

using namespace llvm;

#define DEBUG_TYPE "mycpu-lower"

MyCPUTargetLowering::MyCPUTargetLowering(const TargetMachine &TM,
                                         const MyCPUSubtarget &STI)
    : TargetLowering(TM), Subtarget(STI) {}

bool MyCPUTargetLowering::getTgtMemIntrinsic(
    TargetLoweringBase::IntrinsicInfo &info, const CallInst &inst,
    MachineFunction &function, unsigned int i) const {
  return TargetLoweringBase::getTgtMemIntrinsic(info, inst, function, i);
}

bool MyCPUTargetLowering::isLegalAddressingMode(
    const DataLayout &DL, const TargetLoweringBase::AddrMode &AM, Type *Ty,
    unsigned int AddrSpace, Instruction *I) const {
  return TargetLoweringBase::isLegalAddressingMode(DL, AM, Ty, AddrSpace, I);
}

bool MyCPUTargetLowering::isLegalICmpImmediate(int64_t int64) const {
  return TargetLoweringBase::isLegalICmpImmediate(int64);
}

bool MyCPUTargetLowering::isLegalAddImmediate(int64_t int64) const {
  return TargetLoweringBase::isLegalAddImmediate(int64);
}
