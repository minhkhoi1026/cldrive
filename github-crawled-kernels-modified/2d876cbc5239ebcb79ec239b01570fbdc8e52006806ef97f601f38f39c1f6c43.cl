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

kernel void scaling(unsigned int width, unsigned int height, unsigned int spp, global float3* src, global float3* output) {
  const unsigned int gid0 = get_global_id(0);
  const unsigned int gid1 = get_global_id(1);
  const global float3* srcPix = src + width * gid1 + gid0;
  global float3* dstPix = output + width * gid1 + gid0;
  *dstPix = *srcPix * (1.0f / spp);
}