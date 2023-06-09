add_llvm_component_group(MyCPU)

set(LLVM_TARGET_DEFINITIONS MyCPU.td)

tablegen(LLVM MyCPUGenAsmMatcher.inc -gen-asm-matcher)
tablegen(LLVM MyCPUAsmWriter.inc -gen-asm-writer)
tablegen(LLVM MyCPUGenRegisterInfo.inc -gen-register-info)
tablegen(LLVM MyCPUGenInstrInfo.inc -gen-instr-info)
tablegen(LLVM MyCPUGenCodeEmitter.inc -gen-emitter)
tablegen(LLVM MyCPUGenMCCodeEmitter.inc -gen-emitter)
tablegen(LLVM MyCPUGenDAGISel.inc -gen-dag-isel)
tablegen(LLVM MyCPUGenSubTargetInfo.inc -gen-subtarget)

add_public_tablegen_target(MyCPUCommonTableGen)

add_llvm_target(MyCPUCodeGen
        MyCPUAsmPrinter.cpp
        MyCPUFrameLowering.cpp
        MyCPUInstrInfo.cpp
        MyCPUISelDAGToDAG.cpp
        MyCPUISelLowering.cpp
        MyCPUMachineFunction.cpp
        MyCPUMCInstLower.cpp
        MyCPURegisterInfo.cpp
        MyCPUTargetMachine.cpp
        MyCPUSubtarget.cpp
        MyCPUTargetObjectFile.cpp
        MyCPUTargetTransformInfo.cpp
        )

#add_dependencies(LLVMMyCPUCodeGen intrinsics_gen)

add_subdirectory(TargetInfo)
add_subdirectory(MCTargetDesc)
