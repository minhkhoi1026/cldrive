//{"age":1,"death_flag":5,"dst":7,"max_age":2,"metabolism":3,"position":0,"s":8,"space":9,"space_sugar":6,"sugar":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void transHSVtoRGB(float* dst, const float h, const float s, const float v) {
  if (0.f == s) {
    dst[hook(7, 0)] = dst[hook(7, 1)] = dst[hook(7, 2)] = v;
    return;
  }

  int Hi = (int)floor(h / 60.f) % 6;
  float f = h / 60.f - (float)Hi;
  float p = v * (1.f - s);
  float q = v * (1.f - s * f);
  float t = v * (1.f - (1.f - f) * s);

  if (Hi == 0) {
    dst[hook(7, 0)] = v, dst[hook(7, 1)] = t, dst[hook(7, 2)] = p;
  } else if (Hi == 1) {
    dst[hook(7, 0)] = q, dst[hook(7, 1)] = v, dst[hook(7, 2)] = p;
  } else if (Hi == 2) {
    dst[hook(7, 0)] = p, dst[hook(7, 1)] = v, dst[hook(7, 2)] = t;
  } else if (Hi == 3) {
    dst[hook(7, 0)] = p, dst[hook(7, 1)] = q, dst[hook(7, 2)] = v;
  } else if (Hi == 4) {
    dst[hook(7, 0)] = t, dst[hook(7, 1)] = p, dst[hook(7, 2)] = v;
  } else {
    dst[hook(7, 0)] = v, dst[hook(7, 1)] = p, dst[hook(7, 2)] = q;
  }
}

unsigned int randomi(unsigned int low, unsigned int high, global uint4* s) {
  const unsigned int gid = get_global_id(0);
  unsigned int t;
  uint4 seed = s[hook(8, gid)];
  t = (seed.x ^ (seed.x << 11));
  seed.x = seed.y;
  seed.y = seed.z;
  seed.z = seed.w;
  seed.w = (seed.w ^ (seed.w >> 19)) ^ (t ^ (t >> 8));
  s[hook(8, gid)] = seed;
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
  if ((-1) == atomic_cmpxchg(&space[hook(9, getOneDimIdx(newPos))], (-1), groupNum)) {
    atomic_xchg(&space[hook(9, getOneDimIdx(oldPos))], (-1));
    return 1;
  }
  return 0;
}

kernel void updateAgentParameter(global int2* position, global int* age, global int* max_age, global int* metabolism, global int* sugar, global int* death_flag, global int* space_sugar) {
  const int gid = get_global_id(0);
  const int point = getOneDimIdx(position[hook(0, gid)]);

  int _age = age[hook(1, gid)];
  int _sugar = sugar[hook(4, gid)];

  _sugar += space_sugar[hook(6, point)];
  space_sugar[hook(6, point)] = 0;

  _sugar -= metabolism[hook(3, gid)];

  _age++;

  if (_age >= max_age[hook(2, gid)] || _sugar < 0) {
    death_flag[hook(5, gid)] = 1;
  } else {
    age[hook(1, gid)] = _age;
    sugar[hook(4, gid)] = _sugar;
  }
}