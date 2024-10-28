//{"count":3,"inputA":0,"inputB":1,"output":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_8(global float* inputA, global float* inputB, global float* output, const unsigned int count) {
  float A = 0;
  for (int i = 0; i < count; i++) {
    A += (fabs(inputA[hook(0, i)] - inputB[hook(1, i)]) / (fmax(inputA[hook(0, i)], inputB[hook(1, i)])));
  }
  output[hook(2, 8)] = A;
}