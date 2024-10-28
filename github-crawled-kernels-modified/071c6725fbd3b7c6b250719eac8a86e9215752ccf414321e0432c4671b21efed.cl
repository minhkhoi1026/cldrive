//{"image":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void bar(write_only image2d_t image) {
  write_imagef(image, (int2)(0, 0), (float4)(0.0));
}

kernel void foo(write_only image2d_t image) {
  bar(image);
}