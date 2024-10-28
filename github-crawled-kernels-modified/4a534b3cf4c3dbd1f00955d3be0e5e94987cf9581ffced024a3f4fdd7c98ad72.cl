//{"dim":4,"dt":3,"float3":1,"pos":0,"vel":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void euler(global float4* pos, global float4* float3, global float4* vel, float dt, float dim) {
  unsigned int i = get_global_id(0);

  float4 p = pos[hook(0, i)];
  float4 v = vel[hook(2, i)];
  p.xyz += v.xyz;

  if (p.x >= dim) {
    p.x = -2.0f * dim + p.x;
  } else if (p.x <= -dim) {
    p.x = 2.0f * dim - p.x;
  }

  if (p.y >= dim) {
    p.y = -2.0f * dim + p.y;
  } else if (p.y <= -dim) {
    p.y = 2.0f * dim - p.y;
  }

  pos[hook(0, i)] = p;
  vel[hook(2, i)] = v;
}