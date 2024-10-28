//{"force":1,"pos":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float3 stickForce(float3 p1, float3 p2, float k, float l0) {
  float3 d = p2 - p1;
  float l = sqrt(dot(d, d));
  d *= k * (l - l0) / (l + 1e-8f);
  return d;
}

float3 harmonicForce(float3 p1, float3 p2, float k) {
  float3 d = p2 - p1;
  return d * k;
}

kernel void cloth_force_bend(global float4* pos, global float4* force) {
  const int i = get_global_id(1) * get_global_size(0) + get_global_id(0);

  float3 p = pos[hook(0, i)].xyz;
  float3 f = (float3)(0.0f, 0.0f, 0.0f);
  float3 c;
  if (get_global_id(1) > 0) {
    float3 pj = pos[hook(0, i - get_global_size(0))].xyz;
    f += stickForce(pj, p, -10.0f, 1.0f);
    c = pj;
  }
  if (get_global_id(1) < get_global_size(1) - 1) {
    float3 pj = pos[hook(0, i + get_global_size(0))].xyz;
    f += stickForce(pj, p, -10.0f, 1.0f);
    if (get_global_id(1) > 0) {
      f += harmonicForce(p, (c + pj) * 0.5f, 5.0f);
    }
  }
  if (get_global_id(0) > 0) {
    float3 pj = pos[hook(0, i - 1)].xyz;
    f += stickForce(pj, p, -10.0f, 1.0f);
    c = pj;
  }
  if (get_global_id(0) < get_global_size(0) - 1) {
    float3 pj = pos[hook(0, i + 1)].xyz;
    f += stickForce(pj, p, -10.0f, 1.0f);
    if (get_global_id(0) > 0) {
      f += harmonicForce(p, (c + pj) * 0.5f, 5.0f);
    }
  }
  f.y += -0.05f;

  force[hook(1, i)] = (float4)(f, 0.0f);
}