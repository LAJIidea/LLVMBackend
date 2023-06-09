; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main -mattr=+mve.fp -verify-machineinstrs -o - %s | FileCheck %s

declare <16 x i1> @llvm.arm.mve.pred.i2v.v16i1(i32)
declare <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32)
declare <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32)

declare i32 @llvm.arm.mve.vabav.v16i8(i32, i32, <16 x i8>, <16 x i8>)
declare i32 @llvm.arm.mve.vabav.v8i16(i32, i32, <8 x i16>, <8 x i16>)
declare i32 @llvm.arm.mve.vabav.v4i32(i32, i32, <4 x i32>, <4 x i32>)

declare i32 @llvm.arm.mve.vabav.predicated.v16i8.v16i1(i32, i32, <16 x i8>, <16 x i8>, <16 x i1>)
declare i32 @llvm.arm.mve.vabav.predicated.v8i16.v8i1(i32, i32, <8 x i16>, <8 x i16>, <8 x i1>)
declare i32 @llvm.arm.mve.vabav.predicated.v4i32.v4i1(i32, i32, <4 x i32>, <4 x i32>, <4 x i1>)

define arm_aapcs_vfpcc i32 @test_vabavq_s8(i32 %a, <16 x i8> %b, <16 x i8> %c) {
; CHECK-LABEL: test_vabavq_s8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vabav.s8 r0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = call i32 @llvm.arm.mve.vabav.v16i8(i32 0, i32 %a, <16 x i8> %b, <16 x i8> %c)
  ret i32 %0
}

define arm_aapcs_vfpcc i32 @test_vabavq_s16(i32 %a, <8 x i16> %b, <8 x i16> %c) {
; CHECK-LABEL: test_vabavq_s16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vabav.s16 r0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = call i32 @llvm.arm.mve.vabav.v8i16(i32 0, i32 %a, <8 x i16> %b, <8 x i16> %c)
  ret i32 %0
}

define arm_aapcs_vfpcc i32 @test_vabavq_s32(i32 %a, <4 x i32> %b, <4 x i32> %c) {
; CHECK-LABEL: test_vabavq_s32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vabav.s32 r0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = call i32 @llvm.arm.mve.vabav.v4i32(i32 0, i32 %a, <4 x i32> %b, <4 x i32> %c)
  ret i32 %0
}

define arm_aapcs_vfpcc i32 @test_vabavq_u8(i32 %a, <16 x i8> %b, <16 x i8> %c) {
; CHECK-LABEL: test_vabavq_u8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vabav.u8 r0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = call i32 @llvm.arm.mve.vabav.v16i8(i32 1, i32 %a, <16 x i8> %b, <16 x i8> %c)
  ret i32 %0
}

define arm_aapcs_vfpcc i32 @test_vabavq_u16(i32 %a, <8 x i16> %b, <8 x i16> %c) {
; CHECK-LABEL: test_vabavq_u16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vabav.u16 r0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = call i32 @llvm.arm.mve.vabav.v8i16(i32 1, i32 %a, <8 x i16> %b, <8 x i16> %c)
  ret i32 %0
}

define arm_aapcs_vfpcc i32 @test_vabavq_u32(i32 %a, <4 x i32> %b, <4 x i32> %c) {
; CHECK-LABEL: test_vabavq_u32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vabav.u32 r0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = call i32 @llvm.arm.mve.vabav.v4i32(i32 1, i32 %a, <4 x i32> %b, <4 x i32> %c)
  ret i32 %0
}

define arm_aapcs_vfpcc i32 @test_vabavq_p_s8(i32 %a, <16 x i8> %b, <16 x i8> %c, i16 zeroext %p) {
; CHECK-LABEL: test_vabavq_p_s8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r1
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vabavt.s8 r0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = call <16 x i1> @llvm.arm.mve.pred.i2v.v16i1(i32 %0)
  %2 = call i32 @llvm.arm.mve.vabav.predicated.v16i8.v16i1(i32 0, i32 %a, <16 x i8> %b, <16 x i8> %c, <16 x i1> %1)
  ret i32 %2
}

define arm_aapcs_vfpcc i32 @test_vabavq_p_s16(i32 %a, <8 x i16> %b, <8 x i16> %c, i16 zeroext %p) {
; CHECK-LABEL: test_vabavq_p_s16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r1
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vabavt.s16 r0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 %0)
  %2 = call i32 @llvm.arm.mve.vabav.predicated.v8i16.v8i1(i32 0, i32 %a, <8 x i16> %b, <8 x i16> %c, <8 x i1> %1)
  ret i32 %2
}

define arm_aapcs_vfpcc i32 @test_vabavq_p_s32(i32 %a, <4 x i32> %b, <4 x i32> %c, i16 zeroext %p) {
; CHECK-LABEL: test_vabavq_p_s32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r1
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vabavt.s32 r0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 %0)
  %2 = call i32 @llvm.arm.mve.vabav.predicated.v4i32.v4i1(i32 0, i32 %a, <4 x i32> %b, <4 x i32> %c, <4 x i1> %1)
  ret i32 %2
}

define arm_aapcs_vfpcc i32 @test_vabavq_p_u8(i32 %a, <16 x i8> %b, <16 x i8> %c, i16 zeroext %p) {
; CHECK-LABEL: test_vabavq_p_u8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r1
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vabavt.u8 r0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = call <16 x i1> @llvm.arm.mve.pred.i2v.v16i1(i32 %0)
  %2 = call i32 @llvm.arm.mve.vabav.predicated.v16i8.v16i1(i32 1, i32 %a, <16 x i8> %b, <16 x i8> %c, <16 x i1> %1)
  ret i32 %2
}

define arm_aapcs_vfpcc i32 @test_vabavq_p_u16(i32 %a, <8 x i16> %b, <8 x i16> %c, i16 zeroext %p) {
; CHECK-LABEL: test_vabavq_p_u16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r1
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vabavt.u16 r0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 %0)
  %2 = call i32 @llvm.arm.mve.vabav.predicated.v8i16.v8i1(i32 1, i32 %a, <8 x i16> %b, <8 x i16> %c, <8 x i1> %1)
  ret i32 %2
}

define arm_aapcs_vfpcc i32 @test_vabavq_p_u32(i32 %a, <4 x i32> %b, <4 x i32> %c, i16 zeroext %p) {
; CHECK-LABEL: test_vabavq_p_u32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r1
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vabavt.u32 r0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 %0)
  %2 = call i32 @llvm.arm.mve.vabav.predicated.v4i32.v4i1(i32 1, i32 %a, <4 x i32> %b, <4 x i32> %c, <4 x i1> %1)
  ret i32 %2
}
