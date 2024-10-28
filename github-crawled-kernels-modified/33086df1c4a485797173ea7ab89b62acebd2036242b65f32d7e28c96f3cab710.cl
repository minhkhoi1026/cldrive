//{"A":1,"B":2,"ext_size":4,"input":0,"size":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void bluestein_pre(global float2* input, global float2* A, global float2* B, unsigned int size, unsigned int ext_size) {
  unsigned int glb_id = get_global_id(0);
  unsigned int glb_sz = get_global_size(0);

  unsigned int double_size = size << 1;

  float sn_a, cs_a;
  const float NUM_PI = 3.14159265358979323846;

  for (unsigned int i = glb_id; i < size; i += glb_sz) {
    unsigned int rm = i * i % (double_size);
    float angle = (float)rm / size * NUM_PI;

    sn_a = sincos(-angle, &cs_a);

    float2 a_i = (float2)(cs_a, sn_a);
    float2 b_i = (float2)(cs_a, -sn_a);

    A[hook(1, i)] = (float2)(input[hook(0, i)].x * a_i.x - input[hook(0, i)].y * a_i.y, input[hook(0, i)].x * a_i.y + input[hook(0, i)].y * a_i.x);

    B[hook(2, i)] = b_i;

    if (i)
      B[hook(2, ext_size - i)] = b_i;
  }
}