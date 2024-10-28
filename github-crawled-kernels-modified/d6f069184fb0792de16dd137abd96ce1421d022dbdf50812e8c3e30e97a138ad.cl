//{"dst":0,"src":1,"sum":2,"weight":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = (0 | 2 | 0x10);
kernel void average(write_only image2d_t dst, read_only image2d_t src, global float* sum, global float* weight) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  int2 dim = get_image_dim(dst);

  float w = weight[hook(3, y * dim.x + x)];
  float s = sum[hook(2, y * dim.x + x)];
  float src_pix = read_imagef(src, sampler, (int2)(x, y)).x;
  float r = (s + src_pix * 255) / (1.0f + w) / 255.0f;
  if (x < dim.x && y < dim.y)
    write_imagef(dst, (int2)(x, y), (float4)(r, 0.0f, 0.0f, 1.0f));
}