//{"buf":2,"img":0,"num_pixels_per_workitem":1,"tmp":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 2 | 0x10;
kernel void histogram(image2d_t img, int num_pixels_per_workitem, global unsigned int* buf) {
  int local_size = get_local_size(0) * get_local_size(1);
  int item_offset = get_local_id(0) + get_local_id(1) * get_local_size(0);
  local unsigned int tmp[256];

  int i = 0, j = 256;
  do {
    if (item_offset < j)
      tmp[hook(3, item_offset + i)] = 0;
    j -= local_size;
    i += local_size;
  } while (j > 0);

  barrier(0x01);

  int x, image_width = get_image_width(img), image_height = get_image_height(img);
  for (i = 0, x = get_global_id(0); i < num_pixels_per_workitem; ++i, x += get_global_size(0)) {
    if (x < image_width && get_global_id(1) < image_height) {
      float4 clr = read_imagef(img, sampler, (int2)(x, get_global_id(1)));
      if (clr.w > 0.99f) {
        float v = (clr.x + clr.y + clr.z) / 3.0f;
        atom_inc(&tmp[hook(3, convert_ushort_sat(min(v, 1.F) * 255.F))]);
      }
    }
  }

  barrier(0x01);

  int group_offset = (get_group_id(0) + get_group_id(1) * get_num_groups(0)) * 256;
  i = 0;
  j = 256;
  do {
    if (item_offset < j)
      buf[hook(2, group_offset + item_offset + i)] = tmp[hook(3, item_offset + i)];
    j -= local_size;
    i += local_size;
  } while (j > 0);
}