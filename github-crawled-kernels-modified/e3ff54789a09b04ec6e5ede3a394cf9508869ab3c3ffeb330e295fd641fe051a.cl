//{"A":0,"B":1,"C":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vector_add(global const float* A, global float* B, global float* C) {
  int i = get_global_id(0);

  for (i = 0; i < 4; i++) {
    B[hook(1, i)] = C[hook(2, i)] = 0;
  }
  for (i = 0; i < 100000; i++) {
    float x1 = -1.000117f;

    B[hook(1, i)] = (x1 / ((1.000000 + 1.000000) * (((fma(x1, x1, x1)) * (1.000000 - x1)) / (x1 / x1))));

    B[hook(1, i)] = (1.000000 + 1.000000) * (x1 + ((x1 / 1.000000) * x1)) * (1.000000 - x1) / (x1 / x1);
    C[hook(2, i)] = x1 / (1.000000 + 1.000000) * fma(x1, x1, x1) * (1.000000 - x1) / (x1 / x1);
  }
}