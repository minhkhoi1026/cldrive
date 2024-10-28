//{"g_data":0,"g_data_v":1,"valMax":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void bsort_preprocess_kv(global uint4* g_data, global uint4* g_data_v, unsigned int valMax) {
  unsigned int id, global_start;
  uint4 input1, input2, input1_v, input2_v;

  id = get_local_id(0) * 2;
  global_start = get_group_id(0) * get_local_size(0) * 2 + id;

  input1 = g_data[hook(0, global_start)];
  input2 = g_data[hook(0, global_start + 1)];
  input1_v = g_data_v[hook(1, global_start)];
  input2_v = g_data_v[hook(1, global_start + 1)];

  input1.x = input1.x * valMax + input1_v.x;
  input1.y = input1.y * valMax + input1_v.y;
  input1.z = input1.z * valMax + input1_v.z;
  input1.w = input1.w * valMax + input1_v.w;
  input2.x = input2.x * valMax + input2_v.x;
  input2.y = input2.y * valMax + input2_v.y;
  input2.z = input2.z * valMax + input2_v.z;
  input2.w = input2.w * valMax + input2_v.w;

  g_data[hook(0, global_start)] = input1;
  g_data[hook(0, global_start + 1)] = input2;
  g_data_v[hook(1, global_start)] = input1_v;
  g_data_v[hook(1, global_start + 1)] = input2_v;
}