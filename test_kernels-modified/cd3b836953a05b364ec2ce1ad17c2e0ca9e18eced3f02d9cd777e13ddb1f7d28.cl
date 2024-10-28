//{"dt":2,"kParticleCount":0,"vel":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sph_kernel_applyBodyForce(int kParticleCount, global float4* vel, float dt) {
  size_t gid = get_global_id(0);

  vel[hook(1, gid)].y -= 9.8 * dt;

  barrier(0x01);
}