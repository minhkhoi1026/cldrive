//{"Avg":3,"StdDev":4,"input":0,"minmax":2,"size":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void histo_prescan_kernel(global unsigned int* input, int size, global unsigned int* minmax) {
  local float Avg[128];
  local float StdDev[128];

  int threadIdxx = get_local_id(0);
  int blockDimx = get_local_size(0);
  int blockIdxx = get_group_id(0);
  int stride = size / (get_num_groups(0));
  int addr = blockIdxx * stride + threadIdxx;
  int end = blockIdxx * stride + stride / 8;

  float avg = 0.0;
  unsigned int count = 0;
  while (addr < end) {
    avg += input[hook(0, addr)];
    count++;
    addr += blockDimx;
  }
  avg /= count;
  Avg[hook(3, threadIdxx)] = avg;

  int addr2 = blockIdxx * stride + threadIdxx;
  float stddev = 0;
  while (addr2 < end) {
    stddev += (input[hook(0, addr2)] - avg) * (input[hook(0, addr2)] - avg);
    addr2 += blockDimx;
  }
  stddev /= count;
  StdDev[hook(4, threadIdxx)] = sqrt(stddev);
  for (int stride = 128 / 2; stride >= 32; stride = stride >> 1) {
    barrier(0x01);
    if (threadIdxx < stride) {
      Avg[hook(3, threadIdxx)] += Avg[hook(3, threadIdxx + stride)];
      StdDev[hook(4, threadIdxx)] += StdDev[hook(4, threadIdxx + stride)];
    };
  }

  if (threadIdxx < 16) {
    Avg[hook(3, threadIdxx)] += Avg[hook(3, threadIdxx + 16)];
    StdDev[hook(4, threadIdxx)] += StdDev[hook(4, threadIdxx + 16)];
  };

  if (threadIdxx < 8) {
    Avg[hook(3, threadIdxx)] += Avg[hook(3, threadIdxx + 8)];
    StdDev[hook(4, threadIdxx)] += StdDev[hook(4, threadIdxx + 8)];
  };

  if (threadIdxx < 4) {
    Avg[hook(3, threadIdxx)] += Avg[hook(3, threadIdxx + 4)];
    StdDev[hook(4, threadIdxx)] += StdDev[hook(4, threadIdxx + 4)];
  };

  if (threadIdxx < 2) {
    Avg[hook(3, threadIdxx)] += Avg[hook(3, threadIdxx + 2)];
    StdDev[hook(4, threadIdxx)] += StdDev[hook(4, threadIdxx + 2)];
  };

  if (threadIdxx == 0) {
    float avg = Avg[hook(3, 0)] + Avg[hook(3, 1)];
    avg /= 128;
    float stddev = StdDev[hook(4, 0)] + StdDev[hook(4, 1)];
    stddev /= 128;

    atom_min(minmax, ((unsigned int)(avg - 10 * stddev)) / (2 * 1024));
    atom_max(minmax + 1, ((unsigned int)(avg + 10 * stddev)) / (2 * 1024));
  }
}