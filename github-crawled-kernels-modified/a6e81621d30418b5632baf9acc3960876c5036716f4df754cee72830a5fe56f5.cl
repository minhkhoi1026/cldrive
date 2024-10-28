//{"force":5,"out":6,"pairs":1,"params":0,"pos":3,"spring":2,"vel":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void force_pairs(global float4* params, global int2* pairs, global float4* spring, global float4* pos, global float4* vel, global float4* force, global float4* out) {
  int n = get_global_id(0);

  int i = pairs[hook(1, n)].s0;
  int j = pairs[hook(1, n)].s1;

  float springConstant = spring[hook(2, n)].s0;
  float damping = spring[hook(2, n)].s1;
  float restLength = spring[hook(2, n)].s2;

  float4 a = pos[hook(3, i)];
  float4 b = pos[hook(3, j)];

  float4 va = vel[hook(4, i)];
  float4 vb = vel[hook(4, j)];

  float4 a2b = a - b;
  float4 Va2b = va - vb;

  float a2bDistance = distance(a, b);
  if (0 < a2bDistance) {
    a2b /= a2bDistance;
  }

  float springForce = -(a2bDistance - restLength) * springConstant;

  float dampingForce = -damping * dot(a2b, Va2b);

  float r = springForce + dampingForce;
  float4 f = a2b * r;

  force[hook(5, n)] = f;
  out[hook(6, n)] = force[hook(5, n)];
}