//{"blk_size":6,"crop_x":4,"crop_y":5,"img_uv":3,"img_uv_dst":2,"img_y":1,"img_y_dst":0,"sum":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mosaic(write_only image2d_t img_y_dst, read_only image2d_t img_y, write_only image2d_t img_uv_dst, read_only image2d_t img_uv, unsigned int crop_x, unsigned int crop_y, unsigned int blk_size, local float* sum) {
  sampler_t sampler = 0 | 2 | 0x10;
  size_t g_id_x = get_global_id(0);
  size_t g_id_y = get_global_id(1);
  size_t l_id_x = get_local_id(0);

  float4 Y;
  sum[hook(7, l_id_x)] = 0;
  for (unsigned int i = 0; i < blk_size; i++) {
    Y = read_imagef(img_y, (int2)(g_id_x + crop_x, g_id_y * blk_size + i + crop_y));
    sum[hook(7, l_id_x)] += Y.x;
  }
  barrier(0x01);
  if (l_id_x % blk_size == 0) {
    for (unsigned int i = 1; i < blk_size; i++) {
      sum[hook(7, l_id_x)] += sum[hook(7, l_id_x + i)];
    }
    sum[hook(7, l_id_x)] /= (blk_size * blk_size);
  }
  barrier(0x01);
  Y.x = sum[hook(7, l_id_x / blk_size * blk_size)];
  for (unsigned int i = 0; i < blk_size; i++) {
    write_imagef(img_y_dst, (int2)(g_id_x + crop_x, g_id_y * blk_size + i + crop_y), Y);
  }

  float4 UV;
  sum[hook(7, l_id_x)] = 0;
  for (unsigned int i = 0; i < blk_size / 2; i++) {
    UV = read_imagef(img_uv, (int2)(g_id_x + crop_x, g_id_y * blk_size / 2 + i + crop_y / 2));
    sum[hook(7, l_id_x)] += UV.x;
  }
  barrier(0x01);
  if (l_id_x % blk_size == 0 || l_id_x % blk_size == 1) {
    for (unsigned int i = 2; i < blk_size; i += 2) {
      sum[hook(7, l_id_x)] += sum[hook(7, l_id_x + i)];
    }
    sum[hook(7, l_id_x)] /= (blk_size * blk_size / 4);
  }
  barrier(0x01);
  if (l_id_x % 2 == 0) {
    UV.x = sum[hook(7, l_id_x / blk_size * blk_size)];
  } else {
    UV.x = sum[hook(7, l_id_x / blk_size * blk_size + 1)];
  }
  for (unsigned int i = 0; i < blk_size / 2; i++) {
    write_imagef(img_uv_dst, (int2)(g_id_x + crop_x, g_id_y * blk_size / 2 + i + crop_y / 2), UV);
  }
}