//{"age":1,"death_flag":6,"dst":9,"max_age":2,"metabolism":4,"position":0,"s":10,"seed":8,"space":7,"sugar":5,"vision":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void transHSVtoRGB(float* dst, const float h, const float s, const float v) {
  if (0.f == s) {
    dst[hook(9, 0)] = dst[hook(9, 1)] = dst[hook(9, 2)] = v;
    return;
  }

  int Hi = (int)floor(h / 60.f) % 6;
  float f = h / 60.f - (float)Hi;
  float p = v * (1.f - s);
  float q = v * (1.f - s * f);
  float t = v * (1.f - (1.f - f) * s);

  if (Hi == 0) {
    dst[hook(9, 0)] = v, dst[hook(9, 1)] = t, dst[hook(9, 2)] = p;
  } else if (Hi == 1) {
    dst[hook(9, 0)] = q, dst[hook(9, 1)] = v, dst[hook(9, 2)] = p;
  } else if (Hi == 2) {
    dst[hook(9, 0)] = p, dst[hook(9, 1)] = v, dst[hook(9, 2)] = t;
  } else if (Hi == 3) {
    dst[hook(9, 0)] = p, dst[hook(9, 1)] = q, dst[hook(9, 2)] = v;
  } else if (Hi == 4) {
    dst[hook(9, 0)] = t, dst[hook(9, 1)] = p, dst[hook(9, 2)] = v;
  } else {
    dst[hook(9, 0)] = v, dst[hook(9, 1)] = p, dst[hook(9, 2)] = q;
  }
}

unsigned int randomi(unsigned int low, unsigned int high, global uint4* s) {
  const unsigned int gid = get_global_id(0);
  unsigned int t;
  uint4 seed = s[hook(10, gid)];
  t = (seed.x ^ (seed.x << 11));
  seed.x = seed.y;
  seed.y = seed.z;
  seed.z = seed.w;
  seed.w = (seed.w ^ (seed.w >> 19)) ^ (t ^ (t >> 8));
  s[hook(10, gid)] = seed;
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
  if ((-1) == atomic_cmpxchg(&space[hook(7, getOneDimIdx(newPos))], (-1), groupNum)) {
    atomic_xchg(&space[hook(7, getOneDimIdx(oldPos))], (-1));
    return 1;
  }
  return 0;
}

kernel void generateNewAgent(global int2* position, global int* age, global int* max_age, global int* vision, global int* metabolism, global int* sugar, global int* death_flag, global int* space, global uint4* seed) {
  const int gid = get_global_id(0);

  if (!death_flag[hook(6, gid)]) {
    return;
  }

  int2 pos = position[hook(0, gid)];

  while (1) {
    int _x = randomi(0, (100), seed);
    int _y = randomi(0, (100), seed);
    int2 newPos = getTorus(pos + (int2)(_x, _y));
    if (moveOldPosToNewPos(pos, newPos, space, 0)) {
      position[hook(0, gid)] = newPos;
      break;
    }
  }

  age[hook(1, gid)] = 0;
  max_age[hook(2, gid)] = randomi(60, 100 + 1, seed);
  vision[hook(3, gid)] = randomi(1, 6 + 1, seed);
  metabolism[hook(4, gid)] = randomi(1, 4 + 1, seed);
  sugar[hook(5, gid)] = randomi(5, 25 + 1, seed);
  death_flag[hook(6, gid)] = 0;
}