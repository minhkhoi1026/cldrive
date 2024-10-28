//{"M":0,"N":1,"in":2,"out":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matrix_nonlin_derivative(const int M, const int N, global float* in, global float* out) {
  const int globalRow = get_global_id(0);
  const int globalCol = get_global_id(1);

  out[hook(3, globalCol * M + globalRow)] = in[hook(2, globalCol * M + globalRow)] * (1 - in[hook(2, globalCol * M + globalRow)]);
}