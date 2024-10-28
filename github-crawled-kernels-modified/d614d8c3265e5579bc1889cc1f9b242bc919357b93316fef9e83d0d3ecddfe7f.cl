//{"in_x":1,"in_y":2,"mat":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void floyd_warshall_buffer(global float* mat, global float* in_x, global float* in_y) {
  const int2 d = (int2)(get_global_id(0), get_global_id(1));
  const int2 m = (int2)(get_global_size(0), get_global_size(1));

  int position = d.y * m.x + d.x;
  float val1 = mat[hook(0, position)];
  float val2 = in_x[hook(1, d.x)] + in_y[hook(2, d.y)];
  mat[hook(0, position)] = (val1 < val2) ? val1 : val2;
}