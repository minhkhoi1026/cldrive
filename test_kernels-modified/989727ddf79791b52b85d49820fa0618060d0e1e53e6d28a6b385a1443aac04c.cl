//{"X":0,"Y":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void NL_SIGM_FWD(global float* X, global float* Y) {
  unsigned int element = get_global_id(0);
  Y[hook(1, element)] = 1.0f / (1.0f + exp(-X[hook(0, element)]));
}