//{"dx":8,"dy":9,"h":7,"height":5,"integral_img":2,"p":6,"src":3,"sum":0,"weight":1,"width":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = (0 | 2 | 0x10);
kernel void weight_accum(global float* sum, global float* weight, global uint4* integral_img, read_only image2d_t src, int width, int height, int p, float h, int4 dx, int4 dy) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  int4 xoff = x + dx;
  int4 yoff = y + dy;
  uint4 a = 0, b = 0, c = 0, d = 0;
  uint4 src_pix = 0;

  int oobb = (x - p) < 0 || (y - p) < 0 || (y + p) >= height || (x + p) >= width;

  src_pix.x = (int)(255 * read_imagef(src, sampler, (int2)(xoff.x, yoff.x)).x);
  src_pix.y = (int)(255 * read_imagef(src, sampler, (int2)(xoff.y, yoff.y)).x);
  src_pix.z = (int)(255 * read_imagef(src, sampler, (int2)(xoff.z, yoff.z)).x);
  src_pix.w = (int)(255 * read_imagef(src, sampler, (int2)(xoff.w, yoff.w)).x);
  if (!oobb) {
    a = integral_img[hook(2, (y - p) * width + x - p)];
    b = integral_img[hook(2, (y + p) * width + x - p)];
    c = integral_img[hook(2, (y - p) * width + x + p)];
    d = integral_img[hook(2, (y + p) * width + x + p)];
  }

  float4 patch_diff = convert_float4(d + a - c - b);
  float4 w = native_exp(-patch_diff / (h * h));
  float w_sum = w.x + w.y + w.z + w.w;
  weight[hook(1, y * width + x)] += w_sum;
  sum[hook(0, y * width + x)] += dot(w, convert_float4(src_pix));
}