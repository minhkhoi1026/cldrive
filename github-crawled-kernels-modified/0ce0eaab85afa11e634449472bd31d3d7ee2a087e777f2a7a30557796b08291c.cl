//{"image":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
typedef read_only image2d_t myimage;
kernel void image2d_typedef(read_only myimage image) {
}