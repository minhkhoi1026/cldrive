//{"N":2,"x":0,"y":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void rdft(global float* x, global float* y, const int N) {
  int num_vectors = N / 4;

  float X_real = 0.0f;
  float X_imag = 0.0f;

  float4 input, arg, w_real, w_imag;
  float two_pi_k_over_N = 2 * 3.14159265358979323846264338327950288f * get_global_id(0) / N;

  for (int i = 0; i < num_vectors; i++) {
    arg = (float4)(two_pi_k_over_N * (i * 4), two_pi_k_over_N * (i * 4 + 1), two_pi_k_over_N * (i * 4 + 2), two_pi_k_over_N * (i * 4 + 3));
    w_real = cos(arg);
    w_imag = sin(arg);

    input = vload4(i, x);
    X_real += dot(input, w_real);
    X_imag -= dot(input, w_imag);
  }

  if (get_global_id(0) == 0) {
    y[hook(1, 0)] = X_real;
  } else if (get_global_id(0) == get_global_size(0) - 1) {
    y[hook(1, 1)] = X_real;
  } else {
    y[hook(1, get_global_id(0) * 2)] = X_real;
    y[hook(1, get_global_id(0) * 2 + 1)] = X_imag;
  }
}