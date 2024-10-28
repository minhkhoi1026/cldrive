//{"blockWidth":5,"dct8x8":2,"input":1,"inter":3,"inverse":6,"output":0,"width":4}
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
kernel void DCT(global float* output, global float* input, global float* dct8x8, local float* inter, const unsigned int width, const unsigned int blockWidth, const unsigned int inverse)

{
  unsigned int globalIdx = get_global_id(0);
  unsigned int globalIdy = get_global_id(1);

  unsigned int groupIdx = get_group_id(0);
  unsigned int groupIdy = get_group_id(1);

  unsigned int i = get_local_id(0);
  unsigned int j = get_local_id(1);

  unsigned int idx = globalIdy * width + globalIdx;

  float acc = 0.0f;

  for (unsigned int k = 0; k < blockWidth; k++) {
    unsigned int index1 = (inverse) ? i * blockWidth + k : k * blockWidth + i;
    unsigned int index2 = getIdx(groupIdx, groupIdy, j, k, blockWidth, width);

    acc += dct8x8[hook(2, index1)] * input[hook(1, index2)];
  }
  inter[hook(3, j * blockWidth + i)] = acc;

  barrier(0x01);

  acc = 0.0f;

  for (unsigned int k = 0; k < blockWidth; k++) {
    unsigned int index1 = i * blockWidth + k;
    unsigned int index2 = (inverse) ? j * blockWidth + k : k * blockWidth + j;

    acc += inter[hook(3, index1)] * dct8x8[hook(2, index2)];
  }
  output[hook(0, idx)] = acc;
}