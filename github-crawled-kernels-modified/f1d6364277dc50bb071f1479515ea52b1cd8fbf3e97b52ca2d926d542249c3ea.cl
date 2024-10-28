//{"g_data":0,"g_data_v":1,"valMax":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void bsort_postprocess_kv(global uint4* g_data, global uint4* g_data_v, unsigned int valMax) {
  unsigned int id, global_start;
  uint4 input1, input2, input1_v, input2_v;

  id = get_local_id(0) * 2;
  global_start = get_group_id(0) * get_local_size(0) * 2 + id;

  input1 = g_data[hook(0, global_start)];
  input2 = g_data[hook(0, global_start + 1)];
  input1_v = g_data_v[hook(1, global_start)];
  input2_v = g_data_v[hook(1, global_start + 1)];

  input1.x = (input1.x - input1_v.x) / valMax;
  input1.y = (input1.y - input1_v.y) / valMax;
  input1.z = (input1.z - input1_v.z) / valMax;
  input1.w = (input1.w - input1_v.w) / valMax;
  input2.x = (input2.x - input2_v.x) / valMax;
  input2.y = (input2.y - input2_v.y) / valMax;
  input2.z = (input2.z - input2_v.z) / valMax;
  input2.w = (input2.w - input2_v.w) / valMax;

  g_data[hook(0, global_start)] = input1;
  g_data[hook(0, global_start + 1)] = input2;
  g_data_v[hook(1, global_start)] = input1_v;
  g_data_v[hook(1, global_start + 1)] = input2_v;
}