//
// Created by BY210033 on 2023/6/9.
//

#ifndef LLVM_MYCPUFRAMELOWERING_H
#define LLVM_MYCPUFRAMELOWERING_H

#include "llvm/CodeGen/TargetFrameLowering.h"
#include "llvm/Support/TypeSize.h"

namespace llvm {
class MyCPUSubTarget;

class MyCPUFrameLowering : public TargetFrameLowering {
public:
  explicit MyCPUFrameLowering(const MyCPUSubTarget &STI)
      : TargetFrameLowering(StackGrowsDown, Align(16), 0),
        STI(STI) {}

  bool hasFP(const MachineFunction &MF) const override;

  bool hasBP(const MachineFunction &MF) const;

protected:
  const MyCPUSubTarget &STI;
};

}

#endif // LLVM_MYCPUFRAMELOWERING_H
