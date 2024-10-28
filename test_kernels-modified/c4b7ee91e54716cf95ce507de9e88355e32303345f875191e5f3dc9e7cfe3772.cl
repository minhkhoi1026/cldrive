//{"scene":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
typedef float3 float3;
typedef float4 float4;
enum IntersectionType { OUTER_HIT, INNER_HIT, MISS };

enum IntersectStatus { CONTINUE, STOP };

enum RayType { PRIMARY, REFLECT, REFRACT, REFLECT_AND_REFRACT, LIGHT_SEEK, SHADOW, LIGHT_FOUND, INFINITE };

struct Intersection {
  float dist;
  int obj_index;
  float3 obj_normal;
  enum IntersectionType type;
};

struct TraceInfo {
  enum IntersectStatus status;
  float4 float3;
  float ray_dot;
  float dist;
  float4 fade_amount;
  enum RayType ray_type;
  enum RayType next_ray_type;
  bool blocked;
  float3 light_dir;
  float3 obj_normal;
  float3 refl_dir;
  float3 viewer_dir;
  int material;
  float4 light_arriving;
  float3 next_ray_pos[3];
  float3 next_ray_dir[3];
};
struct Intersection intersect_plane(constant float16* scene, int obj_index, float3 ray_pos, float3 ray_dir, float max_t);

struct Intersection intersect_sphere(constant float16* scene, int obj_index, float3 ray_pos, float3 ray_dir, float max_t);

struct Intersection intersect_cube(constant float16* scene, int obj_index, float3 ray_pos, float3 ray_dir, float max_t);

struct TraceInfo intersect_scene(constant float16* scene, int scene_size, float3 ray_pos, float3 ray_dir, enum RayType ray_type, float previous_distance, int trace_depth);

struct Intersection Intersection_init(struct Intersection* intersection);

void find_nearest_intersection(constant float16* scene, int scene_size, float3 ray_pos, float3 ray_dir, struct Intersection* nearest);

void TraceInfo_init(struct TraceInfo* info);

kernel void trace_rays(constant float16* scene, constant float16* lights, const int scene_size, global float3* ray_pos, global float3* ray_dir, const int rays_per_pixel, global float4* pixel_board, const int width, const int height, const int max_depth, const unsigned int count);
struct Intersection intersect_box(constant float16* scene, int obj_index, float3 ray_pos, float3 ray_dir, float max_t) {
  struct Intersection jieguo;
  jieguo.type = MISS;
  jieguo.dist = max_t;

  float3 vmin = scene[hook(0, obj_index)].s456;
  float3 vmax = scene[hook(0, obj_index)].s789;

  float tmin, tmax, tymin, tymax, tzmin, tzmax;
  if (ray_dir.x >= 0) {
    tmin = (vmin.x - ray_pos.x) / ray_dir.x;
    tmax = (vmax.x - ray_pos.x) / ray_dir.x;
  } else {
    tmin = (vmax.x - ray_pos.x) / ray_dir.x;
    tmax = (vmin.x - ray_pos.x) / ray_dir.x;
  }
  if (ray_dir.y >= 0) {
    tymin = (vmin.y - ray_pos.y) / ray_dir.y;
    tymax = (vmax.y - ray_pos.y) / ray_dir.y;
  } else {
    tymin = (vmax.y - ray_pos.y) / ray_dir.y;
    tymax = (vmin.y - ray_pos.y) / ray_dir.y;
  }
  if ((tmin > tymax) || (tymin > tmax)) {
    return jieguo;
  }
  if (tymin > tmin) {
    tmin = tymin;
  }
  if (tymax < tmax) {
    tmax = tymax;
  }
  if (ray_dir.z >= 0) {
    tzmin = (vmin.z - ray_pos.z) / ray_dir.z;
    tzmax = (vmax.z - ray_pos.z) / ray_dir.z;
  } else {
    tzmax = (vmax.z - ray_pos.z) / ray_dir.z;
    tzmin = (vmin.z - ray_pos.z) / ray_dir.z;
  }
  if ((tmin > tzmax) || (tzmin > tmax)) {
    return jieguo;
  }
  if (tzmin > tmin) {
    tmin = tzmin;
  }
  if (tzmax < tmax) {
    tmax = tzmax;
  }

  jieguo.type = OUTER_HIT;
  jieguo.dist = tmin;

  float3 point = ray_pos + jieguo.dist * ray_dir;
  float eps = 0.01;

  if (fabs(point.x - vmin.x) < eps)
    jieguo.obj_normal = (float3)(-1.f, 0.f, 0.f);
  else if (fabs(point.x - vmax.x) < eps)
    jieguo.obj_normal = (float3)(1.f, 0.f, 0.f);
  else if (fabs(point.y - vmin.y) < eps)
    jieguo.obj_normal = (float3)(0.f, -1.f, 0.f);
  else if (fabs(point.y - vmax.y) < eps)
    jieguo.obj_normal = (float3)(0.f, 1.f, 0.f);
  else if (fabs(point.z - vmin.z) < eps)
    jieguo.obj_normal = (float3)(0.f, 0.f, 1.f);
  else if (fabs(point.z - vmax.z) < eps)
    jieguo.obj_normal = (float3)(0.f, 0.f, -1.f);

  return jieguo;
}