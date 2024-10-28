//{"eps":2,"inner_size":1,"mean":4,"sdata":6,"src":3,"std":5,"total_size":0,"vsum":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reduce_std(int total_size, int inner_size, const float eps, global const float* src, global const float* mean, global float* std) {
  local float sdata[256];
  int tid = get_local_id(0);
  sdata[hook(6, tid)] = (float)0.0f;

  int blockSize = get_local_size(0);
  int blockIdx_x = get_group_id(0);

  for (int j = tid; j < inner_size; j += blockSize) {
    sdata[hook(6, tid)] += (src[hook(3, blockIdx_x * inner_size + j)] - mean[hook(4, blockIdx_x)]) * (src[hook(3, blockIdx_x * inner_size + j)] - mean[hook(4, blockIdx_x)]);
  }

  barrier(0x01);

  if (blockSize >= 1024) {
    if (tid < 512) {
      sdata[hook(6, tid)] += sdata[hook(6, tid + 512)];
    }

    barrier(0x01);
  }

  if (blockSize >= 512) {
    if (tid < 256) {
      sdata[hook(6, tid)] += sdata[hook(6, tid + 256)];
    }

    barrier(0x01);
  }

  if (blockSize >= 256) {
    if (tid < 128) {
      sdata[hook(6, tid)] += sdata[hook(6, tid + 128)];
    }

    barrier(0x01);
  }

  if (blockSize >= 128) {
    if (tid < 64) {
      sdata[hook(6, tid)] += sdata[hook(6, tid + 64)];
    }

    barrier(0x01);
  }

  if (tid < 32) {
    volatile local float* vsum = sdata;

    if (blockSize >= 64) {
      vsum[hook(7, tid)] += vsum[hook(7, tid + 32)];
    }

    if (blockSize >= 32) {
      vsum[hook(7, tid)] += vsum[hook(7, tid + 16)];
    }

    if (blockSize >= 16) {
      vsum[hook(7, tid)] += vsum[hook(7, tid + 8)];
    }

    if (blockSize >= 8) {
      vsum[hook(7, tid)] += vsum[hook(7, tid + 4)];
    }

    if (blockSize >= 4) {
      vsum[hook(7, tid)] += vsum[hook(7, tid + 2)];
    }

    if (blockSize >= 2) {
      vsum[hook(7, tid)] += vsum[hook(7, tid + 1)];
    }

    if (tid == 0) {
      vsum[hook(7, 0)] = vsum[hook(7, 0)] / inner_size;

      std[hook(5, blockIdx_x)] = 1.f / (sqrt(vsum[hook(7, 0)]) + eps);
    }
  }
}