//{"delta":0,"err":4,"nj":3,"output":2,"target":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float squash(float x) {
  return (1.0 / (1.0 + exp(-x)));
}

kernel void bpnn_output_error(global float* restrict delta, global float* restrict target, global float* restrict output, int nj, global float* restrict err) {
  int j;
  float o, t, errsum;
  errsum = 0.0;
  for (j = 1; j <= nj; j++) {
    o = output[hook(2, j)];
    t = target[hook(1, j)];
    delta[hook(0, j)] = o * (1.0 - o) * (t - o);
    errsum += (((delta[hook(0, j)]) > 0.0) ? (delta[hook(0, j)]) : (-(delta[hook(0, j)])));
  }
  err[hook(4, 0)] = errsum;
}