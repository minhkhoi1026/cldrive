//{"img_ro":0,"img_wo":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((overloadable)) void read_image(read_only image1d_t img_ro);
__attribute__((overloadable)) void read_image(write_only image1d_t img_wo);
kernel void test_read_image(read_only image1d_t img_ro, write_only image1d_t img_wo) {
  read_image(img_ro);

  read_image(img_wo);
}