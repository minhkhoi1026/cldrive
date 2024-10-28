//{"light_colors":2,"light_positions":3,"object_colors":6,"object_count":8,"object_props":7,"objects":5,"position":9,"ray_color":1,"ray_start":0,"total_lights":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float4 back_color(float4 position, float4 ray_dir) {
  position += ray_dir * 1.0f;

  if (((int)(position[hook(9, 1)] * 40.f + position[hook(9, 0)] * 20.f) % 2))
    return (float4)(0.2f);
  else
    return (float4)(0.0f);
}
void get_closest_object(float4 ray_start, float4 dir, float* dist, int* closest, global float4* objects, int object_count) {
  for (int i = 0; i < object_count; ++i) {
    float4 o = objects[hook(5, i)];
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
float4 get_shadow_factor(float4 ray_start, float4 dir, float dist, global float4* objects, global float4* object_colors, global float4* object_props, int object_count) {
  float4 shadow_factor = (float4)(1.f);
  for (int i = 0; i < object_count; ++i) {
    float4 o = objects[hook(5, i)];
    float4 ray_p = ray_start - o;
    ray_p.s3 = 0.f;
    const float s2 = dot(dir, dir);
    const float s1 = dot(ray_p, dir);
    const float s0 = o.s3 * o.s3 - dot(ray_p, ray_p);

    float d = s1 * s1 + s2 * s0;
    if (d > 0.001f) {
      d = (s1 + sqrt(d)) / (-s2);
      if (d > 0.001f && d < dist) {
        float t = object_props[hook(7, i)].s3;
        shadow_factor *= t * object_colors[hook(6, i)];
      }
    }
  }
  return shadow_factor;
}
inline float4 calc_lighting(float spec_ratio, float4 normal, float4 ray_pos, float4 ray_dir, global float4* light_colors, global float4* light_positions, global float4* objects, global float4* object_colors, global float4* object_props, int total_lights, int total_objects) {
  float4 float3 = (float4)(0.1f);
  float4 spec_color = (float4)(0.1f);
  ray_dir.s3 = ray_pos.s3 = normal.s3 = 0.f;
  for (int i = 0; i < total_lights; ++i) {
    float4 light_dist = light_positions[hook(3, i)] - ray_pos;
    light_dist.s3 = 0.0f;

    float dist = length(light_dist);
    float4 light_dir = light_dist / dist;
    float4 shadow_factor = get_shadow_factor(ray_pos, light_dir, dist, objects, object_colors, object_props, total_objects);

    if (dot(light_dir, normal) > 0.f) {
      float4 light_factor = light_colors[hook(2, i)] * shadow_factor;

      float lambert = dot(light_dir, normal) * (1.0f - spec_ratio);

      float3 += light_factor * lambert;
      float4 blinn_dir = normalize(light_dir - ray_dir);
      float blinn_term = max(dot(blinn_dir, normal), 0.f);
      spec_color += light_factor * pow(blinn_term, 30.f);
    }
  }
  return float3 + spec_color * spec_ratio;
}
inline float4 refract(float4 incident, float4 normal, float eta) {
  incident *= eta;
  float ni = dot(normal, incident);
  float k = 1.f - eta * eta + ni * ni;
  return k < 0.0f ? (float4)(0.f) : incident - (ni + sqrt(k)) * normal;
}
float4 do_ray2(float4 ray_start, float4 ray_dir, global float4* light_colors, global float4* light_positions, int total_lights, global float4* objects, global float4* object_colors, global float4* object_props, int object_count, int depth) {
  float dist = 1e8f;
  int closest;
  get_closest_object(ray_start, ray_dir, &dist, &closest, objects, object_count);
  if (dist != 1.e8f && depth < 3) {
    float4 float3 = object_colors[hook(6, closest)];

    float4 intersect_point = ray_start + ray_dir * dist;
    intersect_point.s3 = 0.0f;
    float4 ob = objects[hook(5, closest)];
    float4 p = (float4)(ob.s0, ob.s1, ob.s2, 0.f);
    float4 n = normalize(intersect_point - p);

    float index_of_ref = object_props[hook(7, closest)].s0;
    float transparency = object_props[hook(7, closest)].s3;
    float fresnal_factor = (index_of_ref - 1.0f) / (1.0f + index_of_ref);
    fresnal_factor *= fresnal_factor;
    float ratio = fresnal_factor + (1.0f - fresnal_factor) * pow((1.0f - dot(-1.0f * ray_dir, n)), 5.0f);
    float4 light_c = calc_lighting(ratio, n, intersect_point, ray_dir, light_colors, light_positions, objects, object_colors, object_props, total_lights, object_count);

    return light_c;

  } else
    return back_color(ray_start, ray_dir);
}

float4 do_ray(float4 ray_start, float4 ray_dir, global float4* light_colors, global float4* light_positions, int total_lights, global float4* objects, global float4* object_colors, global float4* object_props, int object_count, int depth) {
  float dist = 1e8f;
  int closest;
  get_closest_object(ray_start, ray_dir, &dist, &closest, objects, object_count);
  if (dist != 1.e8f && depth < 3) {
    float4 float3 = object_colors[hook(6, closest)];

    float4 intersect_point = ray_start + ray_dir * dist;
    intersect_point.s3 = 0.0f;
    float4 ob = objects[hook(5, closest)];
    float4 p = (float4)(ob.s0, ob.s1, ob.s2, 0.f);
    float4 n = normalize(intersect_point - p);

    float index_of_ref = object_props[hook(7, closest)].s0;
    float transparency = object_props[hook(7, closest)].s3;
    float fresnal_factor = (index_of_ref - 1.0f) / (1.0f + index_of_ref);
    fresnal_factor *= fresnal_factor;
    float ratio = fresnal_factor + (1.0f - fresnal_factor) * pow((1.0f - dot(-1.0f * ray_dir, n)), 5.0f);
    float4 light_c = calc_lighting(ratio, n, intersect_point, ray_dir, light_colors, light_positions, objects, object_colors, object_props, total_lights, object_count);

    float reflect = 2.0f * dot(ray_dir, n);
    float4 reflected = do_ray2(intersect_point, ray_dir - reflect * n, light_colors, light_positions, total_lights, objects, object_colors, object_props, object_count, depth + 1);
    float4 ref = refract(normalize(ray_dir), n, 1.0f / index_of_ref);
    float4 refracted = do_ray2(intersect_point, ref, light_colors, light_positions, total_lights, objects, object_colors, object_props, object_count, depth + 1);

    return mix(float3 * (light_c + refracted) * (1.0f - transparency) + refracted * transparency, reflected, ratio);

  } else
    return back_color(ray_start, ray_dir);
}
kernel void ray_trace(global float4* ray_start, global float4* ray_color, global float4* light_colors, global float4* light_positions, int total_lights, global float4* objects, global float4* object_colors, global float4* object_props, int object_count) {
  int i = get_global_id(0);

  ray_color[hook(1, i)] = do_ray(ray_start[hook(0, i)], (float4)(0.f, 0.f, -1.f, 0.f), light_colors, light_positions, total_lights, objects, object_colors, object_props, object_count, 0);
}