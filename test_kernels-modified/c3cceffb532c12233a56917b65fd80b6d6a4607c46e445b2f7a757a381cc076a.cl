//{"_atomics":4,"_constant_region":2,"_frame":5,"_frame_base":1,"_heap_base":0,"_local_region":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void maxReduction(global uchar* _heap_base, ulong _frame_base, constant uchar* _constant_region, local uchar* _local_region, global int* _atomics) {
  long l_18, l_19, l_20, l_13, l_14, l_15;
  int i_10, i_8, i_24, i_9, i_12, i_2, i_3, i_6, i_7, i_4, i_5;
  ulong ul_1, ul_0, ul_16, ul_21;
  bool z_11;
  float f_22, f_23, f_17;

  global ulong* _frame = (global ulong*)&_heap_base[hook(0, _frame_base)];

  ul_0 = (ulong)_frame[hook(5, 3)];
  ul_1 = (ulong)_frame[hook(5, 4)];
  i_2 = get_global_size(0);
  i_3 = i_2 + 8191;
  i_4 = i_3 / i_2;
  i_5 = get_global_id(0);
  i_6 = i_4 * i_5;
  i_7 = i_6 + i_4;
  i_8 = min(i_7, 8192);

  i_9 = i_6;
  for (; i_9 < i_8;) {
    barrier(0x01);
    i_10 = i_9 + 1;
    z_11 = i_9 < 0;
    if (z_11) {
    } else {
      i_12 = i_5 + 1;
      l_13 = (long)i_12;
      l_14 = l_13 << 2;
      l_15 = l_14 + 24L;
      ul_16 = ul_1 + l_15;
      f_17 = *((global float*)ul_16);
      l_18 = (long)i_9;
      l_19 = l_18 << 2;
      l_20 = l_19 + 24L;
      ul_21 = ul_0 + l_20;
      f_22 = *((global float*)ul_21);
      f_23 = fmax(f_17, f_22);
      *((global float*)ul_16) = f_23;
      f_17 = f_23;
    }

    i_24 = i_10;
    i_9 = i_24;
  }

  return;
}