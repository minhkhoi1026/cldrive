//{"delta_h":0,"delta_o":2,"err":6,"hidden":5,"nh":1,"no":3,"shift_reg":7,"who":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float squash(float x) {
  return (1.0 / (1.0 + exp(-x)));
}

__attribute__((max_global_work_dim(0))) __attribute__((max_global_work_dim(0))) __attribute__((max_global_work_dim(0))) kernel void bpnn_hidden_error(global float* restrict delta_h, int nh, global float* restrict delta_o, int no, global float* restrict who, global float* restrict hidden, global float* restrict err) {
  int j, k, l;
  float h, sum, errsum;
  float shift_reg[((1 + (1 % 2)) / 2) * 8 + 1];

  errsum = 0.0;
  for (j = 1; j <= nh; j++) {
    for (l = 0; l < ((1 + (1 % 2)) / 2) * 8 + 1; l++) {
      shift_reg[hook(7, l)] = 0;
    }

    h = hidden[hook(5, j)];
    sum = 0.0;
    for (k = 1; k <= no; k++) {
      shift_reg[hook(7, ((1 + (1 % 2)) / 2) * 8)] = shift_reg[hook(7, 0)] + delta_o[hook(2, k)] * who[hook(4, j * (no + 1) + k)];

      for (l = 0; l < ((1 + (1 % 2)) / 2) * 8; l++) {
        shift_reg[hook(7, l)] = shift_reg[hook(7, l + 1)];
      }
    }

    for (l = 0; l < ((1 + (1 % 2)) / 2) * 8; l++) {
      sum += shift_reg[hook(7, l)];
    }

    delta_h[hook(0, j)] = h * (1.0 - h) * sum;
    errsum += (((delta_h[hook(0, j)]) > 0.0) ? (delta_h[hook(0, j)]) : (-(delta_h[hook(0, j)])));
  }
  err[hook(6, 0)] = errsum;
}