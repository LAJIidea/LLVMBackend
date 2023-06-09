
//===----------------------------------------------------------------------===//
//
// 本文件定义了`MyCPUSubtarget`类，该
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_MYCPUSUBTARGET_H
#define LLVM_MYCPUSUBTARGET_H

#include "llvm/CodeGen/TargetSubtargetInfo.h"
#include "llvm/Target/TargetMachine.h"

#define GET_SUBTARGETINFO_HEADER
#include "MyCPUGenSubtargetInfo.inc"

namespace llvm {
class StringRef;

class MyCPUSubTarget : public MyCPUGenSubtargetInfo {
  virtual void anchor();

public:
  MyCPUSubTarget(const Triple &TT, StringRef CPU, StringRef FS,
                 StringRef ABIName, const TargetMachine &TM);
};
} // namespace llvm

#endif // LLVM_MYCPUSUBTARGET_H

