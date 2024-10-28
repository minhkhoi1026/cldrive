//{"colorObj":0,"dst":6,"flagInverse":5,"hsv_h":2,"max_value":4,"min_value":3,"rgb":9,"s":7,"space":8,"sugar":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void transHSVtoRGB(float* dst, const float h, const float s, const float v) {
  if (0.f == s) {
    dst[hook(6, 0)] = dst[hook(6, 1)] = dst[hook(6, 2)] = v;
    return;
  }

  int Hi = (int)floor(h / 60.f) % 6;
  float f = h / 60.f - (float)Hi;
  float p = v * (1.f - s);
  float q = v * (1.f - s * f);
  float t = v * (1.f - (1.f - f) * s);

  if (Hi == 0) {
    dst[hook(6, 0)] = v, dst[hook(6, 1)] = t, dst[hook(6, 2)] = p;
  } else if (Hi == 1) {
    dst[hook(6, 0)] = q, dst[hook(6, 1)] = v, dst[hook(6, 2)] = p;
  } else if (Hi == 2) {
    dst[hook(6, 0)] = p, dst[hook(6, 1)] = v, dst[hook(6, 2)] = t;
  } else if (Hi == 3) {
    dst[hook(6, 0)] = p, dst[hook(6, 1)] = q, dst[hook(6, 2)] = v;
  } else if (Hi == 4) {
    dst[hook(6, 0)] = t, dst[hook(6, 1)] = p, dst[hook(6, 2)] = v;
  } else {
    dst[hook(6, 0)] = v, dst[hook(6, 1)] = p, dst[hook(6, 2)] = q;
  }
}

unsigned int randomi(unsigned int low, unsigned int high, global uint4* s) {
  const unsigned int gid = get_global_id(0);
  unsigned int t;
  uint4 seed = s[hook(7, gid)];
  t = (seed.x ^ (seed.x << 11));
  seed.x = seed.y;
  seed.y = seed.z;
  seed.z = seed.w;
  seed.w = (seed.w ^ (seed.w >> 19)) ^ (t ^ (t >> 8));
  s[hook(7, gid)] = seed;
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
  if ((-1) == atomic_cmpxchg(&space[hook(8, getOneDimIdx(newPos))], (-1), groupNum)) {
    atomic_xchg(&space[hook(8, getOneDimIdx(oldPos))], (-1));
    return 1;
  }
  return 0;
}

kernel void writeSpaceColorObj(global float4* colorObj, global int* sugar, const float hsv_h, const float min_value, const float max_value, const unsigned int flagInverse) {
  const int gid = get_global_id(0) + (100) * get_global_id(1);
  float hsv_s, hsv_v;
  float rgb[3];

  float max_min = fabs(max_value - min_value);
  float spaceParam = (float)sugar[hook(1, gid)] - min_value;

  spaceParam = min(spaceParam, max_value);
  spaceParam = max(spaceParam, min_value);

  float d = 2.0f / max_min;

  hsv_s = 2.f - spaceParam * d;
  hsv_s = min(hsv_s, 1.0f);

  hsv_v = spaceParam * d;
  hsv_v = min(hsv_v, 1.0f);

  if (flagInverse) {
    float tmp = hsv_s;
    hsv_s = hsv_v;
    hsv_v = tmp;
  }

  transHSVtoRGB(rgb, hsv_h, hsv_s, hsv_v);

  colorObj[hook(0, 3 * gid + 0)] = (float4)(rgb[hook(9, 0)], rgb[hook(9, 1)], rgb[hook(9, 2)], rgb[hook(9, 0)]);
  colorObj[hook(0, 3 * gid + 1)] = (float4)(rgb[hook(9, 1)], rgb[hook(9, 2)], rgb[hook(9, 0)], rgb[hook(9, 1)]);
  colorObj[hook(0, 3 * gid + 2)] = (float4)(rgb[hook(9, 2)], rgb[hook(9, 0)], rgb[hook(9, 1)], rgb[hook(9, 2)]);
}