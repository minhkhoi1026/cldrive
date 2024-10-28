//{"closest":3,"dist":2,"object":5,"object_id":4,"objects":7,"position":6,"ray_dir":1,"ray_start":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float4 back_color(float4 position, float4 ray_dir) {
  position += ray_dir * 1.0f;

  if (((int)(position[hook(6, 1)] * 40.f + position[hook(6, 0)] * 20.f) % 2))
    return (float4)(0.2f);
  else
    return (float4)(0.0f);
}
void get_closest_object(float4 ray_start, float4 dir, float* dist, int* closest, global float4* objects, int object_count) {
  for (int i = 0; i < object_count; ++i) {
    float4 o = objects[hook(7, i)];
    float4 ray_p = ray_start - o;
    ray_p.s3 = 0.f;
    const float s2 = dot(dir, dir);
    const float s1 = dot(ray_p, dir);
    const float s0 = o.s3 * o.s3 - dot(ray_p, ray_p);

    float d = s1 * s1 + s2 * s0;
    if (d > 0.001f) {
      d = (s1 + sqrt(d)) / (-s2);
      if (d > 0.001f && d < *dist) {
        *closest = i;
        *dist = d;
      }
    }
  }
}
kernel void get_ray_object(global float4* ray_start, global float4* ray_dir, global float* dist, global int* closest, int object_id, float4 object) {
  int i = get_global_id(0);

  float4 o = object;
  float4 ray_p = ray_start[hook(0, i)] - o;
  float4 dir = ray_dir[hook(1, i)];
  dir.s3 = 0.f;
  ray_p.s3 = 0.f;
  const float s2 = dot(dir, dir);
  const float s1 = dot(ray_p, dir);
  const float s0 = o.s3 * o.s3 - dot(ray_p, ray_p);

  float d = s1 * s1 + s2 * s0;
  if (d > 0.001f) {
    d = (s1 + sqrt(d)) / (-s2);
    if (d > 0.001f && d < dist[hook(2, i)]) {
      closest[hook(3, i)] = object_id;
      dist[hook(2, i)] = d;
    }
  }
}