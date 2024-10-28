//{"out":2,"ri":0,"wi":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void image_width(read_only image1d_array_t ri, write_only image1d_array_t wi, global int* out) {
  out[hook(2, 0)] = get_image_width(ri);
  out[hook(2, 1)] = get_image_width(wi);
}