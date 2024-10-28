//{"N":0,"input":2,"mask":1,"output":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void forwardNaive(const int N, global const unsigned char* mask, global const float* input, global float* output) {
  const int globalId = get_global_id(0);
  if (globalId >= N) {
    return;
  }
  output[hook(3, globalId)] = mask[hook(1, globalId)] == 1 ? input[hook(2, globalId)] : 0.0f;
}