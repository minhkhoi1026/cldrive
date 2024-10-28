//{"_constant_region":2,"_frame":4,"_frame_base":1,"_heap_base":0,"_local_region":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void add(global uchar* _heap_base, ulong _frame_base, constant uchar* _constant_region, local uchar* _local_region) {
  ulong ul_8, ul_10, ul_1, ul_0, ul_2, ul_12;
  long l_5, l_7, l_6;
  int i_11, i_9, i_15, i_14, i_13, i_3, i_4;

  global ulong* _frame = (global ulong*)&_heap_base[hook(0, _frame_base)];

  ul_0 = (ulong)_frame[hook(4, 3)];
  ul_1 = (ulong)_frame[hook(4, 4)];
  ul_2 = (ulong)_frame[hook(4, 5)];
  i_3 = get_global_id(0);

  i_4 = i_3;
  for (; i_4 < 8;) {
    l_5 = (long)i_4;
    l_6 = l_5 << 2;
    l_7 = l_6 + 24L;
    ul_8 = ul_0 + l_7;
    i_9 = *((global int*)ul_8);
    ul_10 = ul_1 + l_7;
    i_11 = *((global int*)ul_10);
    ul_12 = ul_2 + l_7;
    i_13 = i_9 + i_11;
    *((global int*)ul_12) = i_13;
    i_14 = get_global_size(0);
    i_15 = i_14 + i_4;
    i_4 = i_15;
  }

  return;
}