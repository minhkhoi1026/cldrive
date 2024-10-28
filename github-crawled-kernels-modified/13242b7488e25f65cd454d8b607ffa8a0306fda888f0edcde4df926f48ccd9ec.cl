//{"corner_x":6,"corner_y":7,"hologram_z":3,"k":4,"of":2,"pc":0,"pc_size":1,"pitch":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compObjWave(global float* pc, unsigned int pc_size, global float2* of, float hologram_z, float k, float pitch, float corner_x, float corner_y) {
  int row = get_global_id(0);
  int col = get_global_id(1);

  float2 sample = (float2)(0.0f, 0.0f);

  float4 dist = (float4)(((col - 1) * pitch) + corner_x, ((row - 1) * pitch) + corner_y, hologram_z, 0.0f);

  for (unsigned int i = 0; i < pc_size; ++i) {
    float4 ps = (float4)(pc[hook(0, i * 3)], pc[hook(0, i * 3 + 1)], pc[hook(0, i * 3 + 2)], 0.0f);

    ps = dist - ps;
    ps.w = sqrt(ps.x * ps.x + ps.y * ps.y + ps.z * ps.z) * k;

    sample.s0 += cos(ps.w);
    sample.s1 += sin(ps.w);
  }

  of[hook(2, row * get_global_size(1) + col)] = sample;
}