//{"((__global uchar *)in)":3,"((__private unsigned int *)r)":4,"buf":1,"in":0,"r":2}
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
kernel void init(global const unsigned int* in, global uint2* buf) {
  unsigned int nounce = get_global_id(0);
  unsigned int thread = get_global_id(0) - get_global_offset(0);
  unsigned int threads = get_global_size(0);

  uchar r[12];
  r[hook(2, 0)] = ((global uchar*)in)[hook(3, 0)];
  *(ulong*)(&r[hook(2, 1)]) = nounce;
  r[hook(2, 9)] = ((global uchar*)in)[hook(3, 9)];
  r[hook(2, 10)] = ((global uchar*)in)[hook(3, 10)];
  r[hook(2, 11)] = ((global uchar*)in)[hook(3, 11)];

  buf[hook(1, 0 * threads + thread)] = (uint2)(((unsigned int*)r)[hook(4, 0)], ((unsigned int*)r)[hook(4, 1)]);
  buf[hook(1, 1 * threads + thread)] = (uint2)(((unsigned int*)r)[hook(4, 2)], in[hook(0, 3)]);
  buf[hook(1, 2 * threads + thread)] = (uint2)(in[hook(0, 4)], in[hook(0, 5)]);
  buf[hook(1, 3 * threads + thread)] = (uint2)(in[hook(0, 6)], in[hook(0, 7)]);
  buf[hook(1, 4 * threads + thread)] = (uint2)(in[hook(0, 8)], in[hook(0, 9)]);
  buf[hook(1, 5 * threads + thread)] = (uint2)(in[hook(0, 10)], in[hook(0, 11)]);
  buf[hook(1, 6 * threads + thread)] = (uint2)(in[hook(0, 12)], in[hook(0, 13)]);
  buf[hook(1, 7 * threads + thread)] = (uint2)(in[hook(0, 14)], in[hook(0, 15)]);
  buf[hook(1, 8 * threads + thread)] = (uint2)(in[hook(0, 16)], in[hook(0, 17)]);
  buf[hook(1, 9 * threads + thread)] = (uint2)(in[hook(0, 18)], in[hook(0, 19)]);
  uchar4 last = (uchar4)(((global uchar*)in)[hook(3, 80)], 1, 0, 0);
  buf[hook(1, 10 * threads + thread)] = (uint2)(*((unsigned int*)&last), 0);
  buf[hook(1, 11 * threads + thread)] = (uint2)(0, 0);
  buf[hook(1, 12 * threads + thread)] = (uint2)(0, 0);
  buf[hook(1, 13 * threads + thread)] = (uint2)(0, 0);
  buf[hook(1, 14 * threads + thread)] = (uint2)(0, 0);
  buf[hook(1, 15 * threads + thread)] = (uint2)(0, 0);
  buf[hook(1, 16 * threads + thread)] = (uint2)(0, 0x80000000U);
  buf[hook(1, 17 * threads + thread)] = (uint2)(0, 0);
  buf[hook(1, 18 * threads + thread)] = (uint2)(0, 0);
  buf[hook(1, 19 * threads + thread)] = (uint2)(0, 0);
  buf[hook(1, 20 * threads + thread)] = (uint2)(0, 0);
  buf[hook(1, 21 * threads + thread)] = (uint2)(0, 0);
  buf[hook(1, 22 * threads + thread)] = (uint2)(0, 0);
  buf[hook(1, 23 * threads + thread)] = (uint2)(0, 0);
  buf[hook(1, 24 * threads + thread)] = (uint2)(0, 0);
}