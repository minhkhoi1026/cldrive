//{"Kernel2Arg0":0,"Kernel2Arg1":1}
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
struct FileStruct0 {
  global int* StructMem0;

  constant int* StructMem1;

  local int* StructMem2;

 private
  int* StructMem3;

  int* StructMem4;
};

struct FileStruct1 {
  union {
    global int* UnionMem0;

    constant int* UnionMem1;

    local int* UnionMem2;

   private
    int* UnionMem3;

    int* UnionMem4;
  };
  long StructMem0;
};

kernel void kernel2(global struct FileStruct0* Kernel2Arg0, global struct FileStruct1* Kernel2Arg1) {
}