//{"a":0,"a_hgt":5,"a_wid":4,"b":1,"b_column":3,"c":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float dotprod(const global float* a, const local float* b, int n);
kernel void ocl_matmpy(const global float* a, const global float* b, global float* c, local float* b_column, int a_wid, int a_hgt) {
  int col = get_global_id(0);
  int width_c = get_global_size(0);
  int width_a = a_wid;
  int width_b = width_c;
  int height_c = a_hgt;
  int height_a = a_hgt;
  int height_b = a_wid;
  int i, row;

  event_t ev = async_work_group_strided_copy(b_column, &b[hook(1, col)], height_b, width_b, 0);
  wait_group_events(1, &ev);

  for (row = 0; row < height_a; ++row) {
    prefetch(&a[hook(0, row * width_a)], width_a);
    c[hook(2, row * width_c + col)] = dotprod(&a[hook(0, row * width_a)], b_column, width_a);
  }
}