//{"block_color":8,"c":9,"depth":3,"fov":5,"num_samples":7,"octree":2,"origin":1,"output":0,"seeds":6,"transform":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float3 cross_fp3(float3 a, float3 b) {
  return (float3)(a.y * b.z - a.z * b.y, a.z * b.x - a.x * b.z, a.x * b.y - a.y * b.x);
}

unsigned int intersect(global int* octree, unsigned int depth, float3* d, float3* o, float3* n) {
  int node;
  int level;
  int type = -1;

  int3 x;
  int3 l;
  float tNear = (__builtin_inff());
  float t;

  float3 rd = (float3)(1.f / (*d).x, 1.f / (*d).y, 1.f / (*d).z);

  while (1) {
    x = convert_int3(floor((*o) + (*d) * (.0005f)));

    node = 0;
    level = depth;
    l = x >> level;

    if (l.x != 0 || l.y != 0 || l.z != 0) {
      return 0;
    }

    type = octree[hook(2, node)];
    while (type == -1) {
      level -= 1;
      l = x >> level;
      node = octree[hook(2, node + 1 + (((l.x & 1) << 2) | ((l.y & 1) << 1) | (l.z & 1)))];
      type = octree[hook(2, node)];
    }

    if (type != 0) {
      return type;
    }

    t = ((l.x << level) - (*o).x) * rd.x;
    if (t > (.000001f)) {
      tNear = t;
      (*n) = (float3)(1, 0, 0);
    } else {
      t += (1 << level) * rd.x;
      if (t < tNear && t > (.000001f)) {
        tNear = t;
        (*n) = (float3)(-1, 0, 0);
      }
    }

    t = ((l.y << level) - (*o).y) * rd.y;
    if (t < tNear && t > (.000001f)) {
      tNear = t;
      (*n) = (float3)(0, 1, 0);
    } else {
      t += (1 << level) * rd.y;
      if (t < tNear && t > (.000001f)) {
        tNear = t;
        (*n) = (float3)(0, -1, 0);
      }
    }

    t = ((l.z << level) - (*o).z) * rd.z;
    if (t < tNear && t > (.000001f)) {
      tNear = t;
      (*n) = (float3)(0, 0, 1);
    } else {
      t += (1 << level) * rd.z;
      if (t < tNear && t > (.000001f)) {
        tNear = t;
        (*n) = (float3)(0, 0, -1);
      }
    }

    (*o) = (*d) * tNear + (*o);
    tNear = (__builtin_inff());
  }
}
unsigned int MWC64X(uint2* state) {
  enum { A = 4294883355U };
  unsigned int x = (*state).x, c = (*state).y;
  unsigned int res = x ^ c;
  unsigned int hi = mul_hi(x, A);
  x = x * A + c;
  c = hi + (x < c);
  *state = (uint2)(x, c);
  return res;
}

float rand_float(uint2* state) {
  return MWC64X(state) / (float)(0xFFFFFFFF);
}

void reflect(float3* o, float3* d, float3* n) {
  float x = dot(*d, *n);
  (*d) = (*d) - 2 * x * (*n);
  (*o) = mad((.0005f), *d, *o);
}

float3 get_sun_direction(float3* su, float3* sv, float3* sw, uint2* state) {
  float x1 = rand_float(state);
  float x2 = rand_float(state);
  float cos_a = 1 - x1 + x1 * (cos(.03f));
  float sin_a = sqrt(1 - cos_a * cos_a);
  float phi = 2 * (3.1415926535897932384626433832795f) * x2;

  float3 u = *su;
  float3 v = *sv;
  float3 w = *sw;

  u *= cos(phi) * sin_a;
  v *= sin(phi) * sin_a;
  w *= cos_a;

  return normalize(u + v + w);
}

void reflect_diffuse(float3* o, float3* d, float3* n, uint2* state) {
  float x1 = rand_float(state);
  float x2 = rand_float(state);
  float r = sqrt(x1);
  float theta = 2 * (3.1415926535897932384626433832795f) * x2;

  float3 t = (float3)(r * cos(theta), r * sin(theta), sqrt(1 - x1));

  float3 x;
  float3 u;
  float3 v;

  if (fabs((*n).x) > .1f) {
    x = (float3)(0, 1, 0);
  } else {
    x = (float3)(1, 0, 0);
  }

  u = normalize(cross_fp3(x, *n));
  v = cross_fp3(u, *n);

  (*d) = u * t.x + v * t.y + (*n) * t.z;

  (*o) = mad((.0005f), *d, *o);
}

unsigned int sample_to_rgb(float* c) {
  c[hook(9, 0)] = max(1.f, c[hook(9, 0)]);
  c[hook(9, 1)] = max(1.f, c[hook(9, 1)]);
  c[hook(9, 2)] = max(1.f, c[hook(9, 2)]);
  return (unsigned int)(0xFF << 24) | ((0xFF * (unsigned int)c[hook(9, 0)]) << 16) | ((0xFF * (unsigned int)c[hook(9, 1)]) << 8) | (0xFF * (unsigned int)c[hook(9, 2)]);
}

bool kill(unsigned int ray_depth, uint2* state) {
  return (ray_depth >= (3)) && (MWC64X(state) % 2);
}

kernel void path_trace(global float* output, global float3* origin, global int* octree, unsigned int depth, global float* transform, float fov, global uint2* seeds, unsigned int num_samples, global float* block_color) {
  unsigned int ix = get_global_id(0);
  unsigned int iy = get_global_id(1);
  unsigned int width = get_global_size(0);
  unsigned int height = get_global_size(1);
  unsigned int index = ix + iy * width;
  uint2 seed = seeds[hook(6, index)];

  float3 d;
  float3 o;
  float3 n;

  float3 t0 = (float3)(transform[hook(4, 0)], transform[hook(4, 1)], transform[hook(4, 2)]);
  float3 t1 = (float3)(transform[hook(4, 3)], transform[hook(4, 4)], transform[hook(4, 5)]);
  float3 t2 = (float3)(transform[hook(4, 6)], transform[hook(4, 7)], transform[hook(4, 8)]);

  float fov_tan = tanpi(fov / 360.f);

  float3 su, sv, sw;
  float theta = ((3.1415926535897932384626433832795f) / 2.5f);
  float phi = ((3.1415926535897932384626433832795f) / 3);

  sw.x = cos(theta);
  sw.y = sin(phi);
  sw.z = sin(theta);

  float r = sqrt(sw.x * sw.x + sw.z * sw.z);
  r = fabs(cos(phi) / r);

  sw.x *= r;
  sw.z *= r;

  if (fabs(sw.x) > .1f)
    su = (float3)(0, 1, 0);
  else
    su = (float3)(1, 0, 0);

  sv = normalize(cross_fp3(sw, su));
  su = cross_fp3(sv, sw);

  float sinv = 1.f / (num_samples + 1);

  float ox = 2 * rand_float(&seed);
  float oy = 2 * rand_float(&seed);
  ox = ox < 1 ? sqrt(ox) - 1 : 1 - sqrt(2 - ox);
  oy = oy < 1 ? sqrt(oy) - 1 : 1 - sqrt(2 - oy);
  d.x = fov_tan * (-.5f + (iy + oy) / height);
  d.y = -1;
  d.z = fov_tan * (.5f - (ix + ox) / width);

  d = normalize(d);

  d = (float3)(dot(d, t0), dot(d, t1), dot(d, t2));
  o = *origin;

  bool hit = false;
  unsigned int ray_depth = 0;
  float3 light = 0;
  float3 attenuation = 1;
  while (1) {
    float3 prev_o = o;
    float3 prev_n = n;

    unsigned int material = intersect(octree, depth, &d, &o, &n);

    float3 rd = get_sun_direction(&su, &sv, &sw, &seed);
    float3 ro = prev_o + rd * (.0005f);
    float3 rn = prev_n;

    if (!material) {
      if (hit && !intersect(octree, depth, &rd, &ro, &rn)) {
        float direct_light = dot(prev_n, rd);
        if (direct_light > 0) {
          light = (direct_light * (3) + (.4f)) * attenuation;
        }
      }
      break;
    }

    if (kill(ray_depth, &seed)) {
      hit = false;
      break;
    }

    ray_depth += 1;
    hit = true;

    unsigned int block = 0xFF & material;
    attenuation.x *= block_color[hook(8, block * 3)];
    attenuation.y *= block_color[hook(8, block * 3 + 1)];
    attenuation.z *= block_color[hook(8, block * 3 + 2)];

    reflect_diffuse(&o, &d, &n, &seed);
  }

  output[hook(0, index * 3)] = sinv * (output[hook(0, index * 3)] * num_samples + light.x);
  output[hook(0, index * 3 + 1)] = sinv * (output[hook(0, index * 3 + 1)] * num_samples + light.y);
  output[hook(0, index * 3 + 2)] = sinv * (output[hook(0, index * 3 + 2)] * num_samples + light.z);

  seeds[hook(6, index)] = seed;
}