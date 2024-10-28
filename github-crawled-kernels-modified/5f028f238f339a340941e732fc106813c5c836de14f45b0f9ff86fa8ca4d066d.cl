//{"dest":2,"secondSource":0,"source":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sample_test(global uint2* secondSource, global uint2* source, global uint4* dest) {
  if (get_global_id(0) != 0)
    return;

  uint4 tmp;
  tmp = (uint4)((unsigned int)0);
  {
    uint2 src1 = source[hook(1, 0)];
    uint2 src2 = secondSource[hook(0, 0)];
    uint4 mask = (uint4)(2, 2, 3, 3);
    tmp = shuffle2(src1, src2, mask);
    dest[hook(2, 0)] = tmp;
  }
  tmp = (uint4)((unsigned int)0);
  {
    uint2 src1 = source[hook(1, 1)];
    uint2 src2 = secondSource[hook(0, 1)];
    uint4 mask = (uint4)(3, 0, 2, 3);
    tmp = shuffle2(src1, src2, mask);
    dest[hook(2, 1)] = tmp;
  }
  tmp = (uint4)((unsigned int)0);
  {
    uint2 src1 = source[hook(1, 2)];
    uint2 src2 = secondSource[hook(0, 2)];
    uint4 mask = (uint4)(2, 3, 0, 1);
    tmp = shuffle2(src1, src2, mask);
    dest[hook(2, 2)] = tmp;
  }
  tmp = (uint4)((unsigned int)0);
  {
    uint2 src1 = source[hook(1, 3)];
    uint2 src2 = secondSource[hook(0, 3)];
    uint4 mask = (uint4)(3, 3, 1, 0);
    tmp = shuffle2(src1, src2, mask);
    dest[hook(2, 3)] = tmp;
  }
  tmp = (uint4)((unsigned int)0);
  {
    uint2 src1 = source[hook(1, 4)];
    uint2 src2 = secondSource[hook(0, 4)];
    uint4 mask = (uint4)(2, 2, 2, 3);
    tmp = shuffle2(src1, src2, mask);
    dest[hook(2, 4)] = tmp;
  }
  tmp = (uint4)((unsigned int)0);
  {
    uint2 src1 = source[hook(1, 5)];
    uint2 src2 = secondSource[hook(0, 5)];
    uint4 mask = (uint4)(2, 2, 3, 3);
    tmp = shuffle2(src1, src2, mask);
    dest[hook(2, 5)] = tmp;
  }
  tmp = (uint4)((unsigned int)0);
  {
    uint2 src1 = source[hook(1, 6)];
    uint2 src2 = secondSource[hook(0, 6)];
    uint4 mask = (uint4)(1, 3, 3, 2);
    tmp = shuffle2(src1, src2, mask);
    dest[hook(2, 6)] = tmp;
  }
  tmp = (uint4)((unsigned int)0);
  {
    uint2 src1 = source[hook(1, 7)];
    uint2 src2 = secondSource[hook(0, 7)];
    uint4 mask = (uint4)(3, 2, 1, 1);
    tmp = shuffle2(src1, src2, mask);
    dest[hook(2, 7)] = tmp;
  }
  tmp = (uint4)((unsigned int)0);
  {
    uint2 src1 = source[hook(1, 8)];
    uint2 src2 = secondSource[hook(0, 8)];
    uint4 mask = (uint4)(3, 3, 0, 3);
    tmp = shuffle2(src1, src2, mask);
    dest[hook(2, 8)] = tmp;
  }
  tmp = (uint4)((unsigned int)0);
  {
    uint2 src1 = source[hook(1, 9)];
    uint2 src2 = secondSource[hook(0, 9)];
    uint4 mask = (uint4)(3, 2, 0, 0);
    tmp = shuffle2(src1, src2, mask);
    dest[hook(2, 9)] = tmp;
  }
  tmp = (uint4)((unsigned int)0);
  {
    uint2 src1 = source[hook(1, 10)];
    uint2 src2 = secondSource[hook(0, 10)];
    uint4 mask = (uint4)(0, 0, 1, 1);
    tmp = shuffle2(src1, src2, mask);
    dest[hook(2, 10)] = tmp;
  }
  tmp = (uint4)((unsigned int)0);
  {
    uint2 src1 = source[hook(1, 11)];
    uint2 src2 = secondSource[hook(0, 11)];
    uint4 mask = (uint4)(3, 2, 1, 2);
    tmp = shuffle2(src1, src2, mask);
    dest[hook(2, 11)] = tmp;
  }
  tmp = (uint4)((unsigned int)0);
  {
    uint2 src1 = source[hook(1, 12)];
    uint2 src2 = secondSource[hook(0, 12)];
    uint4 mask = (uint4)(1, 1, 0, 0);
    tmp = shuffle2(src1, src2, mask);
    dest[hook(2, 12)] = tmp;
  }
  tmp = (uint4)((unsigned int)0);
  {
    uint2 src1 = source[hook(1, 13)];
    uint2 src2 = secondSource[hook(0, 13)];
    uint4 mask = (uint4)(2, 0, 2, 3);
    tmp = shuffle2(src1, src2, mask);
    dest[hook(2, 13)] = tmp;
  }
  tmp = (uint4)((unsigned int)0);
  {
    uint2 src1 = source[hook(1, 14)];
    uint2 src2 = secondSource[hook(0, 14)];
    uint4 mask = (uint4)(0, 0, 0, 3);
    tmp = shuffle2(src1, src2, mask);
    dest[hook(2, 14)] = tmp;
  }
  tmp = (uint4)((unsigned int)0);
  {
    uint2 src1 = source[hook(1, 15)];
    uint2 src2 = secondSource[hook(0, 15)];
    uint4 mask = (uint4)(0, 2, 0, 1);
    tmp = shuffle2(src1, src2, mask);
    dest[hook(2, 15)] = tmp;
  }
  tmp = (uint4)((unsigned int)0);
  {
    uint2 src1 = source[hook(1, 16)];
    uint2 src2 = secondSource[hook(0, 16)];
    uint4 mask = (uint4)(0, 3, 2, 0);
    tmp = shuffle2(src1, src2, mask);
    dest[hook(2, 16)] = tmp;
  }
  tmp = (uint4)((unsigned int)0);
  {
    uint2 src1 = source[hook(1, 17)];
    uint2 src2 = secondSource[hook(0, 17)];
    uint4 mask = (uint4)(0, 1, 2, 0);
    tmp = shuffle2(src1, src2, mask);
    dest[hook(2, 17)] = tmp;
  }
  tmp = (uint4)((unsigned int)0);
  {
    uint2 src1 = source[hook(1, 18)];
    uint2 src2 = secondSource[hook(0, 18)];
    uint4 mask = (uint4)(1, 2, 3, 2);
    tmp = shuffle2(src1, src2, mask);
    dest[hook(2, 18)] = tmp;
  }
  tmp = (uint4)((unsigned int)0);
  {
    uint2 src1 = source[hook(1, 19)];
    uint2 src2 = secondSource[hook(0, 19)];
    uint4 mask = (uint4)(3, 2, 2, 0);
    tmp = shuffle2(src1, src2, mask);
    dest[hook(2, 19)] = tmp;
  }
  tmp = (uint4)((unsigned int)0);
  {
    uint2 src1 = source[hook(1, 20)];
    uint2 src2 = secondSource[hook(0, 20)];
    uint4 mask = (uint4)(0, 3, 3, 3);
    tmp = shuffle2(src1, src2, mask);
    dest[hook(2, 20)] = tmp;
  }
  tmp = (uint4)((unsigned int)0);
  {
    uint2 src1 = source[hook(1, 21)];
    uint2 src2 = secondSource[hook(0, 21)];
    uint4 mask = (uint4)(2, 3, 0, 0);
    tmp = shuffle2(src1, src2, mask);
    dest[hook(2, 21)] = tmp;
  }
  tmp = (uint4)((unsigned int)0);
  {
    uint2 src1 = source[hook(1, 22)];
    uint2 src2 = secondSource[hook(0, 22)];
    uint4 mask = (uint4)(0, 0, 2, 0);
    tmp = shuffle2(src1, src2, mask);
    dest[hook(2, 22)] = tmp;
  }
  tmp = (uint4)((unsigned int)0);
  {
    uint2 src1 = source[hook(1, 23)];
    uint2 src2 = secondSource[hook(0, 23)];
    uint4 mask = (uint4)(2, 2, 0, 2);
    tmp = shuffle2(src1, src2, mask);
    dest[hook(2, 23)] = tmp;
  }
  tmp = (uint4)((unsigned int)0);
  {
    uint2 src1 = source[hook(1, 24)];
    uint2 src2 = secondSource[hook(0, 24)];
    uint4 mask = (uint4)(1, 1, 1, 1);
    tmp = shuffle2(src1, src2, mask);
    dest[hook(2, 24)] = tmp;
  }
  tmp = (uint4)((unsigned int)0);
  {
    uint2 src1 = source[hook(1, 25)];
    uint2 src2 = secondSource[hook(0, 25)];
    uint4 mask = (uint4)(0, 1, 2, 3);
    tmp = shuffle2(src1, src2, mask);
    dest[hook(2, 25)] = tmp;
  }
  tmp = (uint4)((unsigned int)0);
  {
    uint2 src1 = source[hook(1, 26)];
    uint2 src2 = secondSource[hook(0, 26)];
    uint4 mask = (uint4)(3, 1, 2, 0);
    tmp = shuffle2(src1, src2, mask);
    dest[hook(2, 26)] = tmp;
  }
  tmp = (uint4)((unsigned int)0);
  {
    uint2 src1 = source[hook(1, 27)];
    uint2 src2 = secondSource[hook(0, 27)];
    uint4 mask = (uint4)(2, 3, 1, 1);
    tmp = shuffle2(src1, src2, mask);
    dest[hook(2, 27)] = tmp;
  }
  tmp = (uint4)((unsigned int)0);
  {
    uint2 src1 = source[hook(1, 28)];
    uint2 src2 = secondSource[hook(0, 28)];
    uint4 mask = (uint4)(2, 0, 0, 2);
    tmp = shuffle2(src1, src2, mask);
    dest[hook(2, 28)] = tmp;
  }
  tmp = (uint4)((unsigned int)0);
  {
    uint2 src1 = source[hook(1, 29)];
    uint2 src2 = secondSource[hook(0, 29)];
    uint4 mask = (uint4)(1, 2, 3, 2);
    tmp = shuffle2(src1, src2, mask);
    dest[hook(2, 29)] = tmp;
  }
  tmp = (uint4)((unsigned int)0);
  {
    uint2 src1 = source[hook(1, 30)];
    uint2 src2 = secondSource[hook(0, 30)];
    uint4 mask = (uint4)(1, 0, 0, 2);
    tmp = shuffle2(src1, src2, mask);
    dest[hook(2, 30)] = tmp;
  }
  tmp = (uint4)((unsigned int)0);
  {
    uint2 src1 = source[hook(1, 31)];
    uint2 src2 = secondSource[hook(0, 31)];
    uint4 mask = (uint4)(0, 1, 1, 0);
    tmp = shuffle2(src1, src2, mask);
    dest[hook(2, 31)] = tmp;
  }
}