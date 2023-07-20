//
// Created by BY210033 on 2023/7/20.
//
#include "llvm/Analysis/Passes.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/LegacyPassManager.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/PassManager.h"
#include "llvm/Support/FileSystem.h"
#include "llvm/Support/TargetRegistry.h"
#include "llvm/Support/TargetSelect.h"
#include "llvm/Target/TargetMachine.h"
#include "llvm/Transforms/Scalar.h"
#include "gtest/gtest.h"
#include <iostream>

using namespace llvm;

namespace {

class SelectionISelTest : public testing::Test {



};


// Example below
//#include <stdio.h>
//
//int add(int a, int b) {
//  return a + b;
//}
//
//int main() {
//  int a = 5;
//  int b = 7;
//  int result;
//  if (a > b) {
//    result = add(a, b);
//  } else {
//    result = add(b, a);
//  }
//  return result;
//}
TEST(SelectionISelTest, SampleTest) {
  llvm::InitializeAllTargetInfos();
  llvm::InitializeAllTargets();
  llvm::InitializeAllTargetMCs();
  llvm::InitializeAllAsmPrinters();
  llvm::InitializeAllAsmParsers();

  LLVMContext Context;
  Module *TheModule = new Module("my module", Context);

//  llvm::PassBuilder PB;
//
//  PM.add(llvm::createFunctionInliningPass());

  IRBuilder<> Builder(Context);

  // define function type for 'add'
  std::vector<Type*> AddFuncArgs;
  AddFuncArgs.push_back(Type::getInt32Ty(Context));
  AddFuncArgs.push_back(Type::getInt32Ty(Context));
  FunctionType *AddFuncType =
    FunctionType::get(Type::getInt32Ty(Context), AddFuncArgs, false);

  // define 'add' function
  Function *AddFunc = Function::Create(AddFuncType, Function::ExternalLinkage,
                                       "add", TheModule);
  auto *AddFuncArgsIter = AddFunc->arg_begin();
  AddFuncArgsIter->setName("a");
  (AddFuncArgsIter+1)->setName("b");

  BasicBlock *AddFuncBb = BasicBlock::Create(Context, "entry", AddFunc);
  Builder.SetInsertPoint(AddFuncBb);
  Value *AddResult = Builder.CreateAdd(AddFuncArgsIter, AddFuncArgsIter + 1);
  Builder.CreateRet(AddResult);

  // define function type for 'main'
  FunctionType *MainFunctType = FunctionType::get(Type::getInt32Ty(Context), false);

  // define main function
  Function *MainFunc = Function::Create(MainFunctType, Function::ExternalLinkage,
                                        "main", TheModule);
  BasicBlock *MainFuncBB = BasicBlock::Create(Context, "entry", MainFunc);
  Builder.SetInsertPoint(MainFuncBB);

  // create variables 'a' and 'b'
  Value *A = Builder.CreateAlloca(Type::getInt32Ty(Context), nullptr, "a");
  Value *B = Builder.CreateAlloca(Type::getInt32Ty(Context), nullptr, "b");
  Builder.CreateStore(ConstantInt::get(Type::getInt32Ty(Context), 5), A);
  Builder.CreateStore(ConstantInt::get(Type::getInt32Ty(Context), 7), B);

  // create variables 'result'
  Value *Result = Builder.CreateAlloca(Type::getInt32Ty(Context), nullptr, "result");

  // create conditional
  Value *AVal = Builder.CreateLoad(A, "a_val");
  Value *BVal = Builder.CreateLoad(B, "b_val");
  Value *CmpResult = Builder.CreateICmpSGT(AVal, BVal, "if_cond");

  BasicBlock *ThenBB = BasicBlock::Create(Context, "then", MainFunc);
  BasicBlock *ElseBB = BasicBlock::Create(Context, "else", MainFunc);
  BasicBlock *MergeBB = BasicBlock::Create(Context, "merge", MainFunc);
  Builder.CreateCondBr(CmpResult, ThenBB, ElseBB);

  // then block
  Builder.SetInsertPoint(ThenBB);
  std::vector<Value*> AddArgs1;
  AddArgs1.push_back(AVal);
  AddArgs1.push_back(BVal);
  Value *ThenVal = Builder.CreateCall(AddFunc, AddArgs1);
  Builder.CreateStore(ThenVal, Result);
  Builder.CreateBr(MergeBB);

  // else block
  Builder.SetInsertPoint(ElseBB);
  std::vector<Value*> AddArgs2;
  AddArgs2.push_back(BVal);
  AddArgs2.push_back(AVal);
  Value *ElseVal = Builder.CreateCall(AddFunc, AddArgs2);
  Builder.CreateStore(ElseVal, Result);
  Builder.CreateBr(MergeBB);

  // merge block
  Builder.SetInsertPoint(MergeBB);
  Value *ResVal = Builder.CreateLoad(Result, "result_val");
  Builder.CreateRet(ResVal);

  TheModule->print(errs(), nullptr);

  std::error_code EC;
  llvm::raw_fd_ostream OutputStream("output.s", EC);
  if (EC) {
    llvm::errs() << "Could not open output file: " << EC.message();
  }

  TheModule->setTargetTriple("riscv64-unknown-linux-gnu");
  auto TargetTriple = llvm::Triple(TheModule->getTargetTriple());
  std::string Error;
  auto Target = llvm::TargetRegistry::lookupTarget(TargetTriple.str(), Error);
  auto CPU = "generic-rv64";
  auto Features = "";

  llvm::TargetOptions opt;
  auto RM = llvm::Optional<llvm::Reloc::Model>();
  auto TheTargetMachine =
      Target->createTargetMachine(TargetTriple.str(), CPU, Features, opt, RM);
  TheModule->setDataLayout(TheTargetMachine->createDataLayout());
  llvm::legacy::PassManager PM;
  TheTargetMachine->addPassesToEmitFile(PM, OutputStream, nullptr, llvm::CGFT_AssemblyFile);

  PM.run(*TheModule);

  OutputStream.flush();

  delete TheModule;
}

} // namespace