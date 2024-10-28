//{"dir":3,"passOfStage":2,"stage":1,"theArray":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void __attribute__((vec_type_hint(int4))) BitonicSort(global int4* theArray, const unsigned int stage, const unsigned int passOfStage, const unsigned int dir) {
  size_t i = get_global_id(0);
  int4 srcLeft, srcRight, mask;
  int4 imask10 = (int4)(0, 0, -1, -1);
  int4 imask11 = (int4)(0, -1, 0, -1);

  if (stage > 0) {
    if (passOfStage > 0) {
      size_t r = 1 << (passOfStage - 1);
      size_t lmask = r - 1;
      size_t left = ((i >> (passOfStage - 1)) << passOfStage) + (i & lmask);
      size_t right = left + r;

      srcLeft = theArray[hook(0, left)];
      srcRight = theArray[hook(0, right)];
      mask = srcLeft < srcRight;

      int4 imin = (srcLeft & mask) | (srcRight & ~mask);
      int4 imax = (srcLeft & ~mask) | (srcRight & mask);

      if (((i >> (stage - 1)) & 1) ^ dir) {
        theArray[hook(0, left)] = imin;
        theArray[hook(0, right)] = imax;
      } else {
        theArray[hook(0, right)] = imin;
        theArray[hook(0, left)] = imax;
      }
    } else {
      srcLeft = theArray[hook(0, i)];
      srcRight = srcLeft.zwxy;
      mask = (srcLeft < srcRight) ^ imask10;

      if (((i >> stage) & 1) ^ dir) {
        srcLeft = (srcLeft & mask) | (srcRight & ~mask);
        srcRight = srcLeft.yxwz;
        mask = (srcLeft < srcRight) ^ imask11;
        theArray[hook(0, i)] = (srcLeft & mask) | (srcRight & ~mask);
      } else {
        srcLeft = (srcLeft & ~mask) | (srcRight & mask);
        srcRight = srcLeft.yxwz;
        mask = (srcLeft < srcRight) ^ imask11;
        theArray[hook(0, i)] = (srcLeft & ~mask) | (srcRight & mask);
      }
    }
  } else {
    int4 imask0 = (int4)(0, -1, -1, 0);
    srcLeft = theArray[hook(0, i)];
    srcRight = srcLeft.yxwz;
    mask = (srcLeft < srcRight) ^ imask0;
    if (dir)
      srcLeft = (srcLeft & mask) | (srcRight & ~mask);
    else
      srcLeft = (srcLeft & ~mask) | (srcRight & mask);

    srcRight = srcLeft.zwxy;
    mask = (srcLeft < srcRight) ^ imask10;

    if ((i & 1) ^ dir) {
      srcLeft = (srcLeft & mask) | (srcRight & ~mask);
      srcRight = srcLeft.yxwz;
      mask = (srcLeft < srcRight) ^ imask11;
      theArray[hook(0, i)] = (srcLeft & mask) | (srcRight & ~mask);
    } else {
      srcLeft = (srcLeft & ~mask) | (srcRight & mask);
      srcRight = srcLeft.yxwz;
      mask = (srcLeft < srcRight) ^ imask11;
      theArray[hook(0, i)] = (srcLeft & ~mask) | (srcRight & mask);
    }
  }
}