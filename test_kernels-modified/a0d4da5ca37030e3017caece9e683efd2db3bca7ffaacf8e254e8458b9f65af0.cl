//{"constrains":1,"force":3,"iconstrains":0,"pos":2}
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

kernel void harmonic_constr(global int* iconstrains, global float4* constrains, global float4* pos, global float4* force) {
  const int ii = get_global_id(0);
  float4 constr = constrains[hook(1, ii)];
  const int i = iconstrains[hook(0, ii)];
  force[hook(3, i)] += (float4)(harmonicForce(pos[hook(2, i)].xyz, constr.xyz, constr.w), 0.0f);
}