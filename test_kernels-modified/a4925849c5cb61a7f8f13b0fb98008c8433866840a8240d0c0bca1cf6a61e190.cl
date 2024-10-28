//{"input0":1,"input1":2,"numElements":0,"output":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float theKernel_core(float a, float b) {
  a *= 2;
  b *= 2;
  a += b;
  b += a;
  return a + b;
}

kernel void theKernel(int numElements, global const float* input0, global const float* input1, global float* output) {
  int gid = get_global_id(0);
  if (gid < numElements) {
    float a = input0[hook(1, gid)];
    float b = input1[hook(2, gid)];
    output[hook(3, gid)] = theKernel_core(a, b);
  }
}