//{"image":0,"value":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void image_filli(write_only image2d_t image, int4 value) {
  write_imagei(image, (int2)(get_global_id(0), get_global_id(1)), value);
}