//{"eps":5,"global_size_dim0":0,"global_size_dim1":1,"global_size_dim2":2,"input":3,"output":6,"scale":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t SAMPLER = 0 | 4 | 0x10;
kernel void BatchNormGS3D(private const int global_size_dim0, private const int global_size_dim1, private const int global_size_dim2, read_only image2d_t input, read_only image2d_t scale, read_only image2d_t eps, write_only image2d_t output) {
  const int width_idx = get_global_id(0);
  const int chan_blk_idx = get_global_id(1);
  const int hb_idx = get_global_id(2);

  if (width_idx >= global_size_dim0 || chan_blk_idx >= global_size_dim1 || hb_idx >= global_size_dim2) {
    return;
  };
  const int width = global_size_dim0;

  int pos = mad24(chan_blk_idx, width, width_idx);

  float4 data = read_imagef(input, SAMPLER, (int2)(pos, hb_idx));
  float4 scale_ = read_imagef(scale, SAMPLER, (int2)(chan_blk_idx, 0));
  float4 eps_ = read_imagef(eps, SAMPLER, (int2)(chan_blk_idx, 0));
  data = mad(data, scale_, eps_);

  write_imagef(output, (int2)(pos, hb_idx), data);
}