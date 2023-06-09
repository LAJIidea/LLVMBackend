; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -rewrite-statepoints-for-gc -S < %s | FileCheck %s
; RUN: opt -passes=rewrite-statepoints-for-gc -S < %s | FileCheck %s
; Check that the "deopt-lowering" function attribute gets transcoded into
; flags on the resulting statepoint

target datalayout = "e-m:o-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.11.0"

declare void @foo()
declare void @bar() "deopt-lowering"="live-in"
declare void @baz() "deopt-lowering"="live-through"

define void @test1() gc "statepoint-example" {
; CHECK-LABEL: @test1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[STATEPOINT_TOKEN:%.*]] = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 2882400000, i32 0, void ()* @foo, i32 0, i32 0, i32 0, i32 0) [ "deopt"(i32 57) ]
; CHECK-NEXT:    [[STATEPOINT_TOKEN1:%.*]] = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 2882400000, i32 0, void ()* @bar, i32 0, i32 2, i32 0, i32 0) [ "deopt"(i32 42) ]
; CHECK-NEXT:    [[STATEPOINT_TOKEN2:%.*]] = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 2882400000, i32 0, void ()* @baz, i32 0, i32 0, i32 0, i32 0) [ "deopt"(i32 13) ]
; CHECK-NEXT:    ret void
;

entry:
  call void @foo() [ "deopt"(i32 57) ]
  call void @bar() [ "deopt"(i32 42) ]
  call void @baz() [ "deopt"(i32 13) ]
  ret void
}

; add deopt-lowering attribute as part of callsite
define void @test2() gc "statepoint-example" {
; CHECK-LABEL: @test2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[STATEPOINT_TOKEN:%.*]] = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 2882400000, i32 0, void ()* @foo, i32 0, i32 2, i32 0, i32 0) #0 [ "deopt"(i32 57) ]
; CHECK-NEXT:    ret void
;

entry:
  call void @foo()  "deopt-lowering"="live-in"  [ "deopt"(i32 57) ]
  ret void
}

