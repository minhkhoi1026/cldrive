//{"dt":5,"float3":1,"pos":0,"pos_gen":3,"vel":2,"vel_gen":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void part2(global float4* pos, global float4* float3, global float4* vel, global float4* pos_gen, global float4* vel_gen, float dt) {
  unsigned int i = get_global_id(0);

  float4 p = pos[hook(0, i)];
  float4 v = vel[hook(2, i)];

  float life = vel[hook(2, i)].w;

  life -= dt;

  if (life <= 0) {
    p = pos_gen[hook(3, i)];
    v = vel_gen[hook(4, i)];
    life = 1.0;
  }

  v.z -= 9.8 * dt;

  p.x += v.x * dt;
  p.y += v.y * dt;
  p.z += v.z * dt;

  v.w = life;

  pos[hook(0, i)] = p;
  vel[hook(2, i)] = v;

  float3[hook(1, i)].w = life;
}