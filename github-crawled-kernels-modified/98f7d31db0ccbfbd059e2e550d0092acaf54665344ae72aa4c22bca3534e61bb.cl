//{"block":3,"input":1,"length":2,"output":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void prefixSum_kernel(global int* restrict output, global int* restrict input, const unsigned int length) {
  int tid = get_local_id(0);

  local int block[512];

  block[hook(3, 2 * tid)] = input[hook(1, 2 * tid)];
  block[hook(3, 2 * tid + 1)] = input[hook(1, 2 * tid + 1)];

  int offset = 1;

  for (int d = length >> 1; d > 0; d >>= 1) {
    barrier(0x01);

    if (tid < d) {
      int ai = offset * (2 * tid + 1) - 1;
      int bi = offset * (2 * tid + 2) - 1;

      block[hook(3, bi)] += block[hook(3, ai)];
    }
    offset *= 2;
  }

  if (tid == 0) {
    block[hook(3, length - 1)] = 0;
  }

  for (int d = 1; d < length; d *= 2) {
    offset >>= 1;
    barrier(0x01);

    if (tid < d) {
      int ai = offset * (2 * tid + 1) - 1;
      int bi = offset * (2 * tid + 2) - 1;

      int t = block[hook(3, ai)];
      block[hook(3, ai)] = block[hook(3, bi)];
      block[hook(3, bi)] += t;
    }
  }

  barrier(0x01);

  output[hook(0, 2 * tid)] = block[hook(3, 2 * tid)];
  output[hook(0, 2 * tid + 1)] = block[hook(3, 2 * tid + 1)];
}