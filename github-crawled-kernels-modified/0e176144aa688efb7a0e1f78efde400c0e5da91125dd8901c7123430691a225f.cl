//{"AI":0,"diag":1,"i":2,"lda2":4,"n2":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void GEStep2(global float* AI, float diag, int i, int n2, int lda2) {
  int k = get_global_id(0);
  if (k < n2) {
    AI[hook(0, i * lda2 + k)] /= diag;
  }
}