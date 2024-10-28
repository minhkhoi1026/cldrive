//{"Z":0,"out":1,"size":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void bluestein_post(global float2* Z, global float2* out, unsigned int size) {
  unsigned int glb_id = get_global_id(0);
  unsigned int glb_sz = get_global_size(0);

  unsigned int double_size = size << 1;
  float sn_a, cs_a;
  const float NUM_PI = 3.14159265358979323846;

  for (unsigned int i = glb_id; i < size; i += glb_sz) {
    unsigned int rm = i * i % (double_size);
    float angle = (float)rm / size * (-NUM_PI);

    sn_a = sincos(angle, &cs_a);

    float2 b_i = (float2)(cs_a, sn_a);
    out[hook(1, i)] = (float2)(Z[hook(0, i)].x * b_i.x - Z[hook(0, i)].y * b_i.y, Z[hook(0, i)].x * b_i.y + Z[hook(0, i)].y * b_i.x);
  }
}