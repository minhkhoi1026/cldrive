//{"H":2,"W":3,"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void erode_textmem(read_only image2d_t src, write_only image2d_t dst, const int H, const int W) {
  int i = get_global_id(0);
  int j = get_global_id(1);
}