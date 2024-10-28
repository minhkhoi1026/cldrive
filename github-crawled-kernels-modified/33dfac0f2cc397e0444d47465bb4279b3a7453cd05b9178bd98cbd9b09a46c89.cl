//{"block":2,"blockSize":5,"height":4,"input":1,"output":0,"width":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void transpose_kernel(global uchar4* output, global uchar4* input, local uchar4* block, const unsigned int width, const unsigned int height, const unsigned int blockSize) {
  unsigned int globalIdx = get_global_id(0);
  unsigned int globalIdy = get_global_id(1);

  unsigned int localIdx = get_local_id(0);
  unsigned int localIdy = get_local_id(1);

  block[hook(2, localIdy * blockSize + localIdx)] = input[hook(1, globalIdy * width + globalIdx)];

  barrier(0x01);

  unsigned int sourceIndex = localIdy * blockSize + localIdx;
  unsigned int targetIndex = globalIdy + globalIdx * height;

  output[hook(0, targetIndex)] = block[hook(2, sourceIndex)];
}