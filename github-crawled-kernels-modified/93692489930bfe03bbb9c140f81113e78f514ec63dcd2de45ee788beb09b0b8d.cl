//{"blockWidth":4,"input":1,"input2":2,"output":0,"width":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
unsigned int getIdx(unsigned int blockIdx, unsigned int blockIdy, unsigned int localIdx, unsigned int localIdy, unsigned int blockWidth, unsigned int globalWidth) {
  unsigned int globalIdx = blockIdx * blockWidth + localIdx;
  unsigned int globalIdy = blockIdy * blockWidth + localIdy;

  return (globalIdy * globalWidth + globalIdx);
}
kernel void MADD(global int* output, global int* input, global int* input2, const unsigned int width, const unsigned int blockWidth) {
  unsigned int globalIdx = get_global_id(0);
  unsigned int globalIdy = get_global_id(1);
  unsigned int idx = globalIdy * width + globalIdx;

  output[hook(0, idx)] = input[hook(1, idx)] + input2[hook(2, idx)];
}