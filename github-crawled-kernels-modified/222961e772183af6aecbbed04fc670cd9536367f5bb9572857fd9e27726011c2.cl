//{"checksum":3,"empty":2,"out":0,"out_count":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void checksum(global unsigned int* out, const ulong out_count, const unsigned int empty, global ulong* checksum) {
  ulong sum = 0;
  ulong i = 0;

  for (; i < out_count; ++i) {
    if (out[hook(0, i)] != empty) {
      sum += out[hook(0, i)];
    }
  }

  checksum[hook(3, 0)] = sum;
}