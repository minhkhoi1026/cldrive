//{"image":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void bar(image2d_t image) {
  int i;
  int* ptr = &i;
  vload4(0, ptr);
}

kernel void image2d_type_as_argument(image2d_t image) {
  bar(image);
}