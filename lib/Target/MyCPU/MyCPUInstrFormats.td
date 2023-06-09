class InstFormat<bits<5> val> {
  bits<5> Value = val;
}
def InstFormatR      : InstFormat<1>;
def InstFormatI      : InstFormat<3>;
def InstFormatS      : InstFormat<4>;
def InstFormatB      : InstFormat<5>;
def InstFormatU      : InstFormat<6>;
def InstFormatJ      : InstFormat<7>;

class MyCPUConstraint<bits<3> val> {
  bits<3> Value = val;
}
def NoConstraint  : MyCPUConstraint<0b000>;

class MyCPUOpcode<bits<7> val> {
  bits<7> Value = val;
}
def OPC_LOAD      : MyCPUOpcode<0b0000011>;
def OPC_OP_IMM    : MyCPUOpcode<0b0010011>;
def OPC_AUIPC     : MyCPUOpcode<0b0010111>;
def OPC_STORE     : MyCPUOpcode<0b0100011>;
def OPC_OP        : MyCPUOpcode<0b0110011>;
def OPC_LUI       : MyCPUOpcode<0b0110111>;
def OPC_BRANCH    : MyCPUOpcode<0b1100011>;
def OPC_JALR      : MyCPUOpcode<0b1100111>;
def OPC_JAL       : MyCPUOpcode<0b1101111>;

class MyCPUInst<dag outs, dag ins, string opcodestr, string argstr,
             list<dag> pattern, InstFormat format>
    : Instruction {
  field bits<32> Inst;
  // SoftFail is a field the disassembler can use to provide a way for
  // instructions to not match without killing the whole decode process. It is
  // mainly used for ARM, but Tablegen expects this field to exist or it fails
  // to build the decode table.
  field bits<32> SoftFail = 0;
  let Size = 4;

  bits<7> Opcode = 0;

  let Inst{6-0} = Opcode;

  let Namespace = "MyCPU";

  dag OutOperandList = outs;
  dag InOperandList = ins;
  let AsmString = opcodestr # "\t" # argstr;
  let Pattern = pattern;

  let TSFlags{4-0} = format.Value;

  // Defaults
  MyCPUConstraint MyConstraint = NoConstraint;
  let TSFlags{7-5} = MyConstraint.Value;

  bits<3> VLMul = 0;
  let TSFlags{10-8} = VLMul;

  bit HasDummyMask = 0;
  let TSFlags{11} = HasDummyMask;

  bit WritesElement0 = 0;
  let TSFlags{12} = WritesElement0;

  bit HasMergeOp = 0;
  let TSFlags{13} = HasMergeOp;

  bit HasSEWOp = 0;
  let TSFlags{14} = HasSEWOp;

  bit HasVLOp = 0;
  let TSFlags{15} = HasVLOp;
}

class MyCPUInstI<bits<3> funct3, MyCPUOpcode opcode, dag outs, dag ins,
              string opcodestr, string argstr>
    : MyCPUInst<outs, ins, opcodestr, argstr, [], InstFormatI> {
  bits<12> imm12;
  bits<5> rs1;
  bits<5> rd;

  let Inst{31-20} = imm12;
  let Inst{19-15} = rs1;
  let Inst{14-12} = funct3;
  let Inst{11-7} = rd;
  let Opcode = opcode.Value;
}

class MyCPUInstR<bits<7> funct7, bits<3> funct3, MyCPUOpcode opcode, dag outs,
              dag ins, string opcodestr, string argstr>
    : MyCPUInst<outs, ins, opcodestr, argstr, [], InstFormatR> {
  bits<5> rs2;
  bits<5> rs1;
  bits<5> rd;

  let Inst{31-25} = funct7;
  let Inst{24-20} = rs2;
  let Inst{19-15} = rs1;
  let Inst{14-12} = funct3;
  let Inst{11-7} = rd;
  let Opcode = opcode.Value;
}

class MyCPUInstS<bits<3> funct3, MyCPUOpcode opcode, dag outs, dag ins,
              string opcodestr, string argstr>
    : MyCPUInst<outs, ins, opcodestr, argstr, [], InstFormatS> {
  bits<12> imm12;
  bits<5> rs2;
  bits<5> rs1;

  let Inst{31-25} = imm12{11-5};
  let Inst{24-20} = rs2;
  let Inst{19-15} = rs1;
  let Inst{14-12} = funct3;
  let Inst{11-7} = imm12{4-0};
  let Opcode = opcode.Value;
}

class MyCPUInstB<bits<3> funct3, MyCPUOpcode opcode, dag outs, dag ins,
              string opcodestr, string argstr>
    : MyCPUInst<outs, ins, opcodestr, argstr, [], InstFormatB> {
  bits<12> imm12;
  bits<5> rs2;
  bits<5> rs1;

  let Inst{31} = imm12{11};
  let Inst{30-25} = imm12{9-4};
  let Inst{24-20} = rs2;
  let Inst{19-15} = rs1;
  let Inst{14-12} = funct3;
  let Inst{11-8} = imm12{3-0};
  let Inst{7} = imm12{10};
  let Opcode = opcode.Value;
}

class MyCPUInstU<MyCPUOpcode opcode, dag outs, dag ins, string opcodestr,
              string argstr>
    : MyCPUInst<outs, ins, opcodestr, argstr, [], InstFormatU> {
  bits<20> imm20;
  bits<5> rd;

  let Inst{31-12} = imm20;
  let Inst{11-7} = rd;
  let Opcode = opcode.Value;
}

class MyCPUInstJ<MyCPUOpcode opcode, dag outs, dag ins, string opcodestr,
              string argstr>
    : MyCPUInst<outs, ins, opcodestr, argstr, [], InstFormatJ> {
  bits<20> imm20;
  bits<5> rd;

  let Inst{31} = imm20{19};
  let Inst{30-21} = imm20{9-0};
  let Inst{20} = imm20{10};
  let Inst{19-12} = imm20{18-11};
  let Inst{11-7} = rd;
  let Opcode = opcode.Value;
}
