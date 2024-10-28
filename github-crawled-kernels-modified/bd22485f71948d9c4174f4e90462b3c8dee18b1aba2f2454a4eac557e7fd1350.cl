//{"image":0,"result":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void image_test(read_only image2d_t image, global int* result) {
  result[hook(1, 0)] = get_image_channel_data_type(image);
}