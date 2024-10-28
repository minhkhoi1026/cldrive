//{"c_origins":2,"c_outputs":6,"c_params":5,"c_rays":3,"c_targets":4,"c_triangles":0,"c_vertices":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float rayIntersectsTriangle(float4 p, float4 d, float4 v0, float4 v1, float4 v2) {
  float4 e1 = v1 - v0;
  float4 e2 = v2 - v0;
  float a, f, u, v;

  float4 h = cross(d, e2);
  a = dot(e1, h);

  if (a > -0.00001f && a < 0.00001f)
    return 99999.0;

  f = 1.0f / a;
  float4 s = p - v0;
  u = f * dot(s, h);

  if (u < 0.0f || u > 1.0f)
    return 99999.0;

  float4 q = cross(s, e1);
  v = f * dot(d, q);

  if (v < 0.0f || u + v > 1.0f)
    return 99999.0;

  float result = f * dot(e2, q);

  if (result > 0.00001f)
    return result;

  else

    return 99999.0;
}

kernel void sdf(global const uint3* c_triangles, global const float4* c_vertices, global const unsigned int* c_origins, global const float4* c_rays, global const unsigned int* c_targets, const uint4 c_params, global float* c_outputs) {
  const unsigned int gid = get_global_id(0);

  unsigned int ref_ray = gid;
  unsigned int ref_triangle = ref_ray / c_params.y;

  if (ref_triangle >= c_params.w)
    return;

  float dist = 99999.0;
  float dist2 = 99999.0;
  float theta = 0.0f;
  unsigned int i = 0;

  const float4 ray = c_rays[hook(3, ref_ray)];
  float4 v0 = c_vertices[hook(1, c_triangles[chook(0, c_origins[rhook(2, ref_triangle)).x)];
  float4 v1 = c_vertices[hook(1, c_triangles[chook(0, c_origins[rhook(2, ref_triangle)).y)];
  float4 v2 = c_vertices[hook(1, c_triangles[chook(0, c_origins[rhook(2, ref_triangle)).z)];
  const float4 center = (v0 + v1 + v2) / 3.0f;
  const float4 normal = normalize((-1.0f) * cross(v1 - v0, v2 - v0));
  float4 tnormal;

  for (i = 0; i < c_params.z; i++) {
    ref_triangle = c_targets[hook(4, (ref_ray * c_params.z) + i)];
    if (ref_triangle == 0)
      break;

    ref_triangle = ref_triangle - 1;

    v0 = c_vertices[hook(1, c_triangles[rhook(0, ref_triangle).x)];
    v1 = c_vertices[hook(1, c_triangles[rhook(0, ref_triangle).y)];
    v2 = c_vertices[hook(1, c_triangles[rhook(0, ref_triangle).z)];

    dist2 = rayIntersectsTriangle(center, ray, v0, v1, v2);
    if (dist2 < 99999.0) {
      tnormal = normalize(cross(v1 - v0, v2 - v0));
      theta = acos(dot(ray, tnormal) / length(ray));
      theta = theta * (180.0f / 3.14159265358979323846264338327950288f);
      if ((theta < 90.0f) && (dist2 < dist))
        dist = dist2;
    }
  }

  c_outputs[hook(6, ref_ray)] = dist;
}