//{"dst":0,"value":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void fill_image_int(write_only image2d_t dst, int value) {
  int2 gid = {get_global_id(0), get_global_id(1)};
  if (all(gid < get_image_dim(dst)))
    write_imagei(dst, gid, (int4)(value));
}