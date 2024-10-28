//{"a_i":1,"a_r":0,"b_i":3,"b_r":2,"result_i":5,"result_r":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void complex_mult(global float* a_r, global float* a_i, global float* b_r, global float* b_i, global float* result_r, global float* result_i) {
  int i;

  i = get_global_id(0);

  result_r[hook(4, i)] = a_r[hook(0, i)] * b_r[hook(2, i)] - a_i[hook(1, i)] * b_i[hook(3, i)];
  result_i[hook(5, i)] = a_r[hook(0, i)] * b_i[hook(3, i)] + a_i[hook(1, i)] * b_r[hook(2, i)];
}