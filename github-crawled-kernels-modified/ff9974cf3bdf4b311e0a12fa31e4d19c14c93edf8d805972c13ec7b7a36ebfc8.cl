//{"corner_x":8,"corner_y":9,"hologram_z":5,"k":6,"num_cols":4,"of":2,"offset":3,"pc":0,"pc_size":1,"pitch":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compObjWave_MultiPass(global float* pc, unsigned int pc_size, global float2* of, int offset, int num_cols, float hologram_z, float k, float pitch, float corner_x, float corner_y) {
  size_t gid = get_global_id(0);
  int row = (gid + offset) / num_cols;
  int col = (gid + offset) - (row * num_cols);

  float2 sample = (float2)(0.0f, 0.0f);

  float4 of_pos = (float4)(((col - 1) * pitch) + corner_x, ((row - 1) * pitch) + corner_y, hologram_z, 0.0f);

  for (unsigned int i = 0; i < pc_size; ++i) {
    float4 ps = (float4)(pc[hook(0, i * 3)], pc[hook(0, i * 3 + 1)], pc[hook(0, i * 3 + 2)], 0.0f);

    ps = of_pos - ps;
    ps.w = sqrt(ps.x * ps.x + ps.y * ps.y + ps.z * ps.z) * k;

    sample.s0 += cos(ps.w);
    sample.s1 += sin(ps.w);
  }

  of[hook(2, gid)] = sample;
}