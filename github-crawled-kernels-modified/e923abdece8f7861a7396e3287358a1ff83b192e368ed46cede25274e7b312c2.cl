//{"corner_x":7,"corner_y":8,"hologram_z":4,"k":5,"of":1,"of_cols":3,"of_rows":2,"pc":0,"pitch":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compObjWave(global float* pc, global float2* of, unsigned int of_rows, unsigned int of_cols, float hologram_z, float k, float pitch, float corner_x, float corner_y) {
  int row = get_global_id(1);
  int col = get_global_id(2);

  int pc_pos = get_global_id(0) * 3;
  float3 ps = (float3)(pc[hook(0, pc_pos)], pc[hook(0, pc_pos + 1)], pc[hook(0, pc_pos + 2)]);
  float x = (((col - 1) * pitch) + corner_x) - ps.x;
  float y = (((row - 1) * pitch) + corner_y) - ps.y;
  float z = hologram_z - ps.z;
  float r = sqrt(x * x + y * y + z * z);
  float tmp = k * r;
  float re = cos(tmp);
  float im = sin(tmp);
  unsigned int of_index = row * of_cols + col;
  float2 sample = of[hook(1, of_index)];
  sample += (float2)(re, im);
  of[hook(1, of_index)] = sample;
}