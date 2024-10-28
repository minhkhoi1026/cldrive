//{"bias":5,"global_size_dim0":0,"global_size_dim1":1,"input":3,"output":2,"scale":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t SAMPLER = 0 | 4 | 0x10;
kernel void ConvertToN32FC4Image(private const int global_size_dim0, private const int global_size_dim1, write_only image2d_t output, read_only image2d_t input, private const float4 scale, private const float4 bias) {
  int image_width_idx = get_global_id(0);
  int image_height_idx = get_global_id(1);

  if (image_width_idx >= global_size_dim0 || image_height_idx >= global_size_dim1) {
    return;
  };

  int2 coord = (int2)(image_width_idx, image_height_idx);
  float4 values = read_imagef(input, SAMPLER, coord);
  write_imagef(output, coord, values);
}