//{"dst":2,"max_sugar":1,"s":3,"space":4,"sugar":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void transHSVtoRGB(float* dst, const float h, const float s, const float v) {
  if (0.f == s) {
    dst[hook(2, 0)] = dst[hook(2, 1)] = dst[hook(2, 2)] = v;
    return;
  }

  int Hi = (int)floor(h / 60.f) % 6;
  float f = h / 60.f - (float)Hi;
  float p = v * (1.f - s);
  float q = v * (1.f - s * f);
  float t = v * (1.f - (1.f - f) * s);

  if (Hi == 0) {
    dst[hook(2, 0)] = v, dst[hook(2, 1)] = t, dst[hook(2, 2)] = p;
  } else if (Hi == 1) {
    dst[hook(2, 0)] = q, dst[hook(2, 1)] = v, dst[hook(2, 2)] = p;
  } else if (Hi == 2) {
    dst[hook(2, 0)] = p, dst[hook(2, 1)] = v, dst[hook(2, 2)] = t;
  } else if (Hi == 3) {
    dst[hook(2, 0)] = p, dst[hook(2, 1)] = q, dst[hook(2, 2)] = v;
  } else if (Hi == 4) {
    dst[hook(2, 0)] = t, dst[hook(2, 1)] = p, dst[hook(2, 2)] = v;
  } else {
    dst[hook(2, 0)] = v, dst[hook(2, 1)] = p, dst[hook(2, 2)] = q;
  }
}

unsigned int randomi(unsigned int low, unsigned int high, global uint4* s) {
  const unsigned int gid = get_global_id(0);
  unsigned int t;
  uint4 seed = s[hook(3, gid)];
  t = (seed.x ^ (seed.x << 11));
  seed.x = seed.y;
  seed.y = seed.z;
  seed.z = seed.w;
  seed.w = (seed.w ^ (seed.w >> 19)) ^ (t ^ (t >> 8));
  s[hook(3, gid)] = seed;
  return low + (seed.w % (high - low));
}

int2 getTorus(int2 pos) {
  return (int2)((pos.x + (100)) % (100), (pos.y + (100)) % (100));
}

int getOneDimIdx(int2 pos) {
  int2 _pos = getTorus(pos);
  return _pos.x + (100) * _pos.y;
}

unsigned int moveOldPosToNewPos(int2 oldPos, int2 newPos, global int* space, int groupNum) {
  if ((-1) == atomic_cmpxchg(&space[hook(4, getOneDimIdx(newPos))], (-1), groupNum)) {
    atomic_xchg(&space[hook(4, getOneDimIdx(oldPos))], (-1));
    return 1;
  }
  return 0;
}

kernel void growupSpaceSugar(global int* sugar, global int* max_sugar) {
  const int2 xy = (int2)(get_global_id(0), get_global_id(1));
  const int point = getOneDimIdx(xy);

  if (sugar[hook(0, point)] < max_sugar[hook(1, point)]) {
    sugar[hook(0, point)] += 1;
  }
}