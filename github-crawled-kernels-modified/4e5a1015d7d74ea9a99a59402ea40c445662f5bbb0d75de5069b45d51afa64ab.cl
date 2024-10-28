//{"N":0,"input1":1,"input2":2,"output":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mat_mul(const int N, global float* input1, global float* input2, global float* output) {
  int k;
  int i = get_global_id(0);
  int j = get_global_id(1);
  float tmp = 0.0f;
  for (k = 0; k < N; k++) {
    tmp += input1[hook(1, i * N + k)] * input2[hook(2, k * N + j)];
  }
  output[hook(3, i * N + j)] = tmp;
}