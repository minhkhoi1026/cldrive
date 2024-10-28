//{"g_data":0,"g_data_v":2,"high_stage":4,"l_data":1,"l_data_v":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void bsort_stage_0_manning_kv(global uint4* g_data, local uint4* l_data, global uint4* g_data_v, local uint4* l_data_v, unsigned int high_stage) {
  int dir;
  unsigned int id, global_start, stride;
  uint4 input1, input2, temp, input1_v, input2_v, temp_v;
  int4 comp;

  uint4 mask1 = (uint4)(1, 0, 3, 2);
  uint4 mask2 = (uint4)(2, 3, 0, 1);
  uint4 mask3 = (uint4)(3, 2, 1, 0);

  int4 add1 = (int4)(1, 1, 3, 3);
  int4 add2 = (int4)(2, 3, 2, 3);
  int4 add3 = (int4)(4, 5, 6, 7);

  id = get_local_id(0);
  dir = (get_group_id(0) / high_stage & 1) * -1;
  global_start = get_group_id(0) * get_local_size(0) * 2 + id;

  input1 = g_data[hook(0, global_start)];
  input2 = g_data[hook(0, global_start + get_local_size(0))];
  input1_v = g_data_v[hook(2, global_start)];
  input2_v = g_data_v[hook(2, global_start + get_local_size(0))];
  comp = (input1 < input2 ^ dir) * 4 + add3;
  l_data[hook(1, id)] = shuffle2(input1, input2, __builtin_astype((comp), uint4));
  l_data[hook(1, id + get_local_size(0))] = shuffle2(input2, input1, __builtin_astype((comp), uint4));
  l_data_v[hook(3, id)] = shuffle2(input1_v, input2_v, __builtin_astype((comp), uint4));
  l_data_v[hook(3, id + get_local_size(0))] = shuffle2(input2_v, input1_v, __builtin_astype((comp), uint4));

  for (stride = get_local_size(0) / 2; stride > 1; stride >>= 1) {
    barrier(0x01);
    id = get_local_id(0) + (get_local_id(0) / stride) * stride;
    comp = (l_data[hook(1, id)] < l_data[hook(1, id + stride)] ^ dir) * 4 + add3;
    temp = l_data[hook(1, id)];
    l_data[hook(1, id)] = shuffle2(l_data[hook(1, id)], l_data[hook(1, id + stride)], __builtin_astype((comp), uint4));
    l_data[hook(1, id + stride)] = shuffle2(l_data[hook(1, id + stride)], temp, __builtin_astype((comp), uint4));
    temp_v = l_data_v[hook(3, id)];
    l_data_v[hook(3, id)] = shuffle2(l_data_v[hook(3, id)], l_data_v[hook(3, id + stride)], __builtin_astype((comp), uint4));
    l_data_v[hook(3, id + stride)] = shuffle2(l_data_v[hook(3, id + stride)], temp_v, __builtin_astype((comp), uint4));
  }
  barrier(0x01);

  id = get_local_id(0) * 2;
  input1 = l_data[hook(1, id)];
  input2 = l_data[hook(1, id + 1)];
  input1_v = l_data_v[hook(3, id)];
  input2_v = l_data_v[hook(3, id + 1)];
  temp = input1;
  comp = (input1 < input2 ^ dir) * 4 + add3;
  input1 = shuffle2(input1, input2, __builtin_astype((comp), uint4));
  input2 = shuffle2(input2, temp, __builtin_astype((comp), uint4));
  temp_v = input1_v;
  input1_v = shuffle2(input1_v, input2_v, __builtin_astype((comp), uint4));
  input2_v = shuffle2(input2_v, temp_v, __builtin_astype((comp), uint4));
  comp = input1 < shuffle(input1, mask2) ^ dir;
  input1 = shuffle(input1, __builtin_astype((comp * 2 + add2), uint4));
  input1_v = shuffle(input1_v, __builtin_astype((comp * 2 + add2), uint4));
  comp = input1 < shuffle(input1, mask1) ^ dir;
  input1 = shuffle(input1, __builtin_astype((comp + add1), uint4));
  input1_v = shuffle(input1_v, __builtin_astype((comp + add1), uint4));
  ;
  comp = input2 < shuffle(input2, mask2) ^ dir;
  input2 = shuffle(input2, __builtin_astype((comp * 2 + add2), uint4));
  input2_v = shuffle(input2_v, __builtin_astype((comp * 2 + add2), uint4));
  comp = input2 < shuffle(input2, mask1) ^ dir;
  input2 = shuffle(input2, __builtin_astype((comp + add1), uint4));
  input2_v = shuffle(input2_v, __builtin_astype((comp + add1), uint4));
  ;

  g_data[hook(0, global_start + get_local_id(0))] = input1;
  g_data[hook(0, global_start + get_local_id(0) + 1)] = input2;
  g_data_v[hook(2, global_start + get_local_id(0))] = input1_v;
  g_data_v[hook(2, global_start + get_local_id(0) + 1)] = input2_v;
}