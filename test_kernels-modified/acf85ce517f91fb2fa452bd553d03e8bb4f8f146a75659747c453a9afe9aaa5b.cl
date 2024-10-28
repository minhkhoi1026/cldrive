//{"a1":0,"a2":1,"result":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_get_image_info_array(write_only image1d_array_t a1, write_only image2d_array_t a2, global int* result) {
  int w, h, array_sz;

  w = get_image_width(a1);
  array_sz = (int)get_image_array_size(a1);
  int channel_data_type = get_image_channel_data_type(a1);
  int channel_order = get_image_channel_order(a1);
  result[hook(2, 0)] = w;
  result[hook(2, 1)] = array_sz;
  result[hook(2, 2)] = channel_data_type;
  result[hook(2, 3)] = channel_order;

  w = get_image_width(a2);
  h = get_image_height(a2);
  array_sz = (int)get_image_array_size(a2);
  channel_data_type = get_image_channel_data_type(a2);
  channel_order = get_image_channel_order(a2);
  result[hook(2, 4)] = w;
  result[hook(2, 5)] = h;
  result[hook(2, 6)] = array_sz;
  result[hook(2, 7)] = channel_data_type;
  result[hook(2, 8)] = channel_order;
}