//{"buf":1,"output":0,"target":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
uint2 ROTL64_1(const uint2 x, const unsigned int y) {
  return (uint2)((x.x << y) ^ (x.y >> (32 - y)), (x.y << y) ^ (x.x >> (32 - y)));
}
uint2 ROTL64_2(const uint2 x, const unsigned int y) {
  return (uint2)((x.y << y) ^ (x.x >> (32 - y)), (x.x << y) ^ (x.y >> (32 - y)));
}
ulong ROTL641(const ulong x) {
  return (x << 1 | x >> 63);
}
kernel void result(global ulong* restrict output, global uint2* buf, const ulong target) {
  ulong nonce = get_global_id(0);
  unsigned int thread = get_global_id(0) - get_global_offset(0);
  unsigned int threads = get_global_size(0);

  uint2 state3;
  state3 = buf[hook(1, (3) * threads + thread)];
  if (*((ulong*)&state3) <= target)
    output[hook(0, outputhook(0, 15)++)] = nonce;
}