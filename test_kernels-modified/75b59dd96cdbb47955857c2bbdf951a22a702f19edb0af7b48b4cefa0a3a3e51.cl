//{"_atomics":4,"_constant_region":2,"_frame":5,"_frame_base":1,"_heap_base":0,"_local_region":3,"ul_2":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void maxReduction(global uchar* _heap_base, ulong _frame_base, constant uchar* _constant_region, local uchar* _local_region, global int* _atomics) {
  bool z_27, z_19;
  float f_28, f_11, f_20, f_22, f_23;
  ulong ul_1, ul_0, ul_10, ul_34;
  int i_16, i_17, i_14, i_15, i_12, i_13, i_6, i_4, i_5, i_3, i_35, i_30, i_29, i_26, i_24, i_25, i_21, i_18;
  long l_8, l_7, l_9, l_32, l_31, l_33;

  global ulong* _frame = (global ulong*)&_heap_base[hook(0, _frame_base)];

  ul_0 = (ulong)_frame[hook(5, 3)];
  ul_1 = (ulong)_frame[hook(5, 4)];
  local float ul_2[1024];
  i_3 = get_global_id(0);

  i_4 = i_3;
  for (; i_4 < 8192;) {
    i_5 = get_local_id(0);
    i_6 = get_local_size(0);
    l_7 = (long)i_4;
    l_8 = l_7 << 2;
    l_9 = l_8 + 24L;
    ul_10 = ul_0 + l_9;
    f_11 = *((global float*)ul_10);
    ul_2[hook(6, i_5)] = f_11;
    i_12 = i_6 >> 31;
    i_13 = i_12 + i_6;
    i_14 = i_13 >> 1;

    i_15 = i_14;
    for (; i_15 >= 1;) {
      barrier(0x01);
      i_16 = i_15 >> 31;
      i_17 = i_16 + i_15;
      i_18 = i_17 >> 1;
      z_19 = i_5 < i_15;
      if (z_19) {
        f_20 = ul_2[hook(6, i_5)];
        i_21 = i_15 + i_5;
        f_22 = ul_2[hook(6, i_21)];
        f_23 = fmax(f_20, f_22);
        ul_2[hook(6, i_5)] = f_23;
        f_20 = f_23;
      } else {
      }

      i_24 = i_18;
      i_15 = i_24;
    }

    barrier(0x02);
    i_25 = get_global_size(0);
    i_26 = i_25 + i_4;
    z_27 = i_5 == 0;
    if (z_27) {
      f_28 = ul_2[hook(6, 0)];
      i_29 = get_group_id(0);
      i_30 = i_29 + 1;
      l_31 = (long)i_30;
      l_32 = l_31 << 2;
      l_33 = l_32 + 24L;
      ul_34 = ul_1 + l_33;
      *((global float*)ul_34) = f_28;
    } else {
    }

    i_35 = i_26;
    i_4 = i_35;
  }

  return;
}