//
// Created by BY210033 on 2023/6/9.
//

#ifndef LLVM_MYCPUTARGETDESC_H
#define LLVM_MYCPUTARGETDESC_H

#include "llvm/Config/config.h"
#include "llvm/MC/MCTargetOptions.h"
#include "llvm/Support/DataTypes.h"
#include <memory>

#define GET_REGINFO_ENUM
#include "MyCPUGenRegisterInfo.inc"



#endif // LLVM_MYCPUTARGETDESC_H
