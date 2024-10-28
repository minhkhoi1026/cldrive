//{"matrix1":0,"matrix2":1,"matrix3":2,"size":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void el_wise_mul_div(global float* matrix1, global const float* matrix2, global const float* matrix3, unsigned int size) {
  for (unsigned int i = get_global_id(0); i < size; i += get_global_size(0)) {
    float val = matrix1[hook(0, i)] * matrix2[hook(1, i)];
    float divisor = matrix3[hook(2, i)];
    matrix1[hook(0, i)] = (divisor > 0.00001) ? (val / divisor) : 0;
  }
}