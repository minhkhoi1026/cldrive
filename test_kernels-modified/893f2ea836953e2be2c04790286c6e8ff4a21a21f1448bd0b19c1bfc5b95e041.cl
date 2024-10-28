//{"buf":0}
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
kernel void init2(global uint2* buf) {
  unsigned int thread = get_global_id(0) - get_global_offset(0);
  unsigned int threads = get_global_size(0);

  buf[hook(0, 4 * threads + thread)] = (uint2)(1, 0);
  buf[hook(0, 5 * threads + thread)] = (uint2)(0, 0);
  buf[hook(0, 6 * threads + thread)] = (uint2)(0, 0);
  buf[hook(0, 7 * threads + thread)] = (uint2)(0, 0);
  buf[hook(0, 8 * threads + thread)] = (uint2)(0, 0);
  buf[hook(0, 9 * threads + thread)] = (uint2)(0, 0);
  buf[hook(0, 10 * threads + thread)] = (uint2)(0, 0);
  buf[hook(0, 11 * threads + thread)] = (uint2)(0, 0);
  buf[hook(0, 12 * threads + thread)] = (uint2)(0, 0);
  buf[hook(0, 13 * threads + thread)] = (uint2)(0, 0);
  buf[hook(0, 14 * threads + thread)] = (uint2)(0, 0);
  buf[hook(0, 15 * threads + thread)] = (uint2)(0, 0);
  buf[hook(0, 16 * threads + thread)] = (uint2)(0, 0x80000000U);
  buf[hook(0, 17 * threads + thread)] = (uint2)(0, 0);
  buf[hook(0, 18 * threads + thread)] = (uint2)(0, 0);
  buf[hook(0, 19 * threads + thread)] = (uint2)(0, 0);
  buf[hook(0, 20 * threads + thread)] = (uint2)(0, 0);
  buf[hook(0, 21 * threads + thread)] = (uint2)(0, 0);
  buf[hook(0, 22 * threads + thread)] = (uint2)(0, 0);
  buf[hook(0, 23 * threads + thread)] = (uint2)(0, 0);
  buf[hook(0, 24 * threads + thread)] = (uint2)(0, 0);
}