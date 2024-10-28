//{}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct class_Eigen__array {
  int f0[1];
};
struct Eigen__Tuple {
  int f0;
  float f1;
};
struct Eigen__DSizes {
  struct class_Eigen__array f0;
};
struct Eigen__TensorEvaluator_0 {
  global int* f0;
  struct Eigen__DSizes f1;
  global struct Eigen__GpuDevice* f2;
  global struct class_Eigen__TensorMap* f3;
};
struct Eigen__GpuDevice {
  global struct class_Eigen__StreamInterface* f0;
  int f1;
  char f2[4];
};
struct class_Eigen__TensorMap {
  global int* f0;
  struct Eigen__DSizes f1;
  char f2[4];
};
struct class_Eigen__StreamInterface {};
struct Eigen__TensorEvaluator_4 {
  global float* f0;
  struct Eigen__DSizes f1;
  global struct Eigen__GpuDevice* f2;
  global struct class_Eigen__TensorMap_5* f3;
};
struct class_Eigen__TensorMap_5 {
  global float* f0;
  struct Eigen__DSizes f1;
  char f2[4];
};
struct class_Eigen__array_nopointers {
  int f0[1];
};
struct Eigen__DSizes_nopointers {
  struct class_Eigen__array_nopointers f0;
};
struct Eigen__TensorEvaluator_0_nopointers {
  struct Eigen__DSizes_nopointers f0;
};
struct Eigen__TensorEvaluator_3 {
  struct Eigen__TensorEvaluator_4 f0;
};
struct class_Eigen__array_10 {
  char f0[1];
};
struct Eigen__Sizes {
  char f0;
};
struct Eigen__TensorEvaluator_4_nopointers {
  struct Eigen__DSizes_nopointers f0;
};
struct Eigen__TensorEvaluator_3_nopointers {
  struct Eigen__TensorEvaluator_4_nopointers f0;
};
struct class_Eigen__array_11 {
  int f0;
};
struct Eigen__internal__ArgMaxTupleReducer {
  char f0;
};
struct class_Eigen__array_10_nopointers {
  char f0[1];
};
struct Eigen__TensorEvaluator_9 {
  struct class_Eigen__array_10 f0;
  struct Eigen__Sizes f1;
  struct class_Eigen__array_11 f2;
  struct class_Eigen__array f3;
  struct class_Eigen__array f4;
  struct class_Eigen__array f5;
  struct Eigen__TensorEvaluator_3 f6;
  struct Eigen__internal__ArgMaxTupleReducer f7;
  global struct Eigen__Tuple* f8;
  global struct Eigen__GpuDevice* f9;
};
struct Eigen__Sizes_nopointers {
  char f0;
};
struct Eigen__TensorEvaluator_2 {
  struct Eigen__TensorEvaluator_3 f0;
  struct Eigen__TensorEvaluator_9 f1;
  int f2;
  struct class_Eigen__array f3;
  int f4;
  int f5;
};
struct class_Eigen__array_11_nopointers {
  int f0;
};
struct Eigen__TensorEvaluator {
  struct Eigen__TensorEvaluator_0 f0;
  struct Eigen__TensorEvaluator_2 f1;
};
struct Eigen__internal__ArgMaxTupleReducer_nopointers {
  char f0;
};
struct Eigen__TensorEvaluator_9_nopointers {
  struct class_Eigen__array_10_nopointers f0;
  struct Eigen__Sizes_nopointers f1;
  struct class_Eigen__array_11_nopointers f2;
  struct class_Eigen__array_nopointers f3;
  struct class_Eigen__array_nopointers f4;
  struct class_Eigen__array_nopointers f5;
  struct Eigen__TensorEvaluator_3_nopointers f6;
  struct Eigen__internal__ArgMaxTupleReducer_nopointers f7;
};
struct Eigen__TensorEvaluator_2_nopointers {
  struct Eigen__TensorEvaluator_3_nopointers f0;
  struct Eigen__TensorEvaluator_9_nopointers f1;
  int f2;
  struct class_Eigen__array_nopointers f3;
  int f4;
  int f5;
};
struct Eigen__TensorEvaluator_nopointers {
  struct Eigen__TensorEvaluator_0_nopointers f0;
  struct Eigen__TensorEvaluator_2_nopointers f1;
};

kernel void _ZN5Eigen8internal15EigenMetaKernelINS_15TensorEvaluatorIKNS_14TensorAssignOpINS_9TensorMapINS_6TensorIiLi1ELi1EiEELi16ENS_11MakePointerEEEKNS_20TensorTupleReducerOpINS0_18ArgMaxTupleReducerINS_5TupleIifEEEEKNS_5arrayIiLm1EEEKNS4_INS5_IfLi1ELi1EiEELi16ES7_EEEEEENS_9GpuDeviceEEEiEEvT_T0_(global struct Eigen__TensorEvaluator_nopointers* eval_nopointers, global int* eval_ptr0, unsigned int eval_ptr0_offset, global float* eval_ptr1, unsigned int eval_ptr1_offset, global float* eval_ptr2, unsigned int eval_ptr2_offset, int size, local int* scratch);