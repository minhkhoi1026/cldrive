//{"image":0,"out":2,"s":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void read_uint(read_only image2d_array_t image, sampler_t s, global uint4* out) {
  out[hook(2, 0)] = read_imageui(image, s, (float4)(0));
  out[hook(2, 1)] = read_imageui(image, s, (int4)(0));
  out[hook(2, 2)] = read_imageui(image, (int4)(0));
}