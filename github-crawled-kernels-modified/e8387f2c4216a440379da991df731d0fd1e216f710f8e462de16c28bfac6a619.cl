//{"im1d":0,"im2d":1,"im3d":2,"out":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void readui(read_only image1d_t im1d, read_only image2d_t im2d, read_only image3d_t im3d, global uint4* out) {
  out[hook(3, 0)] = read_imageui(im1d, 0);
  out[hook(3, 1)] = read_imageui(im2d, (int2)(0));
  out[hook(3, 2)] = read_imageui(im3d, (int4)(0));
}