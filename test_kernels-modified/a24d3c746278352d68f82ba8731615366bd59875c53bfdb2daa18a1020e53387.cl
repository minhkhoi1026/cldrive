//{"AI":0,"i":1,"lda2":3,"n2":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void GEStep1A(global float* AI, int i, int n2, int lda2) {
  int k = get_global_id(0);
  if (k > i && k < n2 && AI[hook(0, i * lda2 + k)] != 0) {
    float multiplyer = -AI[hook(0, i * lda2 + k)] / AI[hook(0, i * lda2 + i)];
    int n = n2 / 2;
    for (int j = i + 1; j < n; j++) {
      AI[hook(0, j * lda2 + k)] += multiplyer * AI[hook(0, j * lda2 + i)];
    }
  }
}