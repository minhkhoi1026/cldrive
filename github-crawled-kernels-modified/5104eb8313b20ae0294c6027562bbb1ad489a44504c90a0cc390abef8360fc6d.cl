//{"cols":9,"dst":3,"dstStep":4,"dst_offset":5,"lut":6,"lutStep":7,"lut_offset":8,"rows":10,"smem":14,"src":0,"srcStep":1,"src_offset":2,"tileSize":11,"tilesX":12,"tilesY":13}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline int calc_lut(local int* smem, int val, int tid) {
  smem[hook(14, tid)] = val;
  barrier(0x01);

  if (tid == 0)
    for (int i = 1; i < 256; ++i)
      smem[hook(14, i)] += smem[hook(14, i - 1)];
  barrier(0x01);

  return smem[hook(14, tid)];
}

inline int reduce(local volatile int* smem, int val, int tid) {
  smem[hook(14, tid)] = val;
  barrier(0x01);

  if (tid < 128)
    smem[hook(14, tid)] = val += smem[hook(14, tid + 128)];
  barrier(0x01);

  if (tid < 64)
    smem[hook(14, tid)] = val += smem[hook(14, tid + 64)];
  barrier(0x01);

  if (tid < 32) {
    smem[hook(14, tid)] += smem[hook(14, tid + 32)];
  }
  barrier(0x01);

  if (tid < 16) {
    smem[hook(14, tid)] += smem[hook(14, tid + 16)];
  }
  barrier(0x01);

  if (tid < 8) {
    smem[hook(14, tid)] += smem[hook(14, tid + 8)];
  }
  barrier(0x01);

  if (tid < 4) {
    smem[hook(14, tid)] += smem[hook(14, tid + 4)];
  }
  barrier(0x01);

  if (tid == 0) {
    smem[hook(14, 0)] = (smem[hook(14, 0)] + smem[hook(14, 1)]) + (smem[hook(14, 2)] + smem[hook(14, 3)]);
  }
  barrier(0x01);

  val = smem[hook(14, 0)];
  barrier(0x01);
  return val;
}

kernel void transform(global const uchar* src, const int srcStep, const int src_offset, global uchar* dst, const int dstStep, const int dst_offset, global uchar* lut, const int lutStep, int lut_offset, const int cols, const int rows, const int2 tileSize, const int tilesX, const int tilesY) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  if (x >= cols || y >= rows)
    return;

  const float tyf = (convert_float(y) / tileSize.y) - 0.5f;
  int ty1 = convert_int_rtn(tyf);
  int ty2 = ty1 + 1;
  const float ya = tyf - ty1;
  ty1 = max(ty1, 0);
  ty2 = min(ty2, tilesY - 1);

  const float txf = (convert_float(x) / tileSize.x) - 0.5f;
  int tx1 = convert_int_rtn(txf);
  int tx2 = tx1 + 1;
  const float xa = txf - tx1;
  tx1 = max(tx1, 0);
  tx2 = min(tx2, tilesX - 1);

  const int srcVal = src[hook(0, mad24(y, srcStep, x + src_offset))];

  float res = 0;

  res += lut[hook(6, mad24(ty1 * tilesX + tx1, lutStep, srcVal + lut_offset))] * ((1.0f - xa) * (1.0f - ya));
  res += lut[hook(6, mad24(ty1 * tilesX + tx2, lutStep, srcVal + lut_offset))] * ((xa) * (1.0f - ya));
  res += lut[hook(6, mad24(ty2 * tilesX + tx1, lutStep, srcVal + lut_offset))] * ((1.0f - xa) * (ya));
  res += lut[hook(6, mad24(ty2 * tilesX + tx2, lutStep, srcVal + lut_offset))] * ((xa) * (ya));

  unsigned int ires = (unsigned int)convert_int_rte(res);
  dst[hook(3, mad24(y, dstStep, x + dst_offset))] = convert_uchar(clamp(ires, (unsigned int)0, (unsigned int)255));
}