//{"block":2,"input":0,"length":3,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel__ExclusivePrefixScanSmall(global float* input, global float* output, local float* block, const unsigned int length) {
  int tid = get_local_id(0);

  int offset = 1;

  block[hook(2, 2 * tid)] = input[hook(0, 2 * tid)];
  block[hook(2, 2 * tid + 1)] = input[hook(0, 2 * tid + 1)];

  for (int d = length >> 1; d > 0; d >>= 1) {
    barrier(0x01);

    if (tid < d) {
      int ai = offset * (2 * tid + 1) - 1;
      int bi = offset * (2 * tid + 2) - 1;

      block[hook(2, bi)] += block[hook(2, ai)];
    }
    offset *= 2;
  }

  if (tid == 0)
    block[hook(2, length - 1)] = 0;

  for (int d = 1; d < length; d *= 2) {
    offset >>= 1;
    barrier(0x01);

    if (tid < d) {
      int ai = offset * (2 * tid + 1) - 1;
      int bi = offset * (2 * tid + 2) - 1;

      float t = block[hook(2, ai)];
      block[hook(2, ai)] = block[hook(2, bi)];
      block[hook(2, bi)] += t;
    }
  }

  barrier(0x01);

  output[hook(1, 2 * tid)] = block[hook(2, 2 * tid)];
  output[hook(1, 2 * tid + 1)] = block[hook(2, 2 * tid + 1)];
}