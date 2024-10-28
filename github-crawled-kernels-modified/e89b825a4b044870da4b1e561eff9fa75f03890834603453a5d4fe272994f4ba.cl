//{"d_dst":1,"d_src":0,"height":3,"integerPitch":8,"localDst":11,"roiBottom":7,"roiLeft":4,"roiRight":6,"roiTop":5,"src":13,"threshold":12,"toCeiling":9,"toFloor":10,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float PitchedSubPixel(global uchar* src, int idx, float weightLeft, float weightRight) {
  return (float)src[hook(13, idx)] * weightLeft + (float)src[hook(13, idx + 1)] * weightRight;
}

float PixelDifference(float center, float east, float west) {
  float diff = (center * 2.0f - (east + west)) / 2.0f;
  return diff >= 0 ? diff : -diff;
}

kernel void pitch_threshold_0(global uchar* d_src, global uchar* d_dst, int width, int height, int roiLeft, int roiTop, int roiRight, int roiBottom, int integerPitch, float toCeiling, float toFloor, local uchar* localDst, uchar threshold) {
  int x = (roiLeft & (~0x07)) + get_global_id(0);
  int y = roiTop + get_global_id(1);
  int idx = x + y * width;

  bool isInBound = x >= roiLeft && x <= roiRight && y <= roiBottom;

  float east = 0.0f, west = 0.0f, diff = 0.0f;
  if (isInBound) {
    east = PitchedSubPixel(d_src, idx - integerPitch - 1, toCeiling, toFloor);
    west = PitchedSubPixel(d_src, idx + integerPitch, toFloor, toCeiling);
    diff = PixelDifference((float)d_src[hook(0, idx)], east, west);
  }

  uchar binary = ((uchar)(diff) < threshold) ? 0 : 1;

  int localX = get_local_id(0);
  int localIdx = get_local_id(1) * get_local_size(0) + localX;
  binary = binary << (7 - (localX & 0x07));
  localDst[hook(11, localIdx)] = binary;

  isInBound = x <= roiRight && y <= roiBottom;

  barrier(0x01);

  if (isInBound && (localX & 0x07) == 0) {
    uchar packed = localDst[hook(11, localIdx)] | localDst[hook(11, localIdx + 1)] | localDst[hook(11, localIdx + 2)] | localDst[hook(11, localIdx + 3)] | localDst[hook(11, localIdx + 4)] | localDst[hook(11, localIdx + 5)] | localDst[hook(11, localIdx + 6)] | localDst[hook(11, localIdx + 7)];

    d_dst[hook(1, idx >> 3)] = packed;
  }
}