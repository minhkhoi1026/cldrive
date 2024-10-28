//{"corner_x":6,"corner_y":7,"hologram_z":3,"k":4,"of":2,"pc":0,"pc_size":1,"pitch":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compObjWave(global float* pc, unsigned int pc_size, global float2* of, float hologram_z, float k, float pitch, float corner_x, float corner_y) {
  int row = get_global_id(0);
  int col = get_global_id(1);
  unsigned int of_index = row * get_global_size(1) + col;

  for (unsigned int i = 0; i < pc_size; ++i) {
    float4 ps = (float4)(pc[hook(0, i * 3)], pc[hook(0, i * 3 + 1)], pc[hook(0, i * 3 + 2)], 0.0f);
    float x = (((col - 1) * pitch) + corner_x) - ps.x;
    float y = (((row - 1) * pitch) + corner_y) - ps.y;
    float z = hologram_z - ps.z;
    float r = sqrt(x * x + y * y + z * z);

    float re = cos(k * r);
    float im = sin(k * r);
    of[hook(2, of_index)] += (float2)(re, im);
  }
}