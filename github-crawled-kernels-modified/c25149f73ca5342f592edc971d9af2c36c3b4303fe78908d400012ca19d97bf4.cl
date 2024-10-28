//{"dst":3,"newStatus":2,"s":4,"seed":0,"status":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void transHSVtoRGB(float* dst, const float h, const float s, const float v) {
  if (0.f == s) {
    dst[hook(3, 0)] = dst[hook(3, 1)] = dst[hook(3, 2)] = v;
    return;
  }

  int Hi = (int)floor(h / 60.f) % 6;
  float f = h / 60.f - (float)Hi;
  float p = v * (1.f - s);
  float q = v * (1.f - s * f);
  float t = v * (1.f - (1.f - f) * s);

  if (Hi == 0) {
    dst[hook(3, 0)] = v, dst[hook(3, 1)] = t, dst[hook(3, 2)] = p;
  } else if (Hi == 1) {
    dst[hook(3, 0)] = q, dst[hook(3, 1)] = v, dst[hook(3, 2)] = p;
  } else if (Hi == 2) {
    dst[hook(3, 0)] = p, dst[hook(3, 1)] = v, dst[hook(3, 2)] = t;
  } else if (Hi == 3) {
    dst[hook(3, 0)] = p, dst[hook(3, 1)] = q, dst[hook(3, 2)] = v;
  } else if (Hi == 4) {
    dst[hook(3, 0)] = t, dst[hook(3, 1)] = p, dst[hook(3, 2)] = v;
  } else {
    dst[hook(3, 0)] = v, dst[hook(3, 1)] = p, dst[hook(3, 2)] = q;
  }
}

unsigned int randomi(unsigned int low, unsigned int high, global uint4* s) {
  const unsigned int gid = get_global_id(0) + (100) * get_global_id(1);
  unsigned int t;
  uint4 seed = s[hook(4, gid)];
  t = (seed.x ^ (seed.x << 11));
  seed.x = seed.y;
  seed.y = seed.z;
  seed.z = seed.w;
  seed.w = (seed.w ^ (seed.w >> 19)) ^ (t ^ (t >> 8));
  s[hook(4, gid)] = seed;
  return low + (seed.w % (high - low));
}

float randomf(global uint4* seed) {
  return (randomi(0, 10000000, seed) / 10000000.0f);
}

int2 getTorus(int2 pos) {
  return (int2)((pos.x + (100)) % (100), (pos.y + (100)) % (100));
}

int getOneDimIdx(int2 pos) {
  int2 _pos = getTorus(pos);
  return _pos.x + (100) * _pos.y;
}

kernel void updateCellStatus(global uint4* seed, global int* status, global int* newStatus) {
  const int2 pos = (int2)(get_global_id(0), get_global_id(1));
  const int offset = getOneDimIdx(pos);

  int myStatus = status[hook(1, offset)];

  if (myStatus == 0) {
    if (randomf(seed) < 0.1f) {
      myStatus = 1;
    }
  } else if (myStatus == 1) {
    if (randomf(seed) < 0.02f) {
      myStatus = 2;
    }
  } else if (myStatus == 2) {
    if (randomf(seed) < 0.02f) {
      myStatus = 3;
    }
  } else if (myStatus == 3) {
    int top = status[hook(1, getOneDimIdx(pos + (int2){-1, 0}))];
    int bottom = status[hook(1, getOneDimIdx(pos + (int2){1, 0}))];
    int left = status[hook(1, getOneDimIdx(pos + (int2){0, -1}))];
    int right = status[hook(1, getOneDimIdx(pos + (int2){0, 1}))];
    if (randomf(seed) < 0.0001f || ((top == 4 || bottom == 4 || left == 4 || right == 4) && randomf(seed) < 0.8f)) {
      myStatus = 4;
    }
  } else if (myStatus == 4) {
    if (randomf(seed) < 1.f) {
      myStatus = 5;
    }
  } else if (myStatus == 5) {
    if (randomf(seed) < 0.8f) {
      myStatus = 6;
    }
  } else if (myStatus == 6) {
    if (randomf(seed) < 0.8f) {
      myStatus = 0;
    }
  }

  newStatus[hook(2, offset)] = myStatus;
}