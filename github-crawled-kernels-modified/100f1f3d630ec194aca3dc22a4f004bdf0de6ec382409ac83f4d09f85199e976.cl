//{"bias":7,"global_size_dim0":0,"global_size_dim1":1,"height":4,"input_ptr":2,"output":3,"scale":6,"width":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t SAMPLER = 0 | 4 | 0x10;
kernel void NV21ToImage(private const int global_size_dim0, private const int global_size_dim1, global const uchar* input_ptr, write_only image2d_t output, private const int height, private const int width, private const float4 scale, private const float4 bias) {
  int image_width_idx = get_global_id(0);
  int image_height_idx = get_global_id(1);

  if (image_width_idx >= global_size_dim0 || image_height_idx >= global_size_dim1) {
    return;
  };

  int y_offset = image_height_idx * width + image_width_idx;
  int v_offset = width * height + (image_height_idx >> 1) * width + (image_width_idx & (~(0x01)));
  int u_offset = v_offset + 1;

  int y = (int)(input_ptr[hook(2, y_offset)]);
  int u = (int)(input_ptr[hook(2, u_offset)]);
  int v = (int)(input_ptr[hook(2, v_offset)]);

  u -= 128;
  v -= 128;

  int r = y + v + ((v * 103) >> 8);
  int g = y - ((u * 88) >> 8) - ((v * 183) >> 8);
  int b = y + u + ((u * 198) >> 8);

  r = clamp(r, 0, 255);
  g = clamp(g, 0, 255);
  b = clamp(b, 0, 255);

  float4 values = (float4)((float)r, (float)g, (float)b, (float)0.0f);
  int2 coord = (int2)(image_width_idx, image_height_idx);
  write_imagef(output, coord, values);
}