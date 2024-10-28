//{"i_imaginary":3,"i_real":2,"nx":4,"o_imaginary":1,"o_real":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void complex_copy_opencl(global double* o_real, global double* o_imaginary, global double* i_real, global double* i_imaginary, unsigned nx) {
  const int i = get_global_id(0);
  if (i < nx) {
    o_real[hook(0, i)] = i_real[hook(2, i)];
    o_imaginary[hook(1, i)] = i_imaginary[hook(3, i)];
  }
}