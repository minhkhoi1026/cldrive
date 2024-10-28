//{"KernelArg0":0,"KernelArg1":1,"KernelArg2":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
global int* FileVar0;
constant int* FileVar1;
local int* FileVar2;
private
int* FileVar3;
int* FileVar4;
global int* global FileVar5;
constant int* global FileVar6;
local int* global FileVar7;
private
int* global FileVar8;
int* global FileVar9;
global int* constant FileVar10 = 0;
constant int* constant FileVar11 = 0;
local int* constant FileVar12 = 0;
private
int* constant FileVar13 = 0;
int* constant FileVar14 = 0;
kernel void kernel1(global int* KernelArg0, constant int* KernelArg1, local int* KernelArg2) {
 private
  int* Tmp0;
  int* Tmp1;

  global int* FuncVar0 = KernelArg0;

  constant int* FuncVar1 = KernelArg1;

  local int* FuncVar2 = KernelArg2;

 private
  int* FuncVar3 = Tmp0;

  int* FuncVar4 = Tmp1;

  global int* constant FuncVar5 = 0;

  constant int* constant FuncVar6 = 0;

  local int* constant FuncVar7 = 0;

 private
  int* constant FuncVar8 = 0;

  int* constant FuncVar9 = 0;

  global int* local FuncVar10;
  FuncVar10 = KernelArg0;

  constant int* local FuncVar11;
  FuncVar11 = KernelArg1;

  local int* local FuncVar12;
  FuncVar12 = KernelArg2;

 private
  int* local FuncVar13;
  FuncVar13 = Tmp0;

  int* local FuncVar14;
  FuncVar14 = Tmp1;

  global int* private FuncVar15 = KernelArg0;

  constant int* private FuncVar16 = KernelArg1;

  local int* private FuncVar17 = KernelArg2;

 private
  int* private FuncVar18 = Tmp0;

  int* private FuncVar19 = Tmp1;
}