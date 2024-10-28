//{"dir":4,"keyArray":0,"numWorkItems":5,"passOfStage":3,"stage":2,"valueArray":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void __attribute__((vec_type_hint(uint4))) BitonicSort(global uint4* keyArray, global uint4* valueArray, const unsigned int stage, const unsigned int passOfStage, const unsigned int dir, const unsigned int numWorkItems) {
  unsigned int i = get_global_id(0);

  if (i >= numWorkItems)
    return;

  uint4 srcLeft, srcRight;
  uint4 mask;
  uint4 srcValueLeft, srcValueRight;

  uint4 imask10 = (uint4)(0, 0, 0xFFFFFFFF, 0xFFFFFFFF);
  uint4 imask11 = (uint4)(0, 0xFFFFFFFF, 0, 0xFFFFFFFF);

  if (stage > 0) {
    if (passOfStage > 0) {
      unsigned int r = 1 << (passOfStage - 1);
      unsigned int lmask = r - 1;
      unsigned int left = ((i >> (passOfStage - 1)) << passOfStage) + (i & lmask);
      unsigned int right = left + r;

      srcLeft = keyArray[hook(0, left)];
      srcRight = keyArray[hook(0, right)];
      srcValueLeft = valueArray[hook(1, left)];
      srcValueRight = valueArray[hook(1, right)];
      mask = __builtin_astype((srcLeft < srcRight), uint4);

      uint4 imin = (srcLeft & mask) | (srcRight & ~mask);
      uint4 imax = (srcLeft & ~mask) | (srcRight & mask);
      uint4 vmin = (srcValueLeft & mask) | (srcValueRight & ~mask);
      uint4 vmax = (srcValueLeft & ~mask) | (srcValueRight & mask);

      if (((i >> (stage - 1)) & 1) ^ dir) {
        keyArray[hook(0, left)] = imin;
        keyArray[hook(0, right)] = imax;
        valueArray[hook(1, left)] = vmin;
        valueArray[hook(1, right)] = vmax;
      } else {
        keyArray[hook(0, right)] = imin;
        keyArray[hook(0, left)] = imax;
        valueArray[hook(1, right)] = vmin;
        valueArray[hook(1, left)] = vmax;
      }
    } else {
      srcLeft = keyArray[hook(0, i)];
      srcRight = srcLeft.zwxy;
      srcValueLeft = valueArray[hook(1, i)];
      srcValueRight = srcValueLeft.zwxy;

      mask = __builtin_astype((srcLeft < srcRight), uint4);
      mask = mask.xyxy;

      if (((i >> stage) & 1) ^ dir) {
        srcLeft = (srcLeft & mask) | (srcRight & ~mask);
        srcRight = srcLeft.yxwz;
        srcValueLeft = (srcValueLeft & mask) | (srcValueRight & ~mask);
        srcValueRight = srcValueLeft.yxwz;

        mask = __builtin_astype((srcLeft < srcRight), uint4);
        mask = mask.xxzz;

        keyArray[hook(0, i)] = (srcLeft & mask) | (srcRight & ~mask);
        valueArray[hook(1, i)] = (srcValueLeft & mask) | (srcValueRight & ~mask);
      } else {
        srcLeft = (srcLeft & ~mask) | (srcRight & mask);
        srcRight = srcLeft.yxwz;
        srcValueLeft = (srcValueLeft & ~mask) | (srcValueRight & mask);
        srcValueRight = srcValueLeft.yxwz;

        mask = __builtin_astype((srcLeft < srcRight), uint4);
        mask = mask.xxzz;

        keyArray[hook(0, i)] = (srcLeft & ~mask) | (srcRight & mask);
        valueArray[hook(1, i)] = (srcValueLeft & ~mask) | (srcValueRight & mask);
      }
    }
  } else {
    uint4 imask0 = (uint4)(0, 0xFFFFFFFF, 0xFFFFFFFF, 0);
    srcLeft = keyArray[hook(0, i)];
    srcRight = srcLeft.yxwz;
    srcValueLeft = valueArray[hook(1, i)];
    srcValueRight = srcValueLeft.yxwz;

    mask = __builtin_astype((srcLeft < srcRight), uint4);
    mask = mask.xxww;
    if (dir) {
      srcLeft = (srcLeft & mask) | (srcRight & ~mask);
      srcValueLeft = (srcValueLeft & mask) | (srcValueRight & ~mask);
    } else {
      srcLeft = (srcLeft & ~mask) | (srcRight & mask);
      srcValueLeft = (srcValueLeft & ~mask) | (srcValueRight & mask);
    }

    srcRight = srcLeft.zwxy;
    srcValueRight = srcValueLeft.zwxy;

    mask = __builtin_astype((srcLeft < srcRight), uint4);
    mask = mask.xyxy;

    if ((i & 1) ^ dir) {
      srcLeft = (srcLeft & mask) | (srcRight & ~mask);
      srcRight = srcLeft.yxwz;
      srcValueLeft = (srcValueLeft & mask) | (srcValueRight & ~mask);
      srcValueRight = srcValueLeft.yxwz;

      mask = __builtin_astype((srcLeft < srcRight), uint4);
      mask = mask.xxzz;

      keyArray[hook(0, i)] = (srcLeft & mask) | (srcRight & ~mask);
      valueArray[hook(1, i)] = (srcValueLeft & mask) | (srcValueRight & ~mask);
    } else {
      srcLeft = (srcLeft & ~mask) | (srcRight & mask);
      srcRight = srcLeft.yxwz;
      srcValueLeft = (srcValueLeft & ~mask) | (srcValueRight & mask);
      srcValueRight = srcValueLeft.yxwz;

      mask = __builtin_astype((srcLeft < srcRight), uint4);
      mask = mask.xxzz;

      keyArray[hook(0, i)] = (srcLeft & ~mask) | (srcRight & mask);
      valueArray[hook(1, i)] = (srcValueLeft & ~mask) | (srcValueRight & mask);
    }
  }
}