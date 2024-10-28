//{"bias":6,"channels":4,"global_size_dim0":0,"global_size_dim1":1,"input":2,"output":3,"scale":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t SAMPLER = 0 | 4 | 0x10;
kernel void ConvertFromN32FC4Image(private const int global_size_dim0, private const int global_size_dim1, read_only image2d_t input, write_only image2d_t output, private const int channels, private const float4 scale, private const float4 bias) {
  int image_width_idx = get_global_id(0);
  int image_height_idx = get_global_id(1);

  if (image_width_idx >= global_size_dim0 || image_height_idx >= global_size_dim1) {
    return;
  };

  int2 coord = (int2)(image_width_idx, image_height_idx);
  float4 values = read_imagef(input, SAMPLER, coord);

  if (channels == 3) {
    values.w = 0;
  }
  write_imagef(output, coord, values);
}