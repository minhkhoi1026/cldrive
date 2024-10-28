//{"N":0,"gradOutput":2,"mask":1,"output":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void backpropNaive(const int N, global const unsigned char* mask, global const float* gradOutput, global float* output) {
  const int globalId = get_global_id(0);
  if (globalId >= N) {
    return;
  }
  output[hook(3, globalId)] = mask[hook(1, globalId)] == 1 ? gradOutput[hook(2, globalId)] : 0.0f;
}