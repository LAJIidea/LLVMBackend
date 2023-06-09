; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -instsimplify < %s | FileCheck %s

target datalayout = "e-m:o-i64:64-f80:128-n8:16:32:64-S128"

%struct.A = type { [7 x i8] }

define %struct.A* @test1(%struct.A* %b, %struct.A* %e) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    ret %struct.A* [[E:%.*]]
;
  %e_ptr = ptrtoint %struct.A* %e to i64
  %b_ptr = ptrtoint %struct.A* %b to i64
  %sub = sub i64 %e_ptr, %b_ptr
  %sdiv = sdiv exact i64 %sub, 7
  %gep = getelementptr inbounds %struct.A, %struct.A* %b, i64 %sdiv
  ret %struct.A* %gep
}

define i8* @test2(i8* %b, i8* %e) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    ret i8* [[E:%.*]]
;
  %e_ptr = ptrtoint i8* %e to i64
  %b_ptr = ptrtoint i8* %b to i64
  %sub = sub i64 %e_ptr, %b_ptr
  %gep = getelementptr inbounds i8, i8* %b, i64 %sub
  ret i8* %gep
}

define i64* @test3(i64* %b, i64* %e) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:    ret i64* [[E:%.*]]
;
  %e_ptr = ptrtoint i64* %e to i64
  %b_ptr = ptrtoint i64* %b to i64
  %sub = sub i64 %e_ptr, %b_ptr
  %ashr = ashr exact i64 %sub, 3
  %gep = getelementptr inbounds i64, i64* %b, i64 %ashr
  ret i64* %gep
}

; The following tests should not be folded to null, because this would
; lose provenance of the base pointer %b.

define %struct.A* @test4(%struct.A* %b) {
; CHECK-LABEL: @test4(
; CHECK-NEXT:    [[B_PTR:%.*]] = ptrtoint %struct.A* [[B:%.*]] to i64
; CHECK-NEXT:    [[SUB:%.*]] = sub i64 0, [[B_PTR]]
; CHECK-NEXT:    [[SDIV:%.*]] = sdiv exact i64 [[SUB]], 7
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr [[STRUCT_A:%.*]], %struct.A* [[B]], i64 [[SDIV]]
; CHECK-NEXT:    ret %struct.A* [[GEP]]
;
  %b_ptr = ptrtoint %struct.A* %b to i64
  %sub = sub i64 0, %b_ptr
  %sdiv = sdiv exact i64 %sub, 7
  %gep = getelementptr %struct.A, %struct.A* %b, i64 %sdiv
  ret %struct.A* %gep
}

define %struct.A* @test4_inbounds(%struct.A* %b) {
; CHECK-LABEL: @test4_inbounds(
; CHECK-NEXT:    [[B_PTR:%.*]] = ptrtoint %struct.A* [[B:%.*]] to i64
; CHECK-NEXT:    [[SUB:%.*]] = sub i64 0, [[B_PTR]]
; CHECK-NEXT:    [[SDIV:%.*]] = sdiv exact i64 [[SUB]], 7
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr inbounds [[STRUCT_A:%.*]], %struct.A* [[B]], i64 [[SDIV]]
; CHECK-NEXT:    ret %struct.A* [[GEP]]
;
  %b_ptr = ptrtoint %struct.A* %b to i64
  %sub = sub i64 0, %b_ptr
  %sdiv = sdiv exact i64 %sub, 7
  %gep = getelementptr inbounds %struct.A, %struct.A* %b, i64 %sdiv
  ret %struct.A* %gep
}

define i8* @test5(i8* %b) {
; CHECK-LABEL: @test5(
; CHECK-NEXT:    [[B_PTR:%.*]] = ptrtoint i8* [[B:%.*]] to i64
; CHECK-NEXT:    [[SUB:%.*]] = sub i64 0, [[B_PTR]]
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr i8, i8* [[B]], i64 [[SUB]]
; CHECK-NEXT:    ret i8* [[GEP]]
;
  %b_ptr = ptrtoint i8* %b to i64
  %sub = sub i64 0, %b_ptr
  %gep = getelementptr i8, i8* %b, i64 %sub
  ret i8* %gep
}

define i8* @test5_inbounds(i8* %b) {
; CHECK-LABEL: @test5_inbounds(
; CHECK-NEXT:    [[B_PTR:%.*]] = ptrtoint i8* [[B:%.*]] to i64
; CHECK-NEXT:    [[SUB:%.*]] = sub i64 0, [[B_PTR]]
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr inbounds i8, i8* [[B]], i64 [[SUB]]
; CHECK-NEXT:    ret i8* [[GEP]]
;
  %b_ptr = ptrtoint i8* %b to i64
  %sub = sub i64 0, %b_ptr
  %gep = getelementptr inbounds i8, i8* %b, i64 %sub
  ret i8* %gep
}

define i64* @test6(i64* %b) {
; CHECK-LABEL: @test6(
; CHECK-NEXT:    [[B_PTR:%.*]] = ptrtoint i64* [[B:%.*]] to i64
; CHECK-NEXT:    [[SUB:%.*]] = sub i64 0, [[B_PTR]]
; CHECK-NEXT:    [[ASHR:%.*]] = ashr exact i64 [[SUB]], 3
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr i64, i64* [[B]], i64 [[ASHR]]
; CHECK-NEXT:    ret i64* [[GEP]]
;
  %b_ptr = ptrtoint i64* %b to i64
  %sub = sub i64 0, %b_ptr
  %ashr = ashr exact i64 %sub, 3
  %gep = getelementptr i64, i64* %b, i64 %ashr
  ret i64* %gep
}

define i64* @test6_inbounds(i64* %b) {
; CHECK-LABEL: @test6_inbounds(
; CHECK-NEXT:    [[B_PTR:%.*]] = ptrtoint i64* [[B:%.*]] to i64
; CHECK-NEXT:    [[SUB:%.*]] = sub i64 0, [[B_PTR]]
; CHECK-NEXT:    [[ASHR:%.*]] = ashr exact i64 [[SUB]], 3
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr inbounds i64, i64* [[B]], i64 [[ASHR]]
; CHECK-NEXT:    ret i64* [[GEP]]
;
  %b_ptr = ptrtoint i64* %b to i64
  %sub = sub i64 0, %b_ptr
  %ashr = ashr exact i64 %sub, 3
  %gep = getelementptr inbounds i64, i64* %b, i64 %ashr
  ret i64* %gep
}

define i8* @test7(i8* %b, i8** %e) {
; CHECK-LABEL: @test7(
; CHECK-NEXT:    [[E_PTR:%.*]] = ptrtoint i8** [[E:%.*]] to i64
; CHECK-NEXT:    [[B_PTR:%.*]] = ptrtoint i8* [[B:%.*]] to i64
; CHECK-NEXT:    [[SUB:%.*]] = sub i64 [[E_PTR]], [[B_PTR]]
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr inbounds i8, i8* [[B]], i64 [[SUB]]
; CHECK-NEXT:    ret i8* [[GEP]]
;
  %e_ptr = ptrtoint i8** %e to i64
  %b_ptr = ptrtoint i8* %b to i64
  %sub = sub i64 %e_ptr, %b_ptr
  %gep = getelementptr inbounds i8, i8* %b, i64 %sub
  ret i8* %gep
}

define <8 x i64*> @undef_vec1() {
; CHECK-LABEL: @undef_vec1(
; CHECK-NEXT:    ret <8 x i64*> undef
;
  %el = getelementptr inbounds i64, i64* undef, <8 x i64> undef
  ret <8 x i64*> %el
}

define <8 x i64*> @undef_vec2() {
; CHECK-LABEL: @undef_vec2(
; CHECK-NEXT:    ret <8 x i64*> undef
;
  %el = getelementptr i64, <8 x i64*> undef, <8 x i64> undef
  ret <8 x i64*> %el
}

; Check ConstantExpr::getGetElementPtr() using ElementCount for size queries - begin.

; Constant ptr

define i32* @ptr_idx_scalar() {
; CHECK-LABEL: @ptr_idx_scalar(
; CHECK-NEXT:    ret i32* inttoptr (i64 4 to i32*)
;
  %gep = getelementptr <4 x i32>, <4 x i32>* null, i64 0, i64 1
  ret i32* %gep
}

define <2 x i32*> @ptr_idx_vector() {
; CHECK-LABEL: @ptr_idx_vector(
; CHECK-NEXT:    ret <2 x i32*> getelementptr (i32, i32* null, <2 x i64> <i64 1, i64 1>)
;
  %gep = getelementptr i32, i32* null, <2 x i64> <i64 1, i64 1>
  ret <2 x i32*> %gep
}

define <4 x i32*> @ptr_idx_mix_scalar_vector(){
; CHECK-LABEL: @ptr_idx_mix_scalar_vector(
; CHECK-NEXT:    ret <4 x i32*> getelementptr ([42 x [3 x i32]], [42 x [3 x i32]]* null, <4 x i64> zeroinitializer, <4 x i64> <i64 0, i64 1, i64 2, i64 3>, <4 x i64> zeroinitializer)
;
  %gep = getelementptr [42 x [3 x i32]], [42 x [3 x i32]]* null, i64 0, <4 x i64> <i64 0, i64 1, i64 2, i64 3>, i64 0
  ret <4 x i32*> %gep
}

; Constant vector

define <4 x i32*> @vector_idx_scalar() {
; CHECK-LABEL: @vector_idx_scalar(
; CHECK-NEXT:    ret <4 x i32*> getelementptr (i32, <4 x i32*> zeroinitializer, <4 x i64> <i64 1, i64 1, i64 1, i64 1>)
;
  %gep = getelementptr i32, <4 x i32*> zeroinitializer, i64 1
  ret <4 x i32*> %gep
}

define <4 x i32*> @vector_idx_vector() {
; CHECK-LABEL: @vector_idx_vector(
; CHECK-NEXT:    ret <4 x i32*> getelementptr (i32, <4 x i32*> zeroinitializer, <4 x i64> <i64 1, i64 1, i64 1, i64 1>)
;
  %gep = getelementptr i32, <4 x i32*> zeroinitializer, <4 x i64> <i64 1, i64 1, i64 1, i64 1>
  ret <4 x i32*> %gep
}

%struct = type { double, float }
define <4 x float*> @vector_idx_mix_scalar_vector() {
; CHECK-LABEL: @vector_idx_mix_scalar_vector(
; CHECK-NEXT:    ret <4 x float*> getelementptr (%struct, <4 x %struct*> zeroinitializer, <4 x i64> zeroinitializer, i32 1)
;
  %gep = getelementptr %struct, <4 x %struct*> zeroinitializer, i32 0, <4 x i32> <i32 1, i32 1, i32 1, i32 1>
  ret <4 x float*> %gep
}

; Constant scalable

define <vscale x 4 x i32*> @scalable_idx_scalar() {
; CHECK-LABEL: @scalable_idx_scalar(
; CHECK-NEXT:    ret <vscale x 4 x i32*> getelementptr (i32, <vscale x 4 x i32*> zeroinitializer, <vscale x 4 x i64> shufflevector (<vscale x 4 x i64> insertelement (<vscale x 4 x i64> undef, i64 1, i32 0), <vscale x 4 x i64> undef, <vscale x 4 x i32> zeroinitializer))
;
  %gep = getelementptr i32, <vscale x 4 x i32*> zeroinitializer, i64 1
  ret <vscale x 4 x i32*> %gep
}

define <vscale x 4 x float*> @scalable_vector_idx_mix_scalar_vector() {
; CHECK-LABEL: @scalable_vector_idx_mix_scalar_vector(
; CHECK-NEXT:    ret <vscale x 4 x float*> getelementptr (%struct, <vscale x 4 x %struct*> zeroinitializer, <vscale x 4 x i64> zeroinitializer, i32 1)
;
  %gep = getelementptr %struct, <vscale x 4 x %struct*> zeroinitializer, i32 0, i32 1
  ret <vscale x 4 x float*> %gep
}

define <vscale x 2 x i64*> @ptr_idx_mix_scalar_scalable_vector() {
; CHECK-LABEL: @ptr_idx_mix_scalar_scalable_vector(
; CHECK-NEXT:    ret <vscale x 2 x i64*> zeroinitializer
;
  %v = getelementptr [2 x i64], [2 x i64]* null, i64 0, <vscale x 2 x i64> zeroinitializer
  ret <vscale x 2 x i64*> %v
}

; Check ConstantExpr::getGetElementPtr() using ElementCount for size queries - end.

; TODO: these should return poison

define i8* @poison() {
; CHECK-LABEL: @poison(
; CHECK-NEXT:    ret i8* poison
;
  %v = getelementptr i8, i8* poison, i64 1
  ret i8* %v
}

define i8* @poison2(i8* %baseptr) {
; CHECK-LABEL: @poison2(
; CHECK-NEXT:    ret i8* poison
;
  %v = getelementptr i8, i8* %baseptr, i64 poison
  ret i8* %v
}
