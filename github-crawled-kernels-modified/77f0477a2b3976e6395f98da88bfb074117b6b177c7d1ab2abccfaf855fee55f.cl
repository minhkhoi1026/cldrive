//{"global_size_dim0":0,"global_size_dim1":1,"global_size_dim2":2,"input":3,"output":5,"scale":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t SAMPLER = 0 | 4 | 0x10;
kernel void scale(private const int global_size_dim0, private const int global_size_dim1, private const int global_size_dim2, read_only image2d_t input, read_only image2d_t scale, write_only image2d_t output) {
  const int channel_block_idx = get_global_id(0);
  const int w = get_global_id(1);
  const int hb = get_global_id(2);

  if (channel_block_idx >= global_size_dim0 || w >= global_size_dim1 || hb >= global_size_dim2) {
    return;
  };
  const int width = global_size_dim1;

  const int pos = mad24(channel_block_idx, width, w);

  float4 in = read_imagef(input, SAMPLER, (int2)(pos, hb));
  float4 scale_value = read_imagef(scale, SAMPLER, (int2)(channel_block_idx, 0));

  float4 out = in * scale_value;

  write_imagef(output, (int2)(pos, hb), out);
}