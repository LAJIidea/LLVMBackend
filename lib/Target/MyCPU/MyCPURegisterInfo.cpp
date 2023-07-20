//
// Created by BY210033 on 2023/6/9.
//
#include "MyCPUFrameLowering.h"
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

/**
 * 该函数用于将帧索引(Frame Index)替换为相应的基址寄存器和偏移量
 * @param II 迭代器，指向要处理的机器指令
 * @param SPAdj 堆栈指针调整值，用于计算基址寄存器和偏移量
 * @param FIOperandNum 帧索引操作数在指令中的位置
 * @param RS 寄存器临时使用器，用于分配临时寄存器
 */
void MyCPURegisterInfo::eliminateFrameIndex(
    MachineBasicBlock::iterator II, int SPAdj, unsigned int FIOperandNum,
    RegScavenger *RS) const {
    assert(SPAdj == 0 && "Unexpected non-zero SPAdj");

    MachineInstr &MI = *II;
    MachineFunction &MF = *MI.getParent()->getParent();
    MachineRegisterInfo &MRI = MF.getRegInfo();
    const MyCPUInstrInfo *TII = MF.getSubtarget<MyCPUSubTarget>().getInstrInfo();
    DebugLoc DL = MI.getDebugLoc();

    int FrameIndex = MI.getOperand(FIOperandNum).getIndex();
    Register FrameReg;
    int Offset = getFrameLowering(MF)
                     ->getFrameIndexReference(MF, FrameIndex, FrameReg)
                    .getFixed() +
                  MI.getOperand(FIOperandNum + 1).getImm();

    if (!isInt<32>(Offset)) {
      report_fatal_error(
          "Frame offsets outside of the signed 32-bit range not supported");
    }

    MachineBasicBlock &MBB = *MI.getParent();
    bool FrameRegIsKill = false;

    if (!isInt<12>(Offset)) {
      assert(isInt<32>(Offset) && "Int32 expected");
      Register ScratchReg = MRI.createVirtualRegister(&MyCPU::GPRRegClass);
      TII->movImm(MBB, II, DL, ScratchReg, Offset);
      BuildMI(MBB, II, DL, TII->get(MyCPU::ADD), ScratchReg)
          .addReg(FrameReg)
          .addReg(ScratchReg, RegState::Kill);
      Offset = 0;
      FrameReg = ScratchReg;
      FrameRegIsKill = true;
    }

    MI.getOperand(FIOperandNum)
        .ChangeToRegister(FrameReg, false, false, FrameRegIsKill);
    MI.getOperand(FIOperandNum + 1).ChangeToImmediate(Offset);
}

Register MyCPURegisterInfo::getFrameRegister(const MachineFunction &MF) const {
  const TargetFrameLowering *TFI = getFrameLowering(MF);
  return TFI->hasFP(MF) ? MyCPU::X8 : MyCPU::X2;
}


/**
 * 这段代码实现了getCalleeSaveRegs函数。用于返回调用者保存的寄存器列表
 * @param MF MachineFunction对象是编译器在后端阶段使用的数据结构
 * @return 保存的寄存器列表
 */
const MCPhysReg *
MyCPURegisterInfo::getCalleeSavedRegs(const MachineFunction *MF) const {
  // 获取当前函数的SubTarget实例
  auto &Subtarget = MF->getSubtarget<MyCPUSubTarget>();
  // getFunction获取的是获取的是当前待编译代码的函数对象，MachineFunction表示机器级别的
  // 的函数。MachineFunction对象是编译器在后端阶段使用的数据结构，用于表示待编译的机器代
  // 码函数。它与源代码中的函数相对应，但包含了与目标机器相关的额外信息。
  // 通过MF->getFunction()可以获取源代码中对应的函数对象，以便在后端代码中进行相关操作
  // 这里判断函数的调用约定是否为GHC(Glasgow Haskell Compiler)。如果是，直接返回一个空
  // 的保存寄存器列表`CSR_NoRegs_SaveList`表示不需要保存寄存器。
  if (MF->getFunction().getCallingConv() == CallingConv::GHC)
    return CSR_NoRegs_SaveList;
  // 检查当前函数是否具有`interrupt`属性，如果是，根据子目标的浮点拓展标志返回相应的中断
  // 处理保存寄存器列表.
  // `interrupt`属性表示一个函数是中断处理函数。中断处理是软件或硬件触发的事件，它会导致
  // CPU转移到一个特定的中断处理函数来处理中断。中断处理函数通常需要保存和恢复寄存器状态
  // 以确保在处理中断之后能正确的返回到原来的上下文。
  if (MF->getFunction().hasFnAttribute("interrupt")) {
    if (Subtarget.hasStdExtD())
      return CSR_XLEN_F64_Interrupt_SaveList;
    if (Subtarget.hasStdExtF())
      return CSR_XLEN_F32_Interrupt_SaveList;
    return CSR_Interrupt_SaveList;
  }

  // 根据子目标的目标ABI来返回保存寄存器列表
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

// 该函数是为了获取保留寄存器
BitVector MyCPURegisterInfo::getReservedRegs(const MachineFunction &MF) const {
  // 获取于给定MF相关的MyCPUFrameLowering相关实例，该实例用于访问帧相关信息。
  const MyCPUFrameLowering *TFI = getFrameLowering(MF);
  // 创建一个与寄存器数量相匹配的BitVector，用于表示保留的寄存器。
  BitVector Reserved(getNumRegs());

  for (size_t Reg = 0; Reg < getNumRegs(); ++Reg) {
    if (MF.getSubtarget<MyCPUSubTarget>().isRegisterReservedByUser(Reg))
      markSuperRegs(Reserved, Reg);
  }

  markSuperRegs(Reserved, MyCPU::X0);
  markSuperRegs(Reserved, MyCPU::X2);
  markSuperRegs(Reserved, MyCPU::X3);
  markSuperRegs(Reserved, MyCPU::X4);
  if (TFI->hasFP(MF))
    markSuperRegs(Reserved, MyCPU::X8);
  if (TFI->hasBP(MF))
    markSuperRegs(Reserved, MyCPUABI::getBPReg());

  markSuperRegs(Reserved, MyCPU::VL);
  markSuperRegs(Reserved, MyCPU::VTYPE);
  markSuperRegs(Reserved, MyCPU::VXSAT);
  markSuperRegs(Reserved, MyCPU::VXRM);

  assert(checkAllSuperRegsMarked(Reserved));
  return Reserved;
}
