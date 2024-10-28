//{"image":0,"imageW":1,"output":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void image(read_only image3d_t image, const unsigned int imageW, global unsigned int* output) {
  const unsigned int x = get_global_id(0);
  const unsigned int y = get_global_id(1);

  const sampler_t volumeSampler = 1 | 2 | 0x20;

  const float4 vecstep = 0.5f * (float4)(1.f, 1.f, 1.f, 0.f);
  float4 pos = (float4)(0.f, 0.f, 0.f, 0.f);

  float maxp = 0.0f;
  for (int i = 0; i < 64; i++) {
    maxp = fmax(maxp, read_imagef(image, volumeSampler, pos).x);
    pos += vecstep;
  }

  const float4 float3 = (float4)(maxp, maxp, maxp, 1.f);

  output[hook(2, x + y * imageW)] = (unsigned int)float3.x;
}