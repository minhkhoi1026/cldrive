//{"b_width":2,"dst":4,"height":1,"src":3,"width":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void atomic_add_f32(volatile global float* address, float value);
void atomic_min_f32(volatile local float* address, float value);
void atomic_max_f32(volatile local float* address, float value);
void atomic_add_f32(volatile global float* address, float value) {
  unsigned int oldval, newval, readback;

  oldval = __builtin_astype((*address), unsigned int);
  newval = __builtin_astype((*address + value), unsigned int);
  while ((readback = atomic_cmpxchg((volatile global unsigned int*)address, oldval, newval)) != oldval) {
    oldval = readback;
    newval = __builtin_astype((__builtin_astype((oldval), float) + value), unsigned int);
  }
}

void atomic_min_f32(volatile local float* address, float value) {
  unsigned int oldval, newval, readback;

  oldval = __builtin_astype((*address), unsigned int);
  newval = __builtin_astype((fmin(*address, value)), unsigned int);
  while ((readback = atomic_cmpxchg((volatile local unsigned int*)address, oldval, newval)) != oldval) {
    oldval = readback;
    newval = __builtin_astype((fmin(__builtin_astype((oldval), float), value)), unsigned int);
  }
}

void atomic_max_f32(volatile local float* address, float value) {
  unsigned int oldval, newval, readback;

  oldval = __builtin_astype((*address), unsigned int);
  newval = __builtin_astype((fmax(*address, value)), unsigned int);
  while ((readback = atomic_cmpxchg((volatile local unsigned int*)address, oldval, newval)) != oldval) {
    oldval = readback;
    newval = __builtin_astype((fmax(__builtin_astype((oldval), float), value)), unsigned int);
  }
}

constant float gauss5x5[] = {
    0.002969017f, 0.01330621f, 0.021938231f, 0.01330621f, 0.002969017f, 0.01330621f, 0.059634295f, 0.098320331f, 0.059634295f, 0.01330621f, 0.021938231f, 0.098320331f, 0.162102822f, 0.098320331f, 0.021938231f, 0.01330621f, 0.059634295f, 0.098320331f, 0.059634295f, 0.01330621f, 0.002969017f, 0.01330621f, 0.021938231f, 0.01330621f, 0.002969017f,
};
constant float gauss9x9[] = {
    0.000763447f, 0.001831415f, 0.003421534f, 0.004978302f, 0.005641155f, 0.004978302f, 0.003421534f, 0.001831415f, 0.000763447f, 0.001831415f, 0.004393336f, 0.008207832f, 0.011942326f, 0.013532428f, 0.011942326f, 0.008207832f, 0.004393336f, 0.001831415f, 0.003421534f, 0.008207832f, 0.01533425f, 0.022311201f, 0.025281903f, 0.022311201f, 0.01533425f, 0.008207832f, 0.003421534f, 0.004978302f, 0.011942326f, 0.022311201f, 0.032462606f, 0.036784952f, 0.032462606f, 0.022311201f, 0.011942326f, 0.004978302f, 0.005641155f, 0.013532428f, 0.025281903f, 0.036784952f, 0.041682812f, 0.036784952f, 0.025281903f, 0.013532428f, 0.005641155f, 0.004978302f, 0.011942326f, 0.022311201f, 0.032462606f, 0.036784952f, 0.032462606f, 0.022311201f, 0.011942326f, 0.004978302f, 0.003421534f, 0.008207832f, 0.01533425f, 0.022311201f, 0.025281903f, 0.022311201f, 0.01533425f, 0.008207832f, 0.003421534f, 0.001831415f, 0.004393336f, 0.008207832f, 0.011942326f, 0.013532428f, 0.011942326f, 0.008207832f, 0.004393336f, 0.001831415f, 0.000763447f, 0.001831415f, 0.003421534f, 0.004978302f, 0.005641155f, 0.004978302f, 0.003421534f, 0.001831415f, 0.000763447f,
};

constant float threshold = 30;
kernel void toneMapping(unsigned int width, unsigned int height, unsigned int b_width, global float3* src, global uchar* dst) {
  const unsigned int gid0 = get_global_id(0);
  const unsigned int gid1 = get_global_id(1);
  const global float3* srcPix = src + width * gid1 + gid0;
  const unsigned int dIdx = b_width * (height - 1 - gid1) + gid0 * 3;

  float3 pixVal = *srcPix;
  float3 satVal = (float3)(pixVal.s0 > threshold ? threshold : pixVal.s0, pixVal.s1 > threshold ? threshold : pixVal.s1, pixVal.s2 > threshold ? threshold : pixVal.s2);
  float Y = 0.2989 * satVal.s0 + 0.5866 * satVal.s1 + 0.1144 * satVal.s2;
  float scaleTM = (1.0 - exp(-Y)) / Y;
  if (Y == 0.0f)
    scaleTM = 1.0f;

  uchar3 result = convert_uchar3_rtz(clamp(255.0f * pow(scaleTM * satVal, 1.0f / 2.2f), 0.0f, 255.0f));
  dst[hook(4, dIdx + 0)] = result.s2;
  dst[hook(4, dIdx + 1)] = result.s1;
  dst[hook(4, dIdx + 2)] = result.s0;
}