//{}
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

kernel void clear(unsigned int width, unsigned int height, global float3* buffer);