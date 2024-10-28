//{"<recovery-expr>(result)":8,"height":4,"result":7,"right_dir":2,"sample_x":5,"sample_y":6,"top_dir":1,"view_p":0,"width":3}
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

kernel void set_viewdirs(const float3 view_p, const float3 top_dir, const float3 right_dir, const float width, const float height, const int sample_x, const int sample_y, global unit_data* result) {
  int global_id_x = get_global_id(0);
  int global_id_y = get_global_id(1);

  if (global_id_x > sample_x || global_id_y > sample_y)
    return;

  float3 norm_dir = cross(top_dir, right_dir);
  norm_dir += top_dir * (convert_float(global_id_y) / convert_float(sample_y) * height - height * 0.5f);
  norm_dir += right_dir * (convert_float(global_id_x) / convert_float(sample_x) * width - width * 0.5f);

  int index = sample_x * global_id_y + global_id_x;
  result[hook(8, index)].in_dir = normalize(norm_dir);
  result[hook(8, index)].orig_id = index;
  result[hook(8, index)].strength = (float3)(1, 1, 1);
  result[hook(8, index)].start_p = view_p;
}