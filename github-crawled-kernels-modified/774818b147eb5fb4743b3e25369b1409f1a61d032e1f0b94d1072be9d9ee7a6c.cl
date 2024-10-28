//{"damp":4,"dt":3,"force":2,"pos":0,"vel":1}
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

kernel void move_leapfrog(global float4* pos, global float4* vel, global float4* force, float dt, float damp) {
  const int i = get_global_id(0);
  float3 f = force[hook(2, i)].xyz;
  float3 v = vel[hook(1, i)].xyz;
  float3 p = pos[hook(0, i)].xyz;
  v = v * damp + f * dt;
  p += v * dt;
  vel[hook(1, i)] = (float4)(v, 0.0f);
  pos[hook(0, i)] = (float4)(p, 0.0f);
}