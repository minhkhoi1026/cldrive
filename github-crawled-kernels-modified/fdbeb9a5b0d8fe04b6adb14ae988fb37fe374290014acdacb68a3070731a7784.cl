//{"dt":1,"kParticleCount":0,"position":2,"prePos":3,"velocity":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sph_kernel_advance(int kParticleCount, float dt, global float4* position, global float4* prePos, global float4* velocity) {
  size_t gid = get_global_id(0);

  prePos[hook(3, gid)].xyzw = position[hook(2, gid)].xyzw;

  barrier(0x01);

  position[hook(2, gid)].xyz += (float3)(dt)*velocity[hook(4, gid)].xyz;
}