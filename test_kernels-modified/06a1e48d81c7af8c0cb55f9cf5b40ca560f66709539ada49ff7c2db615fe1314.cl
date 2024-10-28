//{"(&(eval[0].f0.f0))":30,"(&(eval[0].f1.f1.f3.f0[0]))":27,"(&(eval[0].f1.f1.f6.f0.f0))":28,"(&(eval[0].f1.f1.f8))":26,"(&(eval[0].f1.f2))":29,"(&(v36[v52].f0))":31,"(&(v42[v107]))":38,"(&(v42[v66]))":33,"(&(v42[v82]))":35,"(&(v42[v90]))":36,"(&(v42[v99]))":37,"((__private long *)v34)":39,"eval":10,"eval[0].f0.f1.f0.f0":9,"eval[0].f1.f0.f0.f1.f0.f0":12,"eval[0].f1.f1.f0.f0":14,"eval[0].f1.f1.f3.f0":16,"eval[0].f1.f1.f4.f0":18,"eval[0].f1.f1.f5.f0":20,"eval[0].f1.f1.f6.f0.f1.f0.f0":22,"eval[0].f1.f3.f0":24,"eval_nopointers":0,"eval_nopointers[0].f0.f0.f0.f0":11,"eval_nopointers[0].f1.f0.f0.f0.f0.f0":13,"eval_nopointers[0].f1.f1.f0.f0":15,"eval_nopointers[0].f1.f1.f3.f0":17,"eval_nopointers[0].f1.f1.f4.f0":19,"eval_nopointers[0].f1.f1.f5.f0":21,"eval_nopointers[0].f1.f1.f6.f0.f0.f0.f0":23,"eval_nopointers[0].f1.f3.f0":25,"eval_ptr0":1,"eval_ptr0_offset":2,"eval_ptr1":3,"eval_ptr1_offset":4,"eval_ptr2":5,"eval_ptr2_offset":6,"scratch":8,"size":7,"v126":41,"v36":32,"v42":34,"v45":40}
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
  float v63;
  float v69;
  float v72;
  float v80;
  float v85;
  float v88;
  float v93;
  float v96;
  global float* v42;
  global int* v126;
  global int* v45;
  global struct Eigen__Tuple* v36;
  int v107;
  int v112;
  int v114;
  int v117;
  int v124;
  int v128;
  int v20;
  int v21;
  int v23;
  int v24;
  int v25;
  int v39;
  int v43;
  int v48;
  int v52;
  int v55;
  int v56;
  int v57;
  int v58;
  int v61;
  int v62;
  int v64;
  int v65;
  int v66;
  int v71;
  int v73;
  int v75;
  int v77;
  int v78;
  int v79;
  int v81;
  int v82;
  int v90;
  int v99;
  int* v34;
  long v118;

v1:;
  ;
  v20 = get_group_id(0);
  ;
  v21 = get_local_size(0);
  ;
  ;
  v23 = get_local_id(0);
  ;
  v24 = (v21 * v20) + v23;
  ;
  v25 = get_num_groups(0);
  ;
  ;

  if (v24 < size) {
    goto v2;
  } else {
    goto v19;
  }
v2:;
  ;
  ;
  ;
  ;
  ;
  ;
  v34 = (&(eval[hook(10, 0)].f1.f4));
  ;
  ;
  v36 = (&(eval[hook(10, 0)].f1.f1.f8))[hook(26, 0)];
  ;
  ;
  v39 = (&(eval[hook(10, 0)].f1.f1.f3.f0[hook(16, 0)]))[hook(27, 0)];
  ;
  ;
  v42 = (&(eval[hook(10, 0)].f1.f1.f6.f0.f0))[hook(28, 0)];
  ;
  v43 = (&(eval[hook(10, 0)].f1.f2))[hook(29, 0)];
  ;
  ;
  v45 = (&(eval[hook(10, 0)].f0.f0))[hook(30, 0)];
  ;
  ;
  v48 = v39 & 3;
  ;
  ;

  v52 = v24;
  goto v3;
v3:;

  if (v36 == 0) {
    goto v5;
  } else {
    goto v4;
  }
v4:;
  ;
  ;
  ;
  v55 = (&(v36[hook(32, v52)].f0))[hook(31, 0)];

  v56 = v55;
  goto v15;
v5:;
  ;
  v57 = v39 * v52;

  if (v39 > 0) {
    goto v6;
  } else {
    v56 = 0;
    goto v15;
  }
v6:;

  if (v48 == 0) {
    v58 = 0;

    v60 = -3.40282e+38f;

    v61 = 0;
    goto v10;
  } else {
    goto v7;
  }
v7:;

  v62 = 0;

  v63 = -3.40282e+38f;

  v64 = 0;

  v65 = v48;
  goto v8;
v8:;
  ;
  v66 = v62 + v57;
  ;
  ;
  ;
  v69 = (&(v42[hook(34, v66)]))[hook(33, 0)];
  ;
  v70 = v69 <= v63;
  ;
  v71 = v70 ? v64 : v66;
  ;
  v72 = v70 ? v63 : v69;
  ;
  v73 = v62 + 1;
  ;
  v75 = v65 + -1;
  ;

  if (v75 == 0) {
    goto v9;
  } else {
    v62 = v73;

    v63 = v72;

    v64 = v71;

    v65 = v75;
    goto v8;
  }
v9:;

  v77 = v71;

  v58 = v73;

  v60 = v72;

  v61 = v71;
  goto v10;
v10:;

  if (v39 + -1 < 3) {
    v78 = v77;
    goto v14;
  } else {
    goto v11;
  }
v11:;

  v79 = v58;

  v80 = v60;

  v81 = v61;
  goto v12;
v12:;
  ;
  v82 = v79 + v57;
  ;
  ;
  ;
  v85 = (&(v42[hook(34, v82)]))[hook(35, 0)];
  ;
  v86 = v85 <= v80;
  ;
  ;
  v88 = v86 ? v80 : v85;
  ;
  ;
  v90 = (v79 + 1) + v57;
  ;
  ;
  ;
  v93 = (&(v42[hook(34, v90)]))[hook(36, 0)];
  ;
  v94 = v93 <= v88;
  ;
  ;
  v96 = v94 ? v88 : v93;
  ;
  ;
  v99 = (v79 + 2) + v57;
  ;
  ;
  ;
  v102 = (&(v42[hook(34, v99)]))[hook(37, 0)];
  ;
  v103 = v102 <= v96;
  ;
  ;
  v105 = v103 ? v96 : v102;
  ;
  ;
  v107 = (v79 + 3) + v57;
  ;
  ;
  ;
  v110 = (&(v42[hook(34, v107)]))[hook(38, 0)];
  ;
  v111 = v110 <= v105;
  ;
  v112 = v111 ? (v103 ? (v94 ? (v86 ? v81 : v82) : v90) : v99) : v107;
  ;
  v113 = v111 ? v105 : v110;
  ;
  v114 = v79 + 4;
  ;

  if (v114 == v39) {
    goto v13;
  } else {
    v79 = v114;

    v80 = v113;

    v81 = v112;
    goto v12;
  }
v13:;

  v78 = v112;
  goto v14;
v14:;

  v56 = v78;
  goto v15;
v15:;

  if (v43 < 0) {
    v117 = v56;
    goto v17;
  } else {
    goto v16;
  }
v16:;
  ;
  v118 = ((long*)v34)[hook(39, 0)];
  ;
  ;
  ;
  ;
  ;
  v124 = (v56 % (int)v118) / (int)(v118 >> 32);

  v117 = v124;
  goto v17;
v17:;
  ;
  ;
  v126 = (&(v45[hook(40, v52)]));
  ;
  v126[hook(41, 0)] = v117;
  ;
  v128 = v52 + (v25 * v21);
  ;

  if (v128 < size) {
    v52 = v128;
    goto v3;
  } else {
    goto v18;
  }
v18:;
  goto v19;
v19:;
  return;
}