//{"chemical":1,"colorObj":0,"dst":5,"hsv_h":2,"max_value":4,"min_value":3,"rgb":7,"s":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void transHSVtoRGB(float* dst, const float h, const float s, const float v) {
  if (0.f == s) {
    dst[hook(5, 0)] = dst[hook(5, 1)] = dst[hook(5, 2)] = v;
    return;
  }

  int Hi = (int)floor(h / 60.f) % 6;
  float f = h / 60.f - (float)Hi;
  float p = v * (1.f - s);
  float q = v * (1.f - s * f);
  float t = v * (1.f - (1.f - f) * s);

  if (Hi == 0) {
    dst[hook(5, 0)] = v, dst[hook(5, 1)] = t, dst[hook(5, 2)] = p;
  } else if (Hi == 1) {
    dst[hook(5, 0)] = q, dst[hook(5, 1)] = v, dst[hook(5, 2)] = p;
  } else if (Hi == 2) {
    dst[hook(5, 0)] = p, dst[hook(5, 1)] = v, dst[hook(5, 2)] = t;
  } else if (Hi == 3) {
    dst[hook(5, 0)] = p, dst[hook(5, 1)] = q, dst[hook(5, 2)] = v;
  } else if (Hi == 4) {
    dst[hook(5, 0)] = t, dst[hook(5, 1)] = p, dst[hook(5, 2)] = v;
  } else {
    dst[hook(5, 0)] = v, dst[hook(5, 1)] = p, dst[hook(5, 2)] = q;
  }
}

float atomic_add_float(global float* const address, const float value) {
  unsigned int oldval, newval, readback;

  *(float*)&oldval = *address;
  *(float*)&newval = (*(float*)&oldval + value);
  while ((readback = atomic_cmpxchg((global unsigned int*)address, oldval, newval)) != oldval) {
    oldval = readback;
    *(float*)&newval = (*(float*)&oldval + value);
  }
  return *(float*)&oldval;
}

unsigned int randomi(unsigned int low, unsigned int high, global uint4* s) {
  const unsigned int gid = get_global_id(0);
  unsigned int t;
  uint4 seed = s[hook(6, gid)];
  t = (seed.x ^ (seed.x << 11));
  seed.x = seed.y;
  seed.y = seed.z;
  seed.z = seed.w;
  seed.w = (seed.w ^ (seed.w >> 19)) ^ (t ^ (t >> 8));
  s[hook(6, gid)] = seed;
  return low + (seed.w % (high - low));
}

int2 getTorus(int2 pos) {
  return (int2)((pos.x + (100)) % (100), (pos.y + (100)) % (100));
}

float2 getTorusFloat2(float2 pos) {
  float2 ret = pos;
  if (ret.x >= (100))
    ret.x -= (100);
  if (ret.y >= (100))
    ret.y -= (100);
  if (ret.x < 0)
    ret.x += (100);
  if (ret.y < 0)
    ret.y += (100);
  return ret;
}

int getOneDimIdx(int2 pos) {
  int2 _pos = getTorus(pos);
  return _pos.x + (100) * _pos.y;
}

float2 rotation(float2 coor, int angle) {
  float r = radians((float)angle);
  return (float2)(cos(r) * coor.x + -1.0f * sin(r) * coor.y, sin(r) * coor.x + cos(r) * coor.y);
}

kernel void writeSpaceColorObj(global float4* colorObj, global float* chemical, const float hsv_h, const float min_value, const float max_value) {
  const int gid = get_global_id(0) + (100) * get_global_id(1);
  float hsv_s, hsv_v;
  float rgb[3];

  float max_min = fabs(max_value - min_value);
  float spaceParam = chemical[hook(1, gid)] - min_value;

  spaceParam = min(spaceParam, max_value);
  spaceParam = max(spaceParam, min_value);

  float d = 2.0f / max_min;

  hsv_s = 2.f - spaceParam * d;
  hsv_s = min(hsv_s, 1.0f);

  hsv_v = spaceParam * d;
  hsv_v = min(hsv_v, 1.0f);

  transHSVtoRGB(rgb, hsv_h, hsv_s, hsv_v);

  colorObj[hook(0, 3 * gid + 0)] = (float4)(rgb[hook(7, 0)], rgb[hook(7, 1)], rgb[hook(7, 2)], rgb[hook(7, 0)]);
  colorObj[hook(0, 3 * gid + 1)] = (float4)(rgb[hook(7, 1)], rgb[hook(7, 2)], rgb[hook(7, 0)], rgb[hook(7, 1)]);
  colorObj[hook(0, 3 * gid + 2)] = (float4)(rgb[hook(7, 2)], rgb[hook(7, 0)], rgb[hook(7, 1)], rgb[hook(7, 2)]);
}