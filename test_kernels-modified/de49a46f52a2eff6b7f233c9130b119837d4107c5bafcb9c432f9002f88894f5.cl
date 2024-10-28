//{"coord":1,"img":0,"out":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void basic_readonly_image_type(read_only image2d_t img, int2 coord, global float4* out) {
  out[hook(2, 0)] = read_imagef(img, coord);
}