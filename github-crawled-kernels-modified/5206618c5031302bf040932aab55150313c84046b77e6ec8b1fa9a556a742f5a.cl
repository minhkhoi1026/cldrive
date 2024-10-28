//{"buf":0,"size":2,"sp":1}
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
kernel void mixin(global ulong* buf, global const ulong4* sp, const unsigned int size) {
  unsigned int threads = get_global_size(0) / 6;
  unsigned int thread = get_global_id(0) % threads;
  unsigned int step = get_global_id(0) / threads * 4;

  ulong s0, s1, s2, s3;
  s0 = buf[hook(0, (step) * threads + thread)];
  s1 = buf[hook(0, (step + 1) * threads + thread)];
  s2 = buf[hook(0, (step + 2) * threads + thread)];
  s3 = buf[hook(0, (step + 3) * threads + thread)];

  ulong4 m = sp[hook(1, s0 % size)] ^ sp[hook(1, s1 % size)] ^ sp[hook(1, s2 % size)] ^ sp[hook(1, s3 % size)];

  buf[hook(0, (step) * threads + thread)] = s0 ^ m.s0;
  buf[hook(0, (step + 1) * threads + thread)] = s1 ^ m.s1;
  buf[hook(0, (step + 2) * threads + thread)] = s2 ^ m.s2;
  buf[hook(0, (step + 3) * threads + thread)] = s3 ^ m.s3;
}