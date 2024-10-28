//{"K":2,"M":0,"N":1,"inA":3,"inB":4,"out":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matrix_multiply(const int M, const int N, const int K, const global float* inA, const global float* inB, global float* out) {
  const int globalRow = get_global_id(0);
  const int globalCol = get_global_id(1);

  float acc = 0.0f;

  for (int k = 0; k < K; k++) {
    acc += inA[hook(3, k * M + globalRow)] * inB[hook(4, globalCol * K + k)];
  }

  out[hook(5, globalCol * M + globalRow)] = acc;
}