//{"argmax_val":5,"max_val":4,"n":2,"px":0,"py":3,"skip":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void argmax_kernel_128(const global float* px, const unsigned skip, const unsigned n, global unsigned* py) {
  const unsigned bid = get_group_id(0);
  const unsigned tid = get_local_id(0);
  local float max_val[128];
  local unsigned argmax_val[128];
  px += bid % skip + (bid / skip) * skip * n;
  max_val[hook(4, tid)] = -(__builtin_inff());
  for (unsigned i = tid; i < n; i += 128) {
    const float val = px[hook(0, i * skip)];
    if (val > max_val[hook(4, tid)]) {
      max_val[hook(4, tid)] = val;
      argmax_val[hook(5, tid)] = i;
    }
  }
  barrier(0x01);
  if (128 >= 512 << 1) {
    if (tid < 512) {
      if (max_val[hook(4, tid + 512)] > max_val[hook(4, tid)] || (max_val[hook(4, tid + 512)] == max_val[hook(4, tid)] && argmax_val[hook(5, tid + 512)] < argmax_val[hook(5, tid)])) {
        max_val[hook(4, tid)] = max_val[hook(4, tid + 512)];
        argmax_val[hook(5, tid)] = argmax_val[hook(5, tid + 512)];
      }
    }
    barrier(0x01);
  }
  if (128 >= 256 << 1) {
    if (tid < 256) {
      if (max_val[hook(4, tid + 256)] > max_val[hook(4, tid)] || (max_val[hook(4, tid + 256)] == max_val[hook(4, tid)] && argmax_val[hook(5, tid + 256)] < argmax_val[hook(5, tid)])) {
        max_val[hook(4, tid)] = max_val[hook(4, tid + 256)];
        argmax_val[hook(5, tid)] = argmax_val[hook(5, tid + 256)];
      }
    }
    barrier(0x01);
  }
  if (128 >= 128 << 1) {
    if (tid < 128) {
      if (max_val[hook(4, tid + 128)] > max_val[hook(4, tid)] || (max_val[hook(4, tid + 128)] == max_val[hook(4, tid)] && argmax_val[hook(5, tid + 128)] < argmax_val[hook(5, tid)])) {
        max_val[hook(4, tid)] = max_val[hook(4, tid + 128)];
        argmax_val[hook(5, tid)] = argmax_val[hook(5, tid + 128)];
      }
    }
    barrier(0x01);
  }
  if (128 >= 64 << 1) {
    if (tid < 64) {
      if (max_val[hook(4, tid + 64)] > max_val[hook(4, tid)] || (max_val[hook(4, tid + 64)] == max_val[hook(4, tid)] && argmax_val[hook(5, tid + 64)] < argmax_val[hook(5, tid)])) {
        max_val[hook(4, tid)] = max_val[hook(4, tid + 64)];
        argmax_val[hook(5, tid)] = argmax_val[hook(5, tid + 64)];
      }
    }
    barrier(0x01);
  }
  if (128 >= 32 << 1) {
    if (tid < 32) {
      if (max_val[hook(4, tid + 32)] > max_val[hook(4, tid)] || (max_val[hook(4, tid + 32)] == max_val[hook(4, tid)] && argmax_val[hook(5, tid + 32)] < argmax_val[hook(5, tid)])) {
        max_val[hook(4, tid)] = max_val[hook(4, tid + 32)];
        argmax_val[hook(5, tid)] = argmax_val[hook(5, tid + 32)];
      }
    }
    barrier(0x01);
  }
  if (128 >= 16 << 1) {
    if (tid < 16) {
      if (max_val[hook(4, tid + 16)] > max_val[hook(4, tid)] || (max_val[hook(4, tid + 16)] == max_val[hook(4, tid)] && argmax_val[hook(5, tid + 16)] < argmax_val[hook(5, tid)])) {
        max_val[hook(4, tid)] = max_val[hook(4, tid + 16)];
        argmax_val[hook(5, tid)] = argmax_val[hook(5, tid + 16)];
      }
    }
    barrier(0x01);
  }
  if (128 >= 8 << 1) {
    if (tid < 8) {
      if (max_val[hook(4, tid + 8)] > max_val[hook(4, tid)] || (max_val[hook(4, tid + 8)] == max_val[hook(4, tid)] && argmax_val[hook(5, tid + 8)] < argmax_val[hook(5, tid)])) {
        max_val[hook(4, tid)] = max_val[hook(4, tid + 8)];
        argmax_val[hook(5, tid)] = argmax_val[hook(5, tid + 8)];
      }
    }
    barrier(0x01);
  }
  if (128 >= 4 << 1) {
    if (tid < 4) {
      if (max_val[hook(4, tid + 4)] > max_val[hook(4, tid)] || (max_val[hook(4, tid + 4)] == max_val[hook(4, tid)] && argmax_val[hook(5, tid + 4)] < argmax_val[hook(5, tid)])) {
        max_val[hook(4, tid)] = max_val[hook(4, tid + 4)];
        argmax_val[hook(5, tid)] = argmax_val[hook(5, tid + 4)];
      }
    }
    barrier(0x01);
  }
  if (128 >= 2 << 1) {
    if (tid < 2) {
      if (max_val[hook(4, tid + 2)] > max_val[hook(4, tid)] || (max_val[hook(4, tid + 2)] == max_val[hook(4, tid)] && argmax_val[hook(5, tid + 2)] < argmax_val[hook(5, tid)])) {
        max_val[hook(4, tid)] = max_val[hook(4, tid + 2)];
        argmax_val[hook(5, tid)] = argmax_val[hook(5, tid + 2)];
      }
    }
    barrier(0x01);
  }
  if (128 >= 1 << 1) {
    if (tid < 1) {
      if (max_val[hook(4, tid + 1)] > max_val[hook(4, tid)] || (max_val[hook(4, tid + 1)] == max_val[hook(4, tid)] && argmax_val[hook(5, tid + 1)] < argmax_val[hook(5, tid)])) {
        max_val[hook(4, tid)] = max_val[hook(4, tid + 1)];
        argmax_val[hook(5, tid)] = argmax_val[hook(5, tid + 1)];
      }
    }
    barrier(0x01);
  }
  if (tid == 0)
    py[hook(3, bid)] = argmax_val[hook(5, 0)];
}