//{"height":1,"output":4,"spp":2,"src":3,"width":0}
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
kernel void bloom(unsigned int width, unsigned int height, unsigned int spp, global float3* src, global float3* output) {
  const unsigned int gid0 = get_global_id(0);
  const unsigned int gid1 = get_global_id(1);
  const global float3* srcPix = src + width * gid1 + gid0;

  for (int i = 0; i < 3; ++i) {
    float pixVal = *((const global float*)srcPix + i) * (1.0f / spp);
    if (pixVal > threshold) {
      float excess = pixVal - threshold;
      const int fRadius = excess > 7.0f ? 7 : (int)excess;
      for (int dy = -fRadius; dy <= fRadius; ++dy) {
        for (int dx = -fRadius; dx <= fRadius; ++dx) {
          float dist = sqrt((float)(dx * dx + dy * dy));

          int px = clamp((int)gid0 + dx, 0, (int)width - 1);
          int py = clamp((int)gid1 + dy, 0, (int)height - 1);
          global float* dstPixBase = (global float*)(output + width * py + px);
          if (dx != 0 || dy != 0)
            atomic_add_f32(dstPixBase + i, exp(-dist) * excess);
          else
            atomic_add_f32(dstPixBase + i, threshold);
        }
      }
    } else {
      global float* dstPixBase = (global float*)(output + width * gid1 + gid0);
      atomic_add_f32(dstPixBase + i, pixVal);
    }
  }
}