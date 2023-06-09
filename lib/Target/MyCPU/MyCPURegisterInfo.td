let Namespace = "MyCPU" in {
class MyCPUReg<bits<5> Enc, string n, list<string> alt = []> : Register<n> {
  let HWEncoding{4-0} = Enc;
  let AltNames = alt;
}

class MyCPUReg16<bits<5> Enc, string n, list<string> alt = []> : Register<n> {
  let HWEncoding{4-0} = Enc;
  let AltNames = alt;
}

def sub_16 : SubRegIndex<16>;
class MyCPUReg32<MyCPUReg16 subreg> : Register<""> {
  let HWEncoding{4-0} = subreg.HWEncoding{4-0};
  let SubRegs = [subreg];
  let SubRegIndices = [sub_16];
  let AsmName = subreg.AsmName;
  let AltNames = subreg.AltNames;
}

def sub_32 : SubRegIndex<32>;
class MyCPUReg64<MyCPUReg32 subreg> : Register<""> {
  let HWEncoding{4-0} = subreg.HWEncoding{4-0};
  let SubRegs = [subreg];
  let SubRegIndices = [sub_32];
  let AsmName = subreg.AsmName;
  let AltNames = subreg.AltNames;
}

class MyCPURegWithSubRegs<bits<5> Enc, string n, list<Register> subregs,
                          list<string> alt = []>
      : RegisterWithSubRegs<n, subregs> {
  let HWEncoding{4-0} = Enc;
  let AltNames = alt;
}

def ABIRegAltName : RegAltNameIndex;

def sub_vrm1_0 : SubRegIndex<64,  -1>;
def sub_vrm1_1 : SubRegIndex<64,  -1>;
def sub_vrm1_2 : SubRegIndex<64,  -1>;
def sub_vrm1_3 : SubRegIndex<64,  -1>;
def sub_vrm1_4 : SubRegIndex<64,  -1>;
def sub_vrm1_5 : SubRegIndex<64,  -1>;
def sub_vrm1_6 : SubRegIndex<64,  -1>;
def sub_vrm1_7 : SubRegIndex<64,  -1>;
def sub_vrm2_0 : SubRegIndex<128, -1>;
def sub_vrm2_1 : SubRegIndex<128, -1>;
def sub_vrm2_2 : SubRegIndex<128, -1>;
def sub_vrm2_3 : SubRegIndex<128, -1>;
def sub_vrm4_0 : SubRegIndex<256, -1>;
def sub_vrm4_1 : SubRegIndex<256, -1>;

} // Namespace = "MyCPU"

let RegAltNameIndices = [ABIRegAltName] in {
  def X0  : MyCPUReg<0, "x0", ["zero"]>, DwarfRegNum<[0]>;
  let CostPerUse = 1 in {
  def X1  : MyCPUReg<1, "x1", ["ra"]>, DwarfRegNum<[1]>;
  def X2  : MyCPUReg<2, "x2", ["sp"]>, DwarfRegNum<[2]>;
  def X3  : MyCPUReg<3, "x3", ["gp"]>, DwarfRegNum<[3]>;
  def X4  : MyCPUReg<4, "x4", ["tp"]>, DwarfRegNum<[4]>;
  def X5  : MyCPUReg<5, "x5", ["t0"]>, DwarfRegNum<[5]>;
  def X6  : MyCPUReg<6, "x6", ["t1"]>, DwarfRegNum<[6]>;
  def X7  : MyCPUReg<7, "x7", ["t2"]>, DwarfRegNum<[7]>;
  }
  def X8  : MyCPUReg<8, "x8", ["s0", "fp"]>, DwarfRegNum<[8]>;
  def X9  : MyCPUReg<9, "x9", ["s1"]>, DwarfRegNum<[9]>;
  def X10 : MyCPUReg<10,"x10", ["a0"]>, DwarfRegNum<[10]>;
  def X11 : MyCPUReg<11,"x11", ["a1"]>, DwarfRegNum<[11]>;
  def X12 : MyCPUReg<12,"x12", ["a2"]>, DwarfRegNum<[12]>;
  def X13 : MyCPUReg<13,"x13", ["a3"]>, DwarfRegNum<[13]>;
  def X14 : MyCPUReg<14,"x14", ["a4"]>, DwarfRegNum<[14]>;
  def X15 : MyCPUReg<15,"x15", ["a5"]>, DwarfRegNum<[15]>;
  let CostPerUse = 1 in {
  def X16 : MyCPUReg<16,"x16", ["a6"]>, DwarfRegNum<[16]>;
  def X17 : MyCPUReg<17,"x17", ["a7"]>, DwarfRegNum<[17]>;
  def X18 : MyCPUReg<18,"x18", ["s2"]>, DwarfRegNum<[18]>;
  def X19 : MyCPUReg<19,"x19", ["s3"]>, DwarfRegNum<[19]>;
  def X20 : MyCPUReg<20,"x20", ["s4"]>, DwarfRegNum<[20]>;
  def X21 : MyCPUReg<21,"x21", ["s5"]>, DwarfRegNum<[21]>;
  def X22 : MyCPUReg<22,"x22", ["s6"]>, DwarfRegNum<[22]>;
  def X23 : MyCPUReg<23,"x23", ["s7"]>, DwarfRegNum<[23]>;
  def X24 : MyCPUReg<24,"x24", ["s8"]>, DwarfRegNum<[24]>;
  def X25 : MyCPUReg<25,"x25", ["s9"]>, DwarfRegNum<[25]>;
  def X26 : MyCPUReg<26,"x26", ["s10"]>, DwarfRegNum<[26]>;
  def X27 : MyCPUReg<27,"x27", ["s11"]>, DwarfRegNum<[27]>;
  def X28 : MyCPUReg<28,"x28", ["t3"]>, DwarfRegNum<[28]>;
  def X29 : MyCPUReg<29,"x29", ["t4"]>, DwarfRegNum<[29]>;
  def X30 : MyCPUReg<30,"x30", ["t5"]>, DwarfRegNum<[30]>;
  def X31 : MyCPUReg<31,"x31", ["t6"]>, DwarfRegNum<[31]>;
  }
}

def XLenVT : ValueTypeByHwMode<[MU32, MU64],
                               [i32,  i64]>;

// The order of registers represents the preferred allocation sequence.
// Registers are listed in the order caller-save, callee-save, specials.
def GPR : RegisterClass<"MyCPU", [XLenVT], 32, (add
    (sequence "X%u", 10, 17),
    (sequence "X%u", 5, 7),
    (sequence "X%u", 28, 31),
    (sequence "X%u", 8, 9),
    (sequence "X%u", 18, 27),
    (sequence "X%u", 0, 4)
  )> {
  let RegInfos = RegInfoByHwMode<
      [MU32,              MU64],
      [RegInfo<32,32,32>, RegInfo<64,64,64>]>;
}