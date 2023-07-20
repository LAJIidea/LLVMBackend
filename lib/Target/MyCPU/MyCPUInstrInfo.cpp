//
// Created by BY210033 on 2023/6/9.
//
#include "MyCPUInstrInfo.h"
#include "MyCPU.h"
#include "MyCPUSubtarget.h"
#include "MyCPUTargetMachine.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/CodeGen/MachineFunctionPass.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"
#include "llvm/CodeGen/RegisterScavenging.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/TargetRegistry.h"

using namespace llvm;

#define GEN_CHECK_COMPRESS_INSTR
//#include "MyCPUGenComp"

#define GET_INSTRINFO_CTOR_DTOR
#include "MyCPUGenInstrInfo.inc"

MyCPUInstrInfo::MyCPUInstrInfo(MyCPUSubTarget &STI)
    : MyCPUGenInstrInfo(), STI(STI) {}

void MyCPUInstrInfo::movImm(MachineBasicBlock &MBB,
                            MachineBasicBlock::iterator MBBI,
                            const DebugLoc &DL, Register DstReg, uint64_t Val,
                            MachineInstr::MIFlag Flag) const {

}
