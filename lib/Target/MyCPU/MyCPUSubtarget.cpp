//
// Created by BY210033 on 2023/6/9.
//
#include "MyCPU.h"
#include "MyCPUSubtarget.h"

using namespace llvm;

#define DEBUG_TYPE "mycpu-subtarget"
#define GET_SUBTARGETINFO_TARGET_DESC
#define GET_SUBTARGETINFO_CTOR
#include "MyCPUGenSubtargetInfo.inc"

void MyCPUSubTarget::anchor() {}

MyCPUSubTarget::MyCPUSubTarget(const Triple &TT, StringRef CPU,
                               StringRef TuneCPU, StringRef FS,
                               StringRef ABIName, const TargetMachine &TM)
    : MyCPUGenSubtargetInfo(TT, CPU, TuneCPU, FS) {

}

