//{"(&(input_data[v107]))":31,"(&(input_data[v82]))":28,"(&(input_data[v90]))":29,"(&(input_data[v99]))":30,"((__private long *)v34)":33,"eval":10,"eval[0].f0.f1.f0.f0":9,"eval[0].f1.f0.f0.f1.f0.f0":12,"eval[0].f1.f1.f0.f0":14,"eval[0].f1.f1.f3.f0":16,"eval[0].f1.f1.f4.f0":18,"eval[0].f1.f1.f5.f0":20,"eval[0].f1.f1.f6.f0.f1.f0.f0":22,"eval[0].f1.f3.f0":24,"eval_nopointers":0,"eval_nopointers[0].f0.f0.f0.f0":11,"eval_nopointers[0].f1.f0.f0.f0.f0.f0":13,"eval_nopointers[0].f1.f1.f0.f0":15,"eval_nopointers[0].f1.f1.f3.f0":17,"eval_nopointers[0].f1.f1.f4.f0":19,"eval_nopointers[0].f1.f1.f5.f0":21,"eval_nopointers[0].f1.f1.f6.f0.f0.f0.f0":23,"eval_nopointers[0].f1.f3.f0":25,"eval_ptr0":1,"eval_ptr0_offset":2,"eval_ptr1":3,"eval_ptr1_offset":4,"eval_ptr2":5,"eval_ptr2_offset":6,"input_data":27,"output_data":32,"scratch":8,"size":7,"v36":26}
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

kernel void _ZN5Eigen8internal15EigenMetaKernelINS_15TensorEvaluatorIKNS_14TensorAssignOpINS_9TensorMapINS_6TensorIiLi1ELi1EiEELi16ENS_11MakePointerEEEKNS_20TensorTupleReducerOpINS0_18ArgMaxTupleReducerINS_5TupleIifEEEEKNS_5arrayIiLm1EEEKNS4_INS5_IfLi1ELi1EiEELi16ES7_EEEEEENS_9GpuDeviceEEEiEEvT_T0_(global struct Eigen__TensorEvaluator_nopointers* eval_nopointers, global int* eval_ptr0, unsigned int eval_ptr0_offset, global float* eval_ptr1, unsigned int eval_ptr1_offset, global float* eval_ptr2, unsigned int eval_ptr2_offset, int size, local int* scratch) {
  eval_ptr2 += eval_ptr2_offset;
  eval_ptr1 += eval_ptr1_offset;
  eval_ptr0 += eval_ptr0_offset;
  struct Eigen__TensorEvaluator eval[1];
  eval[hook(10, 0)].f0.f1.f0.f0[hook(9, 0)] = eval_nopointers[hook(0, 0)].f0.f0.f0.f0[hook(11, 0)];
  eval[hook(10, 0)].f1.f0.f0.f1.f0.f0[hook(12, 0)] = eval_nopointers[hook(0, 0)].f1.f0.f0.f0.f0.f0[hook(13, 0)];
  eval[hook(10, 0)].f1.f1.f0.f0[hook(14, 0)] = eval_nopointers[hook(0, 0)].f1.f1.f0.f0[hook(15, 0)];
  eval[hook(10, 0)].f1.f1.f1.f0 = eval_nopointers[hook(0, 0)].f1.f1.f1.f0;
  eval[hook(10, 0)].f1.f1.f2.f0 = eval_nopointers[hook(0, 0)].f1.f1.f2.f0;
  eval[hook(10, 0)].f1.f1.f3.f0[hook(16, 0)] = eval_nopointers[hook(0, 0)].f1.f1.f3.f0[hook(17, 0)];

  eval[hook(10, 0)].f1.f1.f4.f0[hook(18, 0)] = eval_nopointers[hook(0, 0)].f1.f1.f4.f0[hook(19, 0)];
  eval[hook(10, 0)].f1.f1.f5.f0[hook(20, 0)] = eval_nopointers[hook(0, 0)].f1.f1.f5.f0[hook(21, 0)];
  eval[hook(10, 0)].f1.f1.f6.f0.f1.f0.f0[hook(22, 0)] = eval_nopointers[hook(0, 0)].f1.f1.f6.f0.f0.f0.f0[hook(23, 0)];
  eval[hook(10, 0)].f1.f1.f7.f0 = eval_nopointers[hook(0, 0)].f1.f1.f7.f0;
  eval[hook(10, 0)].f1.f2 = eval_nopointers[hook(0, 0)].f1.f2;
  eval[hook(10, 0)].f1.f3.f0[hook(24, 0)] = eval_nopointers[hook(0, 0)].f1.f3.f0[hook(25, 0)];
  eval[hook(10, 0)].f1.f4 = eval_nopointers[hook(0, 0)].f1.f4;
  eval[hook(10, 0)].f1.f5 = eval_nopointers[hook(0, 0)].f1.f5;
  eval[hook(10, 0)].f0.f0 = eval_ptr0;
  eval[hook(10, 0)].f1.f0.f0.f0 = eval_ptr1;
  eval[hook(10, 0)].f1.f1.f6.f0.f0 = eval_ptr2;

  bool v103;
  bool v111;
  bool v70;
  bool v86;
  bool v94;
  float v102;
  float v105;
  float v110;
  float v113;
  float v60;
  float max_so_far;
  float v69;
  float new_max_so_far;
  float v80;
  float v85;
  float v88;
  float v93;
  float v96;
  global float* input_data;
  global int* v126;
  global int* output_data;
  global struct Eigen__Tuple* v36;
  int v107;
  int v112;
  int v114;
  int v117;
  int v124;
  int v128;
  int group_id;
  int local_size;
  int local_id;
  int global_id;
  int num_groups;
  int inner_size;
  int v43;
  int inner_size_mod4;
  int global_pos;
  int v55;
  int v56;
  int segment_offset;
  int v58;
  int v61;
  int idx;
  int best_pos_so_far;
  int count;
  int candidate_pos;
  int new_best_pos_so_far;
  int new_idx;
  int new_count;
  int v77;
  int v78;
  int v79;
  int v81;
  int v82;
  int v90;
  int v99;
  int* v34;
  long v118;

  ;
  group_id = get_group_id(0);
  ;
  local_size = get_local_size(0);
  ;
  ;
  local_id = get_local_id(0);
  ;
  global_id = (local_size * group_id) + local_id;
  ;
  num_groups = get_num_groups(0);
  ;
  ;

  if (global_id >= size) {
    goto exit;
  }

  ;
  ;
  ;
  ;
  ;
  ;
  v34 = &eval[hook(10, 0)].f1.f4;
  ;
  ;
  v36 = eval[hook(10, 0)].f1.f1.f8;
  ;
  ;
  inner_size = eval[hook(10, 0)].f1.f1.f3.f0[hook(16, 0)];
  ;
  ;
  input_data = eval_ptr2;
  ;
  v43 = eval[hook(10, 0)].f1.f2;
  ;
  ;
  output_data = eval_ptr0;
  ;
  ;
  inner_size_mod4 = inner_size & 3;
  ;
  ;

  global_pos = global_id;

block3:;

  if (v36 == 0) {
    goto block5;
  }

  ;
  ;
  ;

  v56 = v36[hook(26, global_pos)].f0;

  goto block15;
block5:;
  ;
  segment_offset = inner_size * global_pos;

  if (inner_size <= 0) {
    v56 = 0;
    goto block15;
  }

  if (inner_size_mod4 == 0) {
    v58 = 0;

    v60 = -(__builtin_inff());

    v61 = 0;
    goto block10;
  }

  idx = 0;

  max_so_far = -(__builtin_inff());

  best_pos_so_far = 0;

  count = inner_size_mod4;

block8:;
  ;
  candidate_pos = idx + segment_offset;
  ;
  ;
  ;

  ;

  ;
  new_best_pos_so_far = input_data[hook(27, candidate_pos)] <= max_so_far ? best_pos_so_far : candidate_pos;
  ;
  new_max_so_far = input_data[hook(27, candidate_pos)] <= max_so_far ? max_so_far : input_data[hook(27, candidate_pos)];
  ;
  new_idx = idx + 1;
  ;
  new_count = count - 1;
  ;

  if (new_count != 0) {
    idx = new_idx;

    max_so_far = new_max_so_far;

    best_pos_so_far = new_best_pos_so_far;

    count = new_count;
    goto block8;
  }

  v77 = new_best_pos_so_far;

  v58 = new_idx;

  v60 = new_max_so_far;

  v61 = new_best_pos_so_far;

block10:;

  if (inner_size < 4) {
    v78 = v77;
    goto block14;
  }

  v79 = v58;

  v80 = v60;

  v81 = v61;

block12:;
  ;
  v82 = v79 + segment_offset;
  ;
  ;
  ;
  v85 = (&(input_data[hook(27, v82)]))[hook(28, 0)];
  ;
  v86 = v85 <= v80;
  ;
  ;
  v88 = v86 ? v80 : v85;
  ;
  ;
  v90 = (v79 + 1) + segment_offset;
  ;
  ;
  ;
  v93 = (&(input_data[hook(27, v90)]))[hook(29, 0)];
  ;
  v94 = v93 <= v88;
  ;
  ;
  v96 = v94 ? v88 : v93;
  ;
  ;
  v99 = (v79 + 2) + segment_offset;
  ;
  ;
  ;
  v102 = (&(input_data[hook(27, v99)]))[hook(30, 0)];
  ;
  v103 = v102 <= v96;
  ;
  ;
  v105 = v103 ? v96 : v102;
  ;
  ;
  v107 = (v79 + 3) + segment_offset;
  ;
  ;
  ;
  v110 = (&(input_data[hook(27, v107)]))[hook(31, 0)];
  ;
  v111 = v110 <= v105;
  ;
  v112 = v111 ? (v103 ? (v94 ? (v86 ? v81 : v82) : v90) : v99) : v107;
  ;
  v113 = v111 ? v105 : v110;
  ;
  v114 = v79 + 4;
  ;

  if (v114 != inner_size) {
    v79 = v114;

    v80 = v113;

    v81 = v112;
    goto block12;
  }

  v78 = v112;

block14:;

  v56 = v78;

block15:;

  if (v43 < 0) {
    output_data[hook(32, 0)] = 12344;
    return;
    v117 = v56;
    goto block17;
  }

  ;
  v118 = ((long*)v34)[hook(33, 0)];
  ;
  ;
  ;
  ;
  ;
  v124 = (v56 % (int)v118) / (int)(v118 >> 32);

  v117 = v124;

block17:;
  ;
  ;

  ;
  output_data[hook(32, global_pos)] = v117;
  ;
  global_pos += (num_groups * local_size);
  ;

  if (global_pos < size) {
    goto block3;
  }
v18:;
exit:;
  return;
}