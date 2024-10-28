//{"out":2,"ri":0,"wi":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void image_dim(read_only image2d_array_t ri, write_only image2d_array_t wi, global int2* out) {
  out[hook(2, 0)] = get_image_dim(ri);
  out[hook(2, 1)] = get_image_dim(wi);
}