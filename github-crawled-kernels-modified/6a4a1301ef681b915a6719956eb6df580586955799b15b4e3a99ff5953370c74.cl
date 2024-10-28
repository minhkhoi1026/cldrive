//{"_atomics":4,"_constant_region":2,"_frame":5,"_frame_base":1,"_heap_base":0,"_local_region":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void rMax(global uchar* _heap_base, ulong _frame_base, constant uchar* _constant_region, local uchar* _local_region, global int* _atomics) {
  ulong ul_15, ul_17, ul_19, ul_21, ul_23, ul_25, ul_1, ul_0, ul_3, ul_5, ul_7, ul_9, ul_11, ul_13;
  float f_10, f_8, f_6, f_4, f_18, f_16, f_14, f_12, f_2, f_38, f_36, f_37, f_26, f_27, f_24, f_22, f_20, f_34, f_35, f_32, f_33, f_30, f_31, f_28, f_29;

  global ulong* _frame = (global ulong*)&_heap_base[hook(0, _frame_base)];

  ul_0 = (ulong)_frame[hook(5, 3)];
  ul_1 = ul_0 + 72L;
  f_2 = *((global float*)ul_1);
  ul_3 = ul_0 + 24L;
  f_4 = *((global float*)ul_3);
  ul_5 = ul_0 + 28L;
  f_6 = *((global float*)ul_5);
  ul_7 = ul_0 + 32L;
  f_8 = *((global float*)ul_7);
  ul_9 = ul_0 + 36L;
  f_10 = *((global float*)ul_9);
  ul_11 = ul_0 + 40L;
  f_12 = *((global float*)ul_11);
  ul_13 = ul_0 + 44L;
  f_14 = *((global float*)ul_13);
  ul_15 = ul_0 + 48L;
  f_16 = *((global float*)ul_15);
  ul_17 = ul_0 + 52L;
  f_18 = *((global float*)ul_17);
  ul_19 = ul_0 + 56L;
  f_20 = *((global float*)ul_19);
  ul_21 = ul_0 + 60L;
  f_22 = *((global float*)ul_21);
  ul_23 = ul_0 + 64L;
  f_24 = *((global float*)ul_23);
  ul_25 = ul_0 + 68L;
  f_26 = *((global float*)ul_25);
  f_27 = fmax(f_4, f_6);
  f_28 = fmax(f_27, f_8);
  f_29 = fmax(f_28, f_10);
  f_30 = fmax(f_29, f_12);
  f_31 = fmax(f_30, f_14);
  f_32 = fmax(f_31, f_16);
  f_33 = fmax(f_32, f_18);
  f_34 = fmax(f_33, f_20);
  f_35 = fmax(f_34, f_22);
  f_36 = fmax(f_35, f_24);
  f_37 = fmax(f_36, f_26);
  f_38 = fmax(f_37, f_2);
  *((global float*)ul_3) = f_38;
  f_4 = f_38;
  return;
}