//{"clipLimit":8,"dstStep":4,"dst_offset":5,"lut":3,"lutScale":9,"smem":10,"src":0,"srcPtr":11,"srcStep":1,"src_offset":2,"tileSize":6,"tilesX":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline int calc_lut(local int* smem, int val, int tid) {
  smem[hook(10, tid)] = val;
  barrier(0x01);

  if (tid == 0)
    for (int i = 1; i < 256; ++i)
      smem[hook(10, i)] += smem[hook(10, i - 1)];
  barrier(0x01);

  return smem[hook(10, tid)];
}
inline void reduce(local volatile int* smem, int val, int tid) {
  smem[hook(10, tid)] = val;
  barrier(0x01);

  if (tid < 128)
    smem[hook(10, tid)] = val += smem[hook(10, tid + 128)];
  barrier(0x01);

  if (tid < 64)
    smem[hook(10, tid)] = val += smem[hook(10, tid + 64)];
  barrier(0x01);

  if (tid < 32) {
    smem[hook(10, tid)] += smem[hook(10, tid + 32)];
  }
  barrier(0x01);

  if (tid < 16) {
    smem[hook(10, tid)] += smem[hook(10, tid + 16)];
  }
  barrier(0x01);

  if (tid < 8) {
    smem[hook(10, tid)] += smem[hook(10, tid + 8)];
    smem[hook(10, tid)] += smem[hook(10, tid + 4)];
    smem[hook(10, tid)] += smem[hook(10, tid + 2)];
    smem[hook(10, tid)] += smem[hook(10, tid + 1)];
  }
}

kernel void calcLut(global const uchar* src, const int srcStep, const int src_offset, global uchar* lut, const int dstStep, const int dst_offset, const int2 tileSize, const int tilesX, const int clipLimit, const float lutScale) {
  local int smem[512];

  int tx = get_group_id(0);
  int ty = get_group_id(1);
  int tid = get_local_id(1) * get_local_size(0) + get_local_id(0);
  smem[hook(10, tid)] = 0;
  barrier(0x01);

  for (int i = get_local_id(1); i < tileSize.y; i += get_local_size(1)) {
    global const uchar* srcPtr = src + mad24(ty * tileSize.y + i, srcStep, tx * tileSize.x + src_offset);
    for (int j = get_local_id(0); j < tileSize.x; j += get_local_size(0)) {
      const int data = srcPtr[hook(11, j)];
      atomic_inc(&smem[hook(10, data)]);
    }
  }
  barrier(0x01);

  int tHistVal = smem[hook(10, tid)];
  barrier(0x01);

  if (clipLimit > 0) {
    int clipped = 0;
    if (tHistVal > clipLimit) {
      clipped = tHistVal - clipLimit;
      tHistVal = clipLimit;
    }

    reduce(smem, clipped, tid);
    barrier(0x01);

    clipped = smem[hook(10, 0)];

    barrier(0x01);

    int redistBatch = clipped / 256;
    tHistVal += redistBatch;

    int residual = clipped - redistBatch * 256;
    int rStep = 256 / residual;
    if (rStep < 1)
      rStep = 1;
    if (tid % rStep == 0 && (tid / rStep) < residual)
      ++tHistVal;
  }

  const int lutVal = calc_lut(smem, tHistVal, tid);
  unsigned int ires = (unsigned int)convert_int_rte(lutScale * lutVal);
  lut[hook(3, (ty * tilesX + tx) * dstStep + tid + dst_offset)] = convert_uchar(clamp(ires, (unsigned int)0, (unsigned int)255));
}