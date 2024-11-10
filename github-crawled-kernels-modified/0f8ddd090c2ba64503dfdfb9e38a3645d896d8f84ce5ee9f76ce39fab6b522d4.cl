//{"bias":7,"global_size_dim0":0,"global_size_dim1":1,"height":4,"input_ptr":2,"output":3,"scale":6,"width":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t SAMPLER = 0 | 4 | 0x10;
kernel void RGBABufferToImage(private const int global_size_dim0, private const int global_size_dim1, global const uchar* input_ptr, write_only image2d_t output, private const int height, private const int width, private const float4 scale, private const float4 bias) {
  int image_width_idx = get_global_id(0);
  int image_height_idx = get_global_id(1);

  if (image_width_idx >= global_size_dim0 || image_height_idx >= global_size_dim1) {
    return;
  };

  const int batch_idx = image_height_idx / height;
  const int height_idx = image_height_idx % height;

  int buffer_offset = ((batch_idx * height + height_idx) * width + image_width_idx) * 4;

  float4 values = convert_float4(vload4(0, input_ptr + buffer_offset));
  int2 coord = (int2)(image_width_idx, image_height_idx);
  write_imagef(output, coord, values);
}