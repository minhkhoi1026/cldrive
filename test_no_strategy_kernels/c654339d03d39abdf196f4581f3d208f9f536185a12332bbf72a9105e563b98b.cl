//{"_atomics":4,"_constant_region":2,"_frame":5,"_frame_base":1,"_heap_base":0,"_local_region":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void rMax(global uchar* _heap_base, ulong _frame_base, constant uchar* _constant_region, local uchar* _local_region, global int* _atomics) {
  float f_2, f_24, f_25, f_26, f_20, f_21, f_22, f_23, f_16, f_18, f_19, f_12, f_14, f_8, f_10, f_4, f_6;
  ulong ul_15, ul_1, ul_17, ul_0, ul_11, ul_13, ul_7, ul_9, ul_3, ul_5;

  global ulong* _frame = (global ulong*)&_heap_base[hook(0, _frame_base)];

  ul_0 = (ulong)_frame[hook(5, 3)];
  ul_1 = ul_0 + 56L;
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
  f_19 = fmax(f_4, f_6);
  f_20 = fmax(f_19, f_8);
  f_21 = fmax(f_20, f_10);
  f_22 = fmax(f_21, f_12);
  f_23 = fmax(f_22, f_14);
  f_24 = fmax(f_23, f_16);
  f_25 = fmax(f_24, f_18);
  f_26 = fmax(f_25, f_2);
  *((global float*)ul_3) = f_26;
  f_4 = f_26;
  return;
}