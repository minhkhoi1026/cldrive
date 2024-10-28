//{"M":3,"N":4,"matrix":0,"result":2,"vector":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matvec_mult(global float* matrix, global float* vector, global float* result, unsigned int M, unsigned int N) {
  int i = get_global_id(0);
  unsigned int k;
  unsigned int n = N / 4;
  unsigned int d = N - n;
  result[hook(2, i)] = 0;
  global float4* m4 = (global float4*)(matrix + i * N);
  global float4* v4 = (global float4*)vector;

  global float* m = matrix + i * N;
  global float* v = vector;
  d = N;
  for (k = 0; k < d; ++k, ++m, ++v) {
    result[hook(2, i)] += (*m) * (*v);
  }
}