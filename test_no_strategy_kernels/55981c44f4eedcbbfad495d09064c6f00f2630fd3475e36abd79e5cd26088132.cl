//{"g_data":0,"g_data_v":2,"high_stage":5,"l_data":1,"l_data_v":3,"stage":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void bsort_stage_n_manning_kv(global uint4* g_data, local uint4* l_data, global uint4* g_data_v, local uint4* l_data_v, unsigned int stage, unsigned int high_stage) {
  int dir;
  uint4 input1, input2, input1_v, input2_v;
  int4 comp, add;
  unsigned int global_start, global_offset;

  add = (int4)(4, 5, 6, 7);

  dir = (get_group_id(0) / high_stage & 1) * -1;
  global_start = (get_group_id(0) + (get_group_id(0) / stage) * stage) * get_local_size(0) + get_local_id(0);
  global_offset = stage * get_local_size(0);

  input1 = g_data[hook(0, global_start)];
  input2 = g_data[hook(0, global_start + global_offset)];
  input1_v = g_data_v[hook(2, global_start)];
  input2_v = g_data_v[hook(2, global_start + global_offset)];
  comp = (input1 < input2 ^ dir) * 4 + add;
  g_data[hook(0, global_start)] = shuffle2(input1, input2, __builtin_astype((comp), uint4));
  g_data_v[hook(2, global_start)] = shuffle2(input1_v, input2_v, __builtin_astype((comp), uint4));
  g_data[hook(0, global_start + global_offset)] = shuffle2(input2, input1, __builtin_astype((comp), uint4));
  g_data_v[hook(2, global_start + global_offset)] = shuffle2(input2_v, input1_v, __builtin_astype((comp), uint4));
}