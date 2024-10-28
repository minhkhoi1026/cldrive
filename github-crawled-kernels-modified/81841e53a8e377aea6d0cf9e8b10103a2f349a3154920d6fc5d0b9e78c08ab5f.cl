//{"chemical":2,"directions":1,"dst":5,"positions":0,"s":6,"seed":3,"sniff_threshold":4}
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

kernel void moveIdealChemicalSpot(global float2* positions, global int* directions, global float* chemical, global uint4* seed, const float sniff_threshold) {
  int gid = get_global_id(0);

  float2 posf;
  int2 posi;
  int pos1d, angle;

  posf = positions[hook(0, gid)];
  angle = directions[hook(1, gid)];

  posi = (int2)(round(posf.x), round(posf.y));

  pos1d = getOneDimIdx(posi);

  if (chemical[hook(2, pos1d)] > sniff_threshold) {
    float ahead, myright, myleft;

    posi = (int2)(round(posf.x + cos(radians((float)angle))), round(posf.y + sin(radians((float)angle))));

    pos1d = getOneDimIdx(posi);
    ahead = chemical[hook(2, pos1d)];

    posi = (int2)(round(posf.x + cos(radians((float)angle + 45))), round(posf.y + sin(radians((float)angle + 45))));

    pos1d = getOneDimIdx(posi);
    myright = chemical[hook(2, pos1d)];

    posi = (int2)(round(posf.x + cos(radians((float)angle - 45))), round(posf.y + sin(radians((float)angle - 45))));

    pos1d = getOneDimIdx(posi);
    myleft = chemical[hook(2, pos1d)];

    if (myright >= ahead || myleft >= ahead) {
      if (myright >= myleft) {
        angle += 45;
      } else {
        angle -= 45;
      }
    }
  }

  angle += randomi(0, 41, seed) - randomi(0, 41, seed);

  angle = (angle + 360) % 360;

  posf += (float2)(cos(radians((float)angle)), sin(radians((float)angle)));

  posf = getTorusFloat2(posf);

  directions[hook(1, gid)] = angle;
  positions[hook(0, gid)] = posf;

  posi = (int2)(round(posf.x), round(posf.y));

  pos1d = getOneDimIdx(posi);
  atomic_add_float(&chemical[hook(2, pos1d)], 2.0f);
}