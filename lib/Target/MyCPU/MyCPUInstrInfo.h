//
// Created by BY210033 on 2023/6/9.
//

#ifndef LLVM_MYCPUINSTRINFO_H
#define LLVM_MYCPUINSTRINFO_H

#include "MyCPURegisterInfo.h"
#include "llvm/CodeGen/TargetInstrInfo.h"

#define GET_INSTRINFO_HEADER
#include "MyCPUGenInstrInfo.inc"

namespace llvm {

class MyCPUSubTarget;

class MyCPUInstrInfo : public MyCPUGenInstrInfo {

public:
  explicit MyCPUInstrInfo(MyCPUSubTarget &STI);

  void movImm(MachineBasicBlock &MBB, MachineBasicBlock::iterator MBBI,
              const DebugLoc &DL, Register DstReg, uint64_t Val,
              MachineInstr::MIFlag Flag = MachineInstr::NoFlags) const;

protected:
  const MyCPUSubTarget &STI;

};

}

#endif // LLVM_MYCPUINSTRINFO_H
