//{"a":0,"b":1,"c":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
uint4 inc128(uint4 u) {
  int4 h = (u == (uint4)(0xFFFFFFFF));
  uint4 c = (uint4)(h.y & h.z & h.w & 1, h.z & h.w & 1, h.w & 1, 1);
  return u + c;
}

uint4 neg128(uint4 u) {
  return inc128(u ^ (uint4)(0xFFFFFFFF));
}

int greaterFixedPoint(uint4 a, uint4 b) {
  int aAndBAreNegative = 0;

  if (a.x > 0x7fffffffu && b.x <= 0x7fffffffu)
    return 10001;
  if (b.x > 0x7fffffffu && a.x <= 0x7fffffffu)
    return 10000;
  if (a.x == b.x && a.y == b.y && a.z == b.z && a.w == b.w)
    return 10002;

  uint4 ta, tb;
  ta.x = a.x;
  ta.y = a.y;
  ta.z = a.z;
  ta.w = a.w;
  tb.x = b.x;
  tb.y = b.y;
  tb.z = b.z;
  tb.w = b.w;
  if (b.x > 0x7fffffffu && a.x > 0x7fffffffu) {
    aAndBAreNegative = 1;
    ta = neg128(ta);
    tb = neg128(tb);
  }
  if (ta.x < tb.x) {
    if (aAndBAreNegative)
      return 10000;
    return 10001;
  } else if (ta.x > tb.x) {
    if (aAndBAreNegative)
      return 10001;
    return 10000;
  }

  else if (ta.y < tb.y) {
    if (aAndBAreNegative)
      return 10000;
    return 10001;
  } else if (ta.y > tb.y) {
    if (aAndBAreNegative)
      return 10001;
    return 10000;
  }

  else if (ta.z < tb.z) {
    if (aAndBAreNegative)
      return 10000;
    return 10001;
  } else if (ta.z > tb.z) {
    if (aAndBAreNegative)
      return 10001;
    return 10000;
  }

  else if (ta.w < tb.w) {
    if (aAndBAreNegative)
      return 10000;
    return 10001;
  } else {
    if (aAndBAreNegative)
      return 10001;
    return 10000;
  }
}

uint4 add128(uint4 u, uint4 v) {
  uint4 s = u + v;
  uint4 comp = (uint4)(0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF);
  int4 temp = (s < u);
  uint4 h = (uint4)(temp.x, temp.y, temp.z, temp.w);
  uint4 c1 = h.yzwx & (uint4)(1, 1, 1, 0);
  temp = (s == comp);
  h = (uint4)(temp.x, temp.y, temp.z, temp.w);
  uint4 c2 = (uint4)((c1.y | (c1.z & h.z)) & h.y, c1.z & h.z, 0, 0);
  return s + c1 + c2;
}

uint4 shl128(uint4 u) {
  uint4 h = (u >> (uint4)(31)) & (uint4)(0, 1, 1, 1);
  return (u << (uint4)(1)) | h.yzwx;
}

uint4 shr128(uint4 u) {
  uint4 h = (u << (uint4)(31)) & (uint4)(0x80000000, 0x80000000, 0x80000000, 0);
  return (u >> (uint4)(1)) | h.wxyz;
}

uint4 mul128u(uint4 u, unsigned int k) {
  uint4 s1 = u * (uint4)(k);
  uint4 s2 = (uint4)(mul_hi(u.y, k), mul_hi(u.z, k), mul_hi(u.w, k), 0);
  return add128(s1, s2);
}

uint4 mulfpu(uint4 u, uint4 v) {
  int negV = 0;
  if ((v.x >> 31) == 1) {
    negV = 1;
    v = neg128(v);
  }
  int negU = 0;
  if ((u.x >> 31) == 1) {
    negU = 1;
    u = neg128(u);
  }

  uint4 s = (uint4)(u.x * v.x, mul_hi(u.y, v.y), u.y * v.y, mul_hi(u.z, v.z));

  uint4 t1 = (uint4)(mul_hi(u.x, v.y), u.x * v.y, mul_hi(u.x, v.w), u.x * v.w);
  uint4 t2 = (uint4)(mul_hi(v.x, u.y), v.x * u.y, mul_hi(v.x, u.w), v.x * u.w);
  s = add128(s, add128(t1, t2));
  t1 = (uint4)(0, mul_hi(u.x, v.z), u.x * v.z, mul_hi(u.y, v.w));
  t2 = (uint4)(0, mul_hi(v.x, u.z), v.x * u.z, mul_hi(v.y, u.w));
  s = add128(s, add128(t1, t2));
  t1 = (uint4)(0, 0, mul_hi(u.y, v.z), u.y * v.z);
  t2 = (uint4)(0, 0, mul_hi(v.y, u.z), v.y * u.z);
  s = add128(s, add128(t1, t2));

  uint4 ret = s;

  uint4 a = (uint4)(0, 0, mul_hi(u.z, v.w), mul_hi(u.w, v.w));
  uint4 b = (uint4)(0, 0, mul_hi(u.w, v.z), u.z * v.w);
  uint4 c = (uint4)(0, 0, u.z * v.z, u.w * v.z);
  uint4 d = (uint4)(0, 0, u.w * v.y, 0);
  uint4 e = (uint4)(0, 0, u.y * v.w, 0);
  uint4 f = add128(a, b);
  f = add128(f, c);
  f = add128(f, d);
  f = add128(f, e);
  ret = add128(s, ((uint4)(0, 0, 0, f.y)));

  if (negV != negU) {
    if (f.y > 0 || f.z > 0 || f.w > 0)
      ret = add128(ret, (uint4)(0, 0, 0, 1));
    return neg128(ret);
  }

  return ret;
}

uint4 divfpu(uint4 u, uint4 v) {
  uint4 ret;
  if (v.x == 1u && v.y == 0u && v.z == 0u && v.w == 0u) {
    ret = u;
    return u;
  }

  int negV = 0;
  if ((v.x >> 31) == 1) {
    negV = 1;
    v = neg128(v);
  }

  unsigned int firstBitsBeforeOfThePointAtV = v.x;
  unsigned int first32BitsAfterOfThePointAtV = v.y;
  unsigned int v0Temp = 1;
  uint4 v0;
  if (v.x != 0u) {
    for (int i = 0; i < 32; i++) {
      if ((firstBitsBeforeOfThePointAtV & 1) == 1u) {
        v0Temp = 1u << (31 - i);
      }
      firstBitsBeforeOfThePointAtV = firstBitsBeforeOfThePointAtV >> 1;
    }
    v0 = (uint4)(0, v0Temp, 0, 0);

  } else {
    for (int i = 0; i < 32; i++) {
      if ((first32BitsAfterOfThePointAtV & 1) == 1u) {
        v0Temp = 1u << (31 - i);
      }
      first32BitsAfterOfThePointAtV = first32BitsAfterOfThePointAtV >> 1;
    }
    v0 = (uint4)(v0Temp, 0, 0, 0);
  }

  uint4 vPrev = v0;
  uint4 two = (uint4)(2, 0, 0, 0);
  int ite = 0;
  while (((vPrev.x != v0.x || vPrev.y != v0.y || vPrev.z != v0.z || vPrev.w != v0.w) && ite < 10) || ite == 0) {
    vPrev = v0;
    v0 = mulfpu(add128(two, neg128(mulfpu(v0, v))), v0);
    ite++;
  }
  if (negV == 1)
    v0 = neg128(v0);

  ret = mulfpu(u, v0);

  return ret;
}

uint4 sqrtfpu(uint4 x) {
  uint4 at = (uint4)(1, 0, 0, 0);
  int ite = 0;
  uint4 a = (uint4)(0, 0, 0, 0);
  uint4 ret = x;
  uint4 temp = (uint4)(1, 1, 1, 1);
  uint4 zero = (uint4)(0, 0, 0, 0);

  int underflowDetected = 0;

  if (x.x == 0 && x.y == 0) {
    underflowDetected = 1;

    x.x = 0;
    x.y = x.z;
    x.z = x.w;
    x.w = 0;
  }
  uint4 xneg = neg128(x);

  if (x.x == 0) {
    unsigned int x0 = 1;
    unsigned int first32BitsAfterOfThePointAtX = x.y;
    for (int i = 0; i < 32; i++) {
      if ((first32BitsAfterOfThePointAtX & 1u) == 1) {
        x0 = 1u << (32 - i);
      }

      first32BitsAfterOfThePointAtX = first32BitsAfterOfThePointAtX >> 1;
    }
    at.x = x0;
  }

  while ((temp.x != zero.x || temp.y != zero.y || temp.z != zero.z || temp.w != zero.w) && (at.x != zero.x || at.y != zero.y || at.z != zero.z || at.w != zero.w)) {
    uint4 att = add128(at, a);
    ret = mulfpu(x, att);
    temp = add128(mulfpu(ret, ret), xneg);

    if ((temp.x >> 31) == 1) {
      a = att;
    }

    at = shr128(at);

    ite++;
  }
  if (underflowDetected == 1) {
    uint4 transform = (uint4)(0, 0x10000, 0, 0);
    ret = mulfpu(ret, transform);
  }
  return ret;
}

kernel void test(global const uint4* a, global const uint4* b, global uint4* c) {
  c[hook(2, 0)] = sqrtfpu(a[hook(0, 0)]);
}