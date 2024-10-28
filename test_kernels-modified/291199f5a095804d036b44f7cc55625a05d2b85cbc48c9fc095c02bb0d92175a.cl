//{"AI":0,"i":1,"lda2":3,"n2":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void GEStep3(global float* AI, int i, int n2, int lda2) {
  int k = get_global_id(0);
  if (k > i && k < n2) {
    float multiplyer = -AI[hook(0, i * lda2 + k)];
    for (int j = 0; j < i; j++) {
      AI[hook(0, j * lda2 + k)] += multiplyer * AI[hook(0, j * lda2 + i)];
    }
  }
}