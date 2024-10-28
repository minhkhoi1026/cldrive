//{"N":1,"result_tanh":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_tanh_withDD1(global float* result_tanh, int N) {
  float t1 = 0.123;
  int i = 0;
  for (i = 0; i < 10 * N; i++) {
    t1 = tanh(t1);
    t1 = tanh(t1);
    t1 = tanh(t1);
    t1 = tanh(t1);
    t1 = tanh(t1);
    t1 = tanh(t1);
    t1 = tanh(t1);
    t1 = tanh(t1);
    t1 = tanh(t1);
    t1 = tanh(t1);
    t1 = tanh(t1);
    t1 = tanh(t1);
    t1 = tanh(t1);
    t1 = tanh(t1);
    t1 = tanh(t1);
    t1 = tanh(t1);
    t1 = tanh(t1);
    t1 = tanh(t1);
    t1 = tanh(t1);
    t1 = tanh(t1);
    t1 = tanh(t1);
    t1 = tanh(t1);
    t1 = tanh(t1);
    t1 = tanh(t1);
    t1 = tanh(t1);
    t1 = tanh(t1);
    t1 = tanh(t1);
    t1 = tanh(t1);
    t1 = tanh(t1);
    t1 = tanh(t1);
    t1 = tanh(t1);
    t1 = tanh(t1);
    t1 = tanh(t1);
    t1 = tanh(t1);
    t1 = tanh(t1);
    t1 = tanh(t1);
    t1 = tanh(t1);
    t1 = tanh(t1);
    t1 = tanh(t1);
    t1 = tanh(t1);
    t1 = tanh(t1);
    t1 = tanh(t1);
    t1 = tanh(t1);
    t1 = tanh(t1);
    t1 = tanh(t1);
    t1 = tanh(t1);
    t1 = tanh(t1);
    t1 = tanh(t1);
    t1 = tanh(t1);
    t1 = tanh(t1);
    t1 = tanh(t1);
    t1 = tanh(t1);
    t1 = tanh(t1);
    t1 = tanh(t1);
    t1 = tanh(t1);
    t1 = tanh(t1);
    t1 = tanh(t1);
    t1 = tanh(t1);
    t1 = tanh(t1);
    t1 = tanh(t1);
    t1 = tanh(t1);
    t1 = tanh(t1);
    t1 = tanh(t1);
    t1 = tanh(t1);
    ;
  }
  *result_tanh = t1;
}