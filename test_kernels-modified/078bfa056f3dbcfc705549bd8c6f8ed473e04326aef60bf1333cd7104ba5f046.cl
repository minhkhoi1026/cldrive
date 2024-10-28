//{"<recovery-expr>(v_data)":7,"scene_mesh":5,"scene_mesh_size":6,"scene_points":4,"v_data":1,"v_s0":2,"v_s1":3,"v_sizes":0}
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

kernel void naive_intersect(global int* v_sizes, global unit_data* v_data, global int* v_s0, global int* v_s1, global float3* scene_points, global int4* scene_mesh, const int scene_mesh_size) {
  int global_id = get_global_id(0);
  if (global_id >= v_sizes[hook(0, 0)])
    return;

  int this_id = v_s0[hook(2, global_id)];
  unit_data s0 = v_data[this_id];

  int geo_id = -1;
  float intersect_number = -42;
  int4 triangle;
  for (int i = 0; i < scene_mesh_size; i += 1) {
    triangle = scene_mesh[hook(5, i)];
    float result = _single_intersect(s0.start_p, s0.in_dir, scene_points[hook(4, triangle.x)], scene_points[hook(4, triangle.y)], scene_points[hook(4, triangle.z)]);
    if (result > 0 && (intersect_number < 0 || result < intersect_number)) {
      intersect_number = result;
      geo_id = i;
    }
  }

  if (geo_id != -1) {
    int index = atomic_inc(v_sizes + 1);
    v_s1[hook(3, index)] = this_id;

    v_data[hook(7, this_id)].geometry = scene_mesh[hook(5, geo_id)];
    v_data[hook(7, this_id)].intersect_number = intersect_number;
  }
}