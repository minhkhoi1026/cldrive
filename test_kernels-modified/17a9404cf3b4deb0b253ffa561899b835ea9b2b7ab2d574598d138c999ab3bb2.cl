//{"<recovery-expr>(v_data)":8,"scene_points":6,"v_data":1,"v_lights":4,"v_lights_size":5,"v_s0":3,"v_s2_light":2,"v_seed":7,"v_sizes":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline void atomic_add_global(volatile global float* source, const float operand) {
  union {
    unsigned int intVal;
    float floatVal;
  } newVal;
  union {
    unsigned int intVal;
    float floatVal;
  } prevVal;

  do {
    prevVal.floatVal = *source;
    newVal.floatVal = prevVal.floatVal + operand;
  } while (atomic_cmpxchg((volatile global unsigned int*)source, prevVal.intVal, newVal.intVal) != prevVal.intVal);
}

inline long rand(long* seed) {
  *seed = ((*seed) * 0x5DEECE66DL + 0xBL) & ((1L << 48) - 1);
  return ((*seed) >> 16) & 0xFFFFFFFFL;
}

inline float randf(long* seed) {
  return convert_float(rand(seed)) / convert_float(0xFFFFFFFFL);
}

inline float3 randf3(long* seed) {
  float3 ret;
  float alpha = randf(seed) * 3.1415926535f;
  float beta = randf(seed) * 3.1415926535f;
  float cos_beta = cos(beta);
  ret.x = cos_beta * cos(alpha);
  ret.y = cos_beta * sin(alpha);
  ret.z = sin(beta);
  return ret;
}

inline float _box_intersect_dimension(float p0, float p, float s) {
  return (s - p0) / p;
}

bool _box_intersect(float3 box_start, float3 box_end, float3 start_p, float3 in_dir) {
  if (start_p.x >= box_start.x && start_p.x <= box_end.x && start_p.y >= box_start.y && start_p.y <= box_end.y && start_p.z >= box_start.z && start_p.z <= box_end.z)
    return true;
  float3 mins, maxs;

  float2 tmp;

  tmp.x = _box_intersect_dimension(start_p.x, in_dir.x, box_start.x);
  tmp.y = _box_intersect_dimension(start_p.x, in_dir.x, box_end.x);
  mins.s0 = fmin(tmp.x, tmp.y);
  maxs.s0 = fmax(tmp.x, tmp.y);
  tmp.x = _box_intersect_dimension(start_p.y, in_dir.y, box_start.y);
  tmp.y = _box_intersect_dimension(start_p.y, in_dir.y, box_end.y);
  mins.s1 = fmin(tmp.x, tmp.y);
  maxs.s1 = fmax(tmp.x, tmp.y);
  tmp.x = _box_intersect_dimension(start_p.z, in_dir.z, box_start.z);
  tmp.y = _box_intersect_dimension(start_p.z, in_dir.z, box_end.z);
  mins.s2 = fmin(tmp.x, tmp.y);
  maxs.s2 = fmax(tmp.x, tmp.y);

  float max_of_mins = fmax(fmax(mins.x, mins.y), mins.z);
  float min_of_maxs = fmin(fmin(maxs.x, maxs.y), maxs.z);

  if (min_of_maxs <= 0)
    return false;
  return max_of_mins <= min_of_maxs;
}

float _single_intersect(float3 start_p, float3 in_dir, float3 pa, float3 pb, float3 pc) {
  float3 e1 = pb - pa;
  float3 e2 = pc - pa;
  float3 P = cross(in_dir, e2);
  float det = dot(e1, P);
  if (det > 1e-3f && det < 1e-3f)
    return -1;

  float inv_det = 1.f / det;
  float3 T = start_p - pa;
  float u = dot(T, P) * inv_det;
  if (u < 0.f || u > 1.f)
    return -1;

  float3 Q = cross(T, e1);
  float v = dot(in_dir, Q) * inv_det;
  if (v < 0.f || u + v > 1.f)
    return -1;

  float t = dot(e2, Q) * inv_det;
  if (t > 0)
    return t;

  return -1;
}

constant sampler_t sampler =

    1 | 6 | 0x20;

kernel void s2_light_run(global int* v_sizes, global unit_data* v_data, global int* v_s2_light, global int* v_s0, global int4* v_lights, const int v_lights_size, global float3* scene_points, global long* v_seed) {
  int global_id = get_global_id(0);
  if (global_id >= v_sizes[hook(0, 5)])
    return;
  if (v_lights_size == 0)
    return;

  int this_id = v_s2_light[hook(2, global_id)];
  unit_data s2 = v_data[this_id];

  bool dir = dot(s2.in_dir, s2.normal) < 0;

  long rand_seed = v_seed[hook(7, global_id)] + global_id;

  int rand_light_index = rand(&rand_seed) % v_lights_size;
  int4 light = v_lights[hook(4, rand_light_index)];

  float3 pa = scene_points[hook(6, light.x)];
  float3 pb = scene_points[hook(6, light.y)];
  float3 pc = scene_points[hook(6, light.z)];

  float randx = randf(&rand_seed);
  float randy = randf(&rand_seed);
  if (randx + randy > 1) {
    randx = 1 - randx;
    randy = 1 - randy;
  }
  float3 point = pa + randx * (pb - pa) + randy * (pc - pa);
  float3 p = normalize(point - s2.intersect_p);

  float dot_ = dot(p, s2.normal);
  if ((dot_ > 0) == dir) {
    int index = atomic_inc(v_sizes + 0);

    v_s0[hook(3, index)] = this_id;
    v_data[hook(8, this_id)].strength = s2.strength * fabs(dot_);
    v_data[hook(8, this_id)].start_p = s2.intersect_p + 1e-5f * p;
    v_data[hook(8, this_id)].in_dir = p;
  }
  v_seed[hook(7, global_id)] = rand_seed;
}