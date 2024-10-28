//{"count":3,"inputA":0,"inputB":1,"output":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_0(global float* inputA, global float* inputB, global float* output, const unsigned int count) {
  float result;
  for (int i = 0; i < count; i++) {
    result += log(1.0f + fabs(inputA[hook(0, i)] - inputB[hook(1, i)]));
  }
  output[hook(2, 0)] = result;
}