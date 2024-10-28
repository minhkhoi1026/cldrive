//{"buffer":3,"input":0,"length":2,"result":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float fast_mexp2f(const float x) {
  const float i1 = (float)0x3f800000u;
  const float i2 = (float)0x3f000000u;
  const float k0 = i1 + x * (i2 - i1);
  union {
    float f;
    unsigned int i;
  } k;
  k.i = (k0 >= (float)0x800000u) ? k0 : 0;
  return k.f;
}

float ddirac(const int2 q) {
  return ((q.x || q.y) ? 1.0f : 0.0f);
}

float4 weight(const float4 c1, const float4 c2, const float inv_sigma2) {
  const float4 sqr = (c1 - c2) * (c1 - c2);
  const float dt = (sqr.x + sqr.y + sqr.z) * inv_sigma2;
  const float var = 0.02f;
  const float off2 = 9.0f;
  const float r = fast_mexp2f(fmax(0.0f, dt * var - off2));

  return (float4)r;
}

kernel void denoiseprofile_reduce_second(const global float4* input, global float4* result, const int length, local float4* buffer) {
  int x = get_global_id(0);
  float4 sum_y2 = (float4)0.0f;

  while (x < length) {
    sum_y2 += input[hook(0, x)];

    x += get_global_size(0);
  }

  int lid = get_local_id(0);
  buffer[hook(3, lid)] = sum_y2;

  barrier(0x01);

  for (int offset = get_local_size(0) / 2; offset > 0; offset = offset / 2) {
    if (lid < offset) {
      buffer[hook(3, lid)] += buffer[hook(3, lid + offset)];
    }
    barrier(0x01);
  }

  if (lid == 0) {
    const int gid = get_group_id(0);

    result[hook(1, gid)] = buffer[hook(3, 0)];
  }
}