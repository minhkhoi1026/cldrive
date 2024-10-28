//{"delta":0,"ly":2,"ndelta":1,"nly":3,"oldw":5,"w":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float squash(float x) {
  return (1.0 / (1.0 + exp(-x)));
}

__attribute__((max_global_work_dim(0))) __attribute__((max_global_work_dim(0))) __attribute__((max_global_work_dim(0))) __attribute__((max_global_work_dim(0))) kernel void bpnn_adjust_weights(global float* restrict delta, int ndelta, global float* restrict ly, int nly, global float* restrict w, global float* restrict oldw) {
  float new_dw;
  int k, j;

  ly[hook(2, 0)] = 1.0;
  for (j = 1; j <= ndelta; j++) {
    for (k = 0; k <= nly; k++) {
      new_dw = ((0.3 * delta[hook(0, j)] * ly[hook(2, k)]) + (0.3 * oldw[hook(5, k * (ndelta + 1) + j)]));
      w[hook(4, k * (ndelta + 1) + j)] += new_dw;
      oldw[hook(5, k * (ndelta + 1) + j)] = new_dw;
    }
  }
}