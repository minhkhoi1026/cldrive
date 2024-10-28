//{"delta":0,"err":4,"nj":3,"output":2,"shift_reg":5,"target":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float squash(float x) {
  return (1.0 / (1.0 + exp(-x)));
}

__attribute__((max_global_work_dim(0))) __attribute__((max_global_work_dim(0))) kernel void bpnn_output_error(global float* restrict delta, global float* restrict target, global float* restrict output, int nj, global float* restrict err) {
  int j, l;
  float o, t, errsum;
  float shift_reg[((1 + (1 % 2)) / 2) * 8 + 1];

  for (l = 0; l < ((1 + (1 % 2)) / 2) * 8 + 1; l++) {
    shift_reg[hook(5, l)] = 0;
  }

  errsum = 0.0;
  for (j = 1; j <= nj; j++) {
    o = output[hook(2, j)];
    t = target[hook(1, j)];
    delta[hook(0, j)] = o * (1.0 - o) * (t - o);

    shift_reg[hook(5, ((1 + (1 % 2)) / 2) * 8)] = shift_reg[hook(5, 0)] + (((delta[hook(0, j)]) > 0.0) ? (delta[hook(0, j)]) : (-(delta[hook(0, j)])));

    for (l = 0; l < ((1 + (1 % 2)) / 2) * 8; l++) {
      shift_reg[hook(5, l)] = shift_reg[hook(5, l + 1)];
    }
  }

  for (l = 0; l < ((1 + (1 % 2)) / 2) * 8; l++) {
    errsum += shift_reg[hook(5, l)];
  }

  err[hook(4, 0)] = errsum;
}