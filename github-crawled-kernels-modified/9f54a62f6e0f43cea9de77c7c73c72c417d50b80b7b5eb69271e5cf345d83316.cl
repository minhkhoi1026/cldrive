//{"A":2,"B":5,"H":1,"W":0,"lda":3,"ldb":6,"offsetA":4,"offsetB":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void floatMatrixTranspose(unsigned int W, unsigned int H, const float global* A, unsigned int lda, unsigned int offsetA, float global* B, unsigned int ldb, unsigned int offsetB) {
  int i = get_global_id(0);
  int j = get_global_id(1);

  if (i < W && j < H) {
    B[hook(5, j * ldb + i + offsetB)] = A[hook(2, i * lda + j + offsetA)];
  }
}