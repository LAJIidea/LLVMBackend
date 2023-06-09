; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -vector-combine -S -mtriple=x86_64-- -mattr=sse2 | FileCheck %s --check-prefixes=CHECK,SSE
; RUN: opt < %s -vector-combine -S -mtriple=x86_64-- -mattr=avx2 | FileCheck %s --check-prefixes=CHECK,AVX

define i1 @fcmp_and_v2f64(<2 x double> %a) {
; SSE-LABEL: @fcmp_and_v2f64(
; SSE-NEXT:    [[E1:%.*]] = extractelement <2 x double> [[A:%.*]], i32 0
; SSE-NEXT:    [[E2:%.*]] = extractelement <2 x double> [[A]], i32 1
; SSE-NEXT:    [[CMP1:%.*]] = fcmp olt double [[E1]], 4.200000e+01
; SSE-NEXT:    [[CMP2:%.*]] = fcmp olt double [[E2]], -8.000000e+00
; SSE-NEXT:    [[R:%.*]] = and i1 [[CMP1]], [[CMP2]]
; SSE-NEXT:    ret i1 [[R]]
;
; AVX-LABEL: @fcmp_and_v2f64(
; AVX-NEXT:    [[TMP1:%.*]] = fcmp olt <2 x double> [[A:%.*]], <double 4.200000e+01, double -8.000000e+00>
; AVX-NEXT:    [[SHIFT:%.*]] = shufflevector <2 x i1> [[TMP1]], <2 x i1> poison, <2 x i32> <i32 1, i32 undef>
; AVX-NEXT:    [[TMP2:%.*]] = and <2 x i1> [[TMP1]], [[SHIFT]]
; AVX-NEXT:    [[R:%.*]] = extractelement <2 x i1> [[TMP2]], i64 0
; AVX-NEXT:    ret i1 [[R]]
;
  %e1 = extractelement <2 x double> %a, i32 0
  %e2 = extractelement <2 x double> %a, i32 1
  %cmp1 = fcmp olt double %e1, 42.0
  %cmp2 = fcmp olt double %e2, -8.0
  %r = and i1 %cmp1, %cmp2
  ret i1 %r
}

define i1 @fcmp_or_v4f64(<4 x double> %a) {
; SSE-LABEL: @fcmp_or_v4f64(
; SSE-NEXT:    [[E1:%.*]] = extractelement <4 x double> [[A:%.*]], i32 0
; SSE-NEXT:    [[E2:%.*]] = extractelement <4 x double> [[A]], i64 2
; SSE-NEXT:    [[CMP1:%.*]] = fcmp olt double [[E1]], 4.200000e+01
; SSE-NEXT:    [[CMP2:%.*]] = fcmp olt double [[E2]], -8.000000e+00
; SSE-NEXT:    [[R:%.*]] = or i1 [[CMP1]], [[CMP2]]
; SSE-NEXT:    ret i1 [[R]]
;
; AVX-LABEL: @fcmp_or_v4f64(
; AVX-NEXT:    [[TMP1:%.*]] = fcmp olt <4 x double> [[A:%.*]], <double 4.200000e+01, double undef, double -8.000000e+00, double undef>
; AVX-NEXT:    [[SHIFT:%.*]] = shufflevector <4 x i1> [[TMP1]], <4 x i1> poison, <4 x i32> <i32 2, i32 undef, i32 undef, i32 undef>
; AVX-NEXT:    [[TMP2:%.*]] = or <4 x i1> [[TMP1]], [[SHIFT]]
; AVX-NEXT:    [[R:%.*]] = extractelement <4 x i1> [[TMP2]], i64 0
; AVX-NEXT:    ret i1 [[R]]
;
  %e1 = extractelement <4 x double> %a, i32 0
  %e2 = extractelement <4 x double> %a, i64 2
  %cmp1 = fcmp olt double %e1, 42.0
  %cmp2 = fcmp olt double %e2, -8.0
  %r = or i1 %cmp1, %cmp2
  ret i1 %r
}

define i1 @icmp_xor_v4i32(<4 x i32> %a) {
; CHECK-LABEL: @icmp_xor_v4i32(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp sgt <4 x i32> [[A:%.*]], <i32 undef, i32 -8, i32 undef, i32 42>
; CHECK-NEXT:    [[SHIFT:%.*]] = shufflevector <4 x i1> [[TMP1]], <4 x i1> poison, <4 x i32> <i32 undef, i32 3, i32 undef, i32 undef>
; CHECK-NEXT:    [[TMP2:%.*]] = xor <4 x i1> [[TMP1]], [[SHIFT]]
; CHECK-NEXT:    [[R:%.*]] = extractelement <4 x i1> [[TMP2]], i64 1
; CHECK-NEXT:    ret i1 [[R]]
;
  %e1 = extractelement <4 x i32> %a, i32 3
  %e2 = extractelement <4 x i32> %a, i32 1
  %cmp1 = icmp sgt i32 %e1, 42
  %cmp2 = icmp sgt i32 %e2, -8
  %r = xor i1 %cmp1, %cmp2
  ret i1 %r
}

; add is not canonical (should be xor), but that is ok.

define i1 @icmp_add_v8i32(<8 x i32> %a) {
; SSE-LABEL: @icmp_add_v8i32(
; SSE-NEXT:    [[E1:%.*]] = extractelement <8 x i32> [[A:%.*]], i32 7
; SSE-NEXT:    [[E2:%.*]] = extractelement <8 x i32> [[A]], i32 2
; SSE-NEXT:    [[CMP1:%.*]] = icmp eq i32 [[E1]], 42
; SSE-NEXT:    [[CMP2:%.*]] = icmp eq i32 [[E2]], -8
; SSE-NEXT:    [[R:%.*]] = add i1 [[CMP1]], [[CMP2]]
; SSE-NEXT:    ret i1 [[R]]
;
; AVX-LABEL: @icmp_add_v8i32(
; AVX-NEXT:    [[TMP1:%.*]] = icmp eq <8 x i32> [[A:%.*]], <i32 undef, i32 undef, i32 -8, i32 undef, i32 undef, i32 undef, i32 undef, i32 42>
; AVX-NEXT:    [[SHIFT:%.*]] = shufflevector <8 x i1> [[TMP1]], <8 x i1> poison, <8 x i32> <i32 undef, i32 undef, i32 7, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
; AVX-NEXT:    [[TMP2:%.*]] = add <8 x i1> [[TMP1]], [[SHIFT]]
; AVX-NEXT:    [[R:%.*]] = extractelement <8 x i1> [[TMP2]], i64 2
; AVX-NEXT:    ret i1 [[R]]
;
  %e1 = extractelement <8 x i32> %a, i32 7
  %e2 = extractelement <8 x i32> %a, i32 2
  %cmp1 = icmp eq i32 %e1, 42
  %cmp2 = icmp eq i32 %e2, -8
  %r = add i1 %cmp1, %cmp2
  ret i1 %r
}

; Negative test - this could CSE/simplify.

define i1 @same_extract_index(<4 x i32> %a) {
; CHECK-LABEL: @same_extract_index(
; CHECK-NEXT:    [[E1:%.*]] = extractelement <4 x i32> [[A:%.*]], i32 2
; CHECK-NEXT:    [[E2:%.*]] = extractelement <4 x i32> [[A]], i32 2
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ugt i32 [[E1]], 42
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ugt i32 [[E2]], -8
; CHECK-NEXT:    [[R:%.*]] = and i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %e1 = extractelement <4 x i32> %a, i32 2
  %e2 = extractelement <4 x i32> %a, i32 2
  %cmp1 = icmp ugt i32 %e1, 42
  %cmp2 = icmp ugt i32 %e2, -8
  %r = and i1 %cmp1, %cmp2
  ret i1 %r
}

; Negative test - need identical predicates.

define i1 @different_preds(<4 x i32> %a) {
; CHECK-LABEL: @different_preds(
; CHECK-NEXT:    [[E1:%.*]] = extractelement <4 x i32> [[A:%.*]], i32 1
; CHECK-NEXT:    [[E2:%.*]] = extractelement <4 x i32> [[A]], i32 2
; CHECK-NEXT:    [[CMP1:%.*]] = icmp sgt i32 [[E1]], 42
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ugt i32 [[E2]], -8
; CHECK-NEXT:    [[R:%.*]] = and i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %e1 = extractelement <4 x i32> %a, i32 1
  %e2 = extractelement <4 x i32> %a, i32 2
  %cmp1 = icmp sgt i32 %e1, 42
  %cmp2 = icmp ugt i32 %e2, -8
  %r = and i1 %cmp1, %cmp2
  ret i1 %r
}

; Negative test - need 1 source vector.

define i1 @different_source_vec(<4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: @different_source_vec(
; CHECK-NEXT:    [[E1:%.*]] = extractelement <4 x i32> [[A:%.*]], i32 1
; CHECK-NEXT:    [[E2:%.*]] = extractelement <4 x i32> [[B:%.*]], i32 2
; CHECK-NEXT:    [[CMP1:%.*]] = icmp sgt i32 [[E1]], 42
; CHECK-NEXT:    [[CMP2:%.*]] = icmp sgt i32 [[E2]], -8
; CHECK-NEXT:    [[R:%.*]] = and i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %e1 = extractelement <4 x i32> %a, i32 1
  %e2 = extractelement <4 x i32> %b, i32 2
  %cmp1 = icmp sgt i32 %e1, 42
  %cmp2 = icmp sgt i32 %e2, -8
  %r = and i1 %cmp1, %cmp2
  ret i1 %r
}

; Negative test - don't try this with scalable vectors.

define i1 @scalable(<vscale x 4 x i32> %a) {
; CHECK-LABEL: @scalable(
; CHECK-NEXT:    [[E1:%.*]] = extractelement <vscale x 4 x i32> [[A:%.*]], i32 3
; CHECK-NEXT:    [[E2:%.*]] = extractelement <vscale x 4 x i32> [[A]], i32 1
; CHECK-NEXT:    [[CMP1:%.*]] = icmp sgt i32 [[E1]], 42
; CHECK-NEXT:    [[CMP2:%.*]] = icmp sgt i32 [[E2]], -8
; CHECK-NEXT:    [[R:%.*]] = xor i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %e1 = extractelement <vscale x 4 x i32> %a, i32 3
  %e2 = extractelement <vscale x 4 x i32> %a, i32 1
  %cmp1 = icmp sgt i32 %e1, 42
  %cmp2 = icmp sgt i32 %e2, -8
  %r = xor i1 %cmp1, %cmp2
  ret i1 %r
}
