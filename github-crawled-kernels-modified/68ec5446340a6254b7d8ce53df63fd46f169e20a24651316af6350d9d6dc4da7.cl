//{}
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