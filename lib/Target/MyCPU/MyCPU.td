include "llvm/Target/Target.td"

defvar MU32 = DefaultMode;
def MU64           : HwMode<"+64bit">;

include "MyCPUSchedule.td"
include "MyCPURegisterInfo.td"
include "MyCPUInstrInfo.td"


def MyCPUInstrInfo : InstrInfo {
  let guessInstructionProperties = 0;
}

def MyCPUAsmParser : AsmParser {
  let ShouldEmitMatchRegisterAltName = 1;
  let AllowDuplicateRegisterNames = 1;
}

def MyCPUAsmWriter : AsmWriter {
  int PassSubtarget = 1;
}

def MyCPU : Target {
  let InstructionSet = MyCPUInstrInfo;
  let AssemblyParsers = [MyCPUAsmParser];
  let AssemblyWriters = [MyCPUAsmWriter];
  let AllowRegisterRenaming = 1;
}