//{"g_data":0,"high_stage":2,"l_data":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void bsort_stage_0_manning(global uint4* g_data, local uint4* l_data, unsigned int high_stage) {
  int dir;
  unsigned int id, global_start, stride;
  uint4 input1, input2, temp;
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
  comp = (input1 < input2 ^ dir) * 4 + add3;
  l_data[hook(1, id)] = shuffle2(input1, input2, __builtin_astype((comp), uint4));
  l_data[hook(1, id + get_local_size(0))] = shuffle2(input2, input1, __builtin_astype((comp), uint4));

  for (stride = get_local_size(0) / 2; stride > 1; stride >>= 1) {
    barrier(0x01);
    id = get_local_id(0) + (get_local_id(0) / stride) * stride;
    temp = l_data[hook(1, id)];
    comp = (l_data[hook(1, id)] < l_data[hook(1, id + stride)] ^ dir) * 4 + add3;
    l_data[hook(1, id)] = shuffle2(l_data[hook(1, id)], l_data[hook(1, id + stride)], __builtin_astype((comp), uint4));
    l_data[hook(1, id + stride)] = shuffle2(l_data[hook(1, id + stride)], temp, __builtin_astype((comp), uint4));
  }
  barrier(0x01);

  id = get_local_id(0) * 2;
  input1 = l_data[hook(1, id)];
  input2 = l_data[hook(1, id + 1)];
  temp = input1;
  comp = (input1 < input2 ^ dir) * 4 + add3;
  input1 = shuffle2(input1, input2, __builtin_astype((comp), uint4));
  input2 = shuffle2(input2, temp, __builtin_astype((comp), uint4));
  comp = input1 < shuffle(input1, mask2) ^ dir;
  input1 = shuffle(input1, __builtin_astype((comp * 2 + add2), uint4));
  comp = input1 < shuffle(input1, mask1) ^ dir;
  input1 = shuffle(input1, __builtin_astype((comp + add1), uint4));
  ;
  comp = input2 < shuffle(input2, mask2) ^ dir;
  input2 = shuffle(input2, __builtin_astype((comp * 2 + add2), uint4));
  comp = input2 < shuffle(input2, mask1) ^ dir;
  input2 = shuffle(input2, __builtin_astype((comp + add1), uint4));
  ;

  g_data[hook(0, global_start + get_local_id(0))] = input1;
  g_data[hook(0, global_start + get_local_id(0) + 1)] = input2;
}