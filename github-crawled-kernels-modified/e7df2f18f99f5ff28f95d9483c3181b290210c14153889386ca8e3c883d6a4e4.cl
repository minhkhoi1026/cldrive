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

kernel void cloth_force(global float4* pos, global float4* force) {
  const int i = get_global_id(1) * get_global_size(0) + get_global_id(0);

  float3 p = pos[hook(0, i)].xyz;
  float3 f = (float3)(0.0f, 0.0f, 0.0f);

  if (get_global_id(1) > 0) {
    f += stickForce(pos[hook(0, i - get_global_size(0))].xyz, p, -10.0f, 1.0f);
  }
  if (get_global_id(1) < get_global_size(1) - 1) {
    f += stickForce(pos[hook(0, i + get_global_size(0))].xyz, p, -10.0f, 1.0f);
  }
  if (get_global_id(0) > 0) {
    f += stickForce(pos[hook(0, i - 1)].xyz, p, -10.0f, 1.0f);
  }
  if (get_global_id(0) < get_global_size(0) - 1) {
    f += stickForce(pos[hook(0, i + 1)].xyz, p, -10.0f, 1.0f);
  }
  f.y += -0.05f;

  force[hook(1, i)] = (float4)(f, 0.0f);
}