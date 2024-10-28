//{"in_data":0,"out_data":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void cl_square_array_int(global float* in_data, global float* out_data) {
  int g_x = get_global_id(0);
  int l_x = get_local_id(0);

  int size_g_x = get_global_size(0);
  int size_l_x = get_local_size(0);

  if (g_x < size_g_x && l_x < size_l_x)
    out_data[hook(1, l_x + (g_x * size_l_x))] = sqrt(in_data[hook(0, l_x + (g_x * size_l_x))]);
}