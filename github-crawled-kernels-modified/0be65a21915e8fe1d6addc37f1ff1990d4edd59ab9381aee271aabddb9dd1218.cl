//{"im1d":0,"im2d":1,"im3d":2,"out":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void readf(read_only image1d_t im1d, read_only image2d_t im2d, read_only image3d_t im3d, global float4* out) {
  out[hook(3, 0)] = read_imagef(im1d, 0);
  out[hook(3, 1)] = read_imagef(im2d, (int2)(0));
  out[hook(3, 2)] = read_imagef(im3d, (int4)(0));
}