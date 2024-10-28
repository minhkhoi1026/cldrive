//{"delta_h":0,"delta_o":2,"err":6,"hidden":5,"nh":1,"no":3,"who":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float squash(float x) {
  return (1.0 / (1.0 + exp(-x)));
}

kernel void bpnn_hidden_error(global float* restrict delta_h, int nh, global float* restrict delta_o, int no, global float* restrict who, global float* restrict hidden, global float* restrict err) {
  int j, k;
  float h, sum, errsum;

  errsum = 0.0;
  for (j = 1; j <= nh; j++) {
    h = hidden[hook(5, j)];
    sum = 0.0;
    for (k = 1; k <= no; k++) {
      sum += delta_o[hook(2, k)] * who[hook(4, j * (no + 1) + k)];
    }
    delta_h[hook(0, j)] = h * (1.0 - h) * sum;
    errsum += (((delta_h[hook(0, j)]) > 0.0) ? (delta_h[hook(0, j)]) : (-(delta_h[hook(0, j)])));
  }
  err[hook(6, 0)] = errsum;
}