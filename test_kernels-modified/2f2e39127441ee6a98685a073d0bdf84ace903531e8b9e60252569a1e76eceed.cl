//{"argmin_val":5,"min_val":4,"n":2,"px":0,"py":3,"skip":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void argmin_kernel_32(const global float* px, const unsigned skip, const unsigned n, global unsigned* py) {
  const unsigned bid = get_group_id(0);
  const unsigned tid = get_local_id(0);
  local float min_val[32];
  local unsigned argmin_val[32];
  px += bid % skip + (bid / skip) * skip * n;
  min_val[hook(4, tid)] = (__builtin_inff());
  for (unsigned i = tid; i < n; i += 32) {
    const float val = px[hook(0, i * skip)];
    if (val < min_val[hook(4, tid)]) {
      min_val[hook(4, tid)] = val;
      argmin_val[hook(5, tid)] = i;
    }
  }
  barrier(0x01);
  if (32 >= 512 << 1) {
    if (tid < 512) {
      if (min_val[hook(4, tid + 512)] < min_val[hook(4, tid)] || (min_val[hook(4, tid + 512)] == min_val[hook(4, tid)] && argmin_val[hook(5, tid + 512)] < argmin_val[hook(5, tid)])) {
        min_val[hook(4, tid)] = min_val[hook(4, tid + 512)];
        argmin_val[hook(5, tid)] = argmin_val[hook(5, tid + 512)];
      }
    }
    barrier(0x01);
  }
  if (32 >= 256 << 1) {
    if (tid < 256) {
      if (min_val[hook(4, tid + 256)] < min_val[hook(4, tid)] || (min_val[hook(4, tid + 256)] == min_val[hook(4, tid)] && argmin_val[hook(5, tid + 256)] < argmin_val[hook(5, tid)])) {
        min_val[hook(4, tid)] = min_val[hook(4, tid + 256)];
        argmin_val[hook(5, tid)] = argmin_val[hook(5, tid + 256)];
      }
    }
    barrier(0x01);
  }
  if (32 >= 128 << 1) {
    if (tid < 128) {
      if (min_val[hook(4, tid + 128)] < min_val[hook(4, tid)] || (min_val[hook(4, tid + 128)] == min_val[hook(4, tid)] && argmin_val[hook(5, tid + 128)] < argmin_val[hook(5, tid)])) {
        min_val[hook(4, tid)] = min_val[hook(4, tid + 128)];
        argmin_val[hook(5, tid)] = argmin_val[hook(5, tid + 128)];
      }
    }
    barrier(0x01);
  }
  if (32 >= 64 << 1) {
    if (tid < 64) {
      if (min_val[hook(4, tid + 64)] < min_val[hook(4, tid)] || (min_val[hook(4, tid + 64)] == min_val[hook(4, tid)] && argmin_val[hook(5, tid + 64)] < argmin_val[hook(5, tid)])) {
        min_val[hook(4, tid)] = min_val[hook(4, tid + 64)];
        argmin_val[hook(5, tid)] = argmin_val[hook(5, tid + 64)];
      }
    }
    barrier(0x01);
  }
  if (32 >= 32 << 1) {
    if (tid < 32) {
      if (min_val[hook(4, tid + 32)] < min_val[hook(4, tid)] || (min_val[hook(4, tid + 32)] == min_val[hook(4, tid)] && argmin_val[hook(5, tid + 32)] < argmin_val[hook(5, tid)])) {
        min_val[hook(4, tid)] = min_val[hook(4, tid + 32)];
        argmin_val[hook(5, tid)] = argmin_val[hook(5, tid + 32)];
      }
    }
    barrier(0x01);
  }
  if (32 >= 16 << 1) {
    if (tid < 16) {
      if (min_val[hook(4, tid + 16)] < min_val[hook(4, tid)] || (min_val[hook(4, tid + 16)] == min_val[hook(4, tid)] && argmin_val[hook(5, tid + 16)] < argmin_val[hook(5, tid)])) {
        min_val[hook(4, tid)] = min_val[hook(4, tid + 16)];
        argmin_val[hook(5, tid)] = argmin_val[hook(5, tid + 16)];
      }
    }
    barrier(0x01);
  }
  if (32 >= 8 << 1) {
    if (tid < 8) {
      if (min_val[hook(4, tid + 8)] < min_val[hook(4, tid)] || (min_val[hook(4, tid + 8)] == min_val[hook(4, tid)] && argmin_val[hook(5, tid + 8)] < argmin_val[hook(5, tid)])) {
        min_val[hook(4, tid)] = min_val[hook(4, tid + 8)];
        argmin_val[hook(5, tid)] = argmin_val[hook(5, tid + 8)];
      }
    }
    barrier(0x01);
  }
  if (32 >= 4 << 1) {
    if (tid < 4) {
      if (min_val[hook(4, tid + 4)] < min_val[hook(4, tid)] || (min_val[hook(4, tid + 4)] == min_val[hook(4, tid)] && argmin_val[hook(5, tid + 4)] < argmin_val[hook(5, tid)])) {
        min_val[hook(4, tid)] = min_val[hook(4, tid + 4)];
        argmin_val[hook(5, tid)] = argmin_val[hook(5, tid + 4)];
      }
    }
    barrier(0x01);
  }
  if (32 >= 2 << 1) {
    if (tid < 2) {
      if (min_val[hook(4, tid + 2)] < min_val[hook(4, tid)] || (min_val[hook(4, tid + 2)] == min_val[hook(4, tid)] && argmin_val[hook(5, tid + 2)] < argmin_val[hook(5, tid)])) {
        min_val[hook(4, tid)] = min_val[hook(4, tid + 2)];
        argmin_val[hook(5, tid)] = argmin_val[hook(5, tid + 2)];
      }
    }
    barrier(0x01);
  }
  if (32 >= 1 << 1) {
    if (tid < 1) {
      if (min_val[hook(4, tid + 1)] < min_val[hook(4, tid)] || (min_val[hook(4, tid + 1)] == min_val[hook(4, tid)] && argmin_val[hook(5, tid + 1)] < argmin_val[hook(5, tid)])) {
        min_val[hook(4, tid)] = min_val[hook(4, tid + 1)];
        argmin_val[hook(5, tid)] = argmin_val[hook(5, tid + 1)];
      }
    }
    barrier(0x01);
  }
  if (tid == 0)
    py[hook(3, bid)] = argmin_val[hook(5, 0)];
}