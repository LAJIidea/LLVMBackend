//
// Created by BY210033 on 2023/6/8.
//

#ifndef LLVM_MYCPUTARGETMACHINE_H
#define LLVM_MYCPUTARGETMACHINE_H

#include "MyCPUSubtarget.h"
#include "llvm/CodeGen/SelectionDAGTargetInfo.h"
#include "llvm/Target/TargetMachine.h"

namespace llvm {

class MyCPUTargetMachine : public LLVMTargetMachine {
    std::unique_ptr<TargetLoweringObjectFile> TLOF;

};

}

#endif // LLVM_MYCPUTARGETMACHINE_H
