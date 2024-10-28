//{"conn":2,"l1":0,"l2":1,"n1":3,"n2":4,"shift_reg":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float squash(float x) {
  return (1.0 / (1.0 + exp(-x)));
}

__attribute__((max_global_work_dim(0))) kernel void bpnn_layerforward(global float* restrict l1, global float* restrict l2, global float* restrict conn, int n1, int n2) {
  float sum;
  int j, k, l;
  float shift_reg[((1 + (1 % 2)) / 2) * 8 + 1];

  l1[hook(0, 0)] = 1.0;

  for (j = 1; j <= n2; j++) {
    for (l = 0; l < ((1 + (1 % 2)) / 2) * 8 + 1; l++) {
      shift_reg[hook(5, l)] = 0;
    }

    sum = 0.0;
    for (k = 0; k <= n1; k++) {
      shift_reg[hook(5, ((1 + (1 % 2)) / 2) * 8)] = shift_reg[hook(5, 0)] + conn[hook(2, k * (n2 + 1) + j)] * l1[hook(0, k)];

      for (l = 0; l < ((1 + (1 % 2)) / 2) * 8; l++) {
        shift_reg[hook(5, l)] = shift_reg[hook(5, l + 1)];
      }
    }

    for (l = 0; l < ((1 + (1 % 2)) / 2) * 8; l++) {
      sum += shift_reg[hook(5, l)];
    }
    l2[hook(1, j)] = squash(sum);
  }
}