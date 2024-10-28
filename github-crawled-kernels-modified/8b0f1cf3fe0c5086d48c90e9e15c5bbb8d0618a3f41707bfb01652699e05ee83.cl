//{"dst":0,"m":2,"n":3,"src":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void bitReverse(global float2* dst, global float2* src, int m, int n) {
  unsigned int gid = get_global_id(0);
  unsigned int nid = get_global_id(1);

  unsigned int j = gid;
  j = (j & 0x55555555) << 1 | (j & 0xAAAAAAAA) >> 1;
  j = (j & 0x33333333) << 2 | (j & 0xCCCCCCCC) >> 2;
  j = (j & 0x0F0F0F0F) << 4 | (j & 0xF0F0F0F0) >> 4;
  j = (j & 0x00FF00FF) << 8 | (j & 0xFF00FF00) >> 8;
  j = (j & 0x0000FFFF) << 16 | (j & 0xFFFF0000) >> 16;

  j >>= (32 - m);

  dst[hook(0, nid * n + j)] = src[hook(1, nid * n + gid)];
}