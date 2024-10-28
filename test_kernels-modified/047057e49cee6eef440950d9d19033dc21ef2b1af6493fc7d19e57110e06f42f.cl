//{"dt":6,"dz":7,"float3":1,"ntracers":4,"num":5,"pos":0,"posn1":2,"posn2":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void update(global float4* pos, global float4* float3, global float4* posn1, global float4* posn2, int ntracers, int num, float dt, float dz) {
  unsigned int ind = get_global_id(0);
  int i;
  float life;

  posn2[hook(3, ind)].xyz = posn1[hook(2, ind)].xyz;
  posn1[hook(2, ind)] = pos[hook(0, ind)];

  for (int j = 0; j < ntracers; j++) {
    i = ind + (j + 1) * num;

    life = posn2[hook(3, i)].w - dt / ntracers;
    if (life <= 0) {
      pos[hook(0, i)] = posn1[hook(2, ind)];
      float3[hook(1, i)] = float3[hook(1, ind)];
      life = ntracers * dt;
    }
    pos[hook(0, i)].z += dz;

    pos[hook(0, i)].w = 1.;
    posn2[hook(3, i)].w = life;
  }
}