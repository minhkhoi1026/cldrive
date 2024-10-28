//{"g_data":0,"high_stage":3,"l_data":1,"stage":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void bsort_stage_n(global float4* g_data, local float4* l_data, unsigned int stage, unsigned int high_stage) {
  int dir;
  float4 input1, input2;
  int4 comp, add;
  unsigned int global_start, global_offset;

  add = (int4)(4, 5, 6, 7);

  dir = (get_group_id(0) / high_stage & 1) * -1;
  global_start = (get_group_id(0) + (get_group_id(0) / stage) * stage) * get_local_size(0) + get_local_id(0);
  global_offset = stage * get_local_size(0);

  input1 = g_data[hook(0, global_start)];
  input2 = g_data[hook(0, global_start + global_offset)];
  comp = (input1 < input2 ^ dir) * 4 + add;
  g_data[hook(0, global_start)] = shuffle2(input1, input2, __builtin_astype((comp), uint4));
  g_data[hook(0, global_start + global_offset)] = shuffle2(input2, input1, __builtin_astype((comp), uint4));
}