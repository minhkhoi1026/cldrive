//{"count":3,"global_size_dim0":0,"global_size_dim1":1,"input_ptr":2,"output":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t SAMPLER = 0 | 4 | 0x10;
kernel void ArgBufferToImage(private const int global_size_dim0, private const int global_size_dim1, global const float* input_ptr, private const int count, write_only image2d_t output) {
  int image_width_idx = get_global_id(0);
  int image_height_idx = get_global_id(1);

  if (image_width_idx >= global_size_dim0 || image_height_idx >= global_size_dim1) {
    return;
  };

  const int buffer_4_offset = image_width_idx << 2;
  const int remain = count - buffer_4_offset;

  int offset = buffer_4_offset;
  float4 values = 0;
  if (remain >= 4) {
    values = vload4(0, input_ptr + offset);
  } else if (remain == 3) {
    values.x = *(input_ptr + offset);
    offset++;
    values.y = *(input_ptr + offset);
    offset++;
    values.z = *(input_ptr + offset);
  } else if (remain == 2) {
    values.x = *(input_ptr + offset);
    offset++;
    values.y = *(input_ptr + offset);
  } else if (remain == 1) {
    values.x = *(input_ptr + offset);
  }
  write_imagef(output, (int2)(image_width_idx, image_height_idx), values);
}