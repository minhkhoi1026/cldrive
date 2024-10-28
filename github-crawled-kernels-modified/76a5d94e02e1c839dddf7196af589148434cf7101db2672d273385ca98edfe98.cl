//{"M":0,"N":1,"inA":2,"inB":3,"out":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matrix_add(const int M, const int N, global float* inA, global float* inB, global float* out) {
  const int globalRow = get_global_id(0);
  const int globalCol = get_global_id(1);

  out[hook(4, globalCol * M + globalRow)] = inA[hook(2, globalCol * M + globalRow)] + inB[hook(3, globalCol * M + globalRow)];
}