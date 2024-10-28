//{"damping":3,"dstImage":2,"intImage":1,"offset":4,"srcImage":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ripple2D(read_only image2d_t srcImage, read_only image2d_t intImage, write_only image2d_t dstImage, const float damping) {
  int2 coords = (int2)(get_global_id(0), get_global_id(1));

  int2 offset[4];
  offset[hook(4, 0)] = (int2)(-1, 0);
  offset[hook(4, 1)] = (int2)(1, 0);
  offset[hook(4, 2)] = (int2)(0, 1);
  offset[hook(4, 3)] = (int2)(0, -1);
  sampler_t smp = 2 | 0x10;
  float4 sum = (float4)(0.0f);
  for (int i = 0; i < 4; ++i) {
    sum += read_imagef(srcImage, smp, coords + offset[hook(4, i)]);
  }

  sum = (sum / 2.0f) - read_imagef(intImage, smp, coords);
  sum *= damping;

  float4 float3 = sum;
  write_imagef(dstImage, coords, float3);
}