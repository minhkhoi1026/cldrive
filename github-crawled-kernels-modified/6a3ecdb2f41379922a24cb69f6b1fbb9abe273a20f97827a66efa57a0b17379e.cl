//{"eps":4,"global_size_dim0":0,"global_size_dim1":1,"input":2,"output":6,"scale":3,"width":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t SAMPLER = 0 | 4 | 0x10;
kernel void BatchNorm(private const int global_size_dim0, private const int global_size_dim1, read_only image2d_t input, read_only image2d_t scale, read_only image2d_t eps, private const int width, write_only image2d_t output) {
  const int cw_idx = get_global_id(0);
  const int hb_idx = get_global_id(1);

  if (cw_idx >= global_size_dim0 || hb_idx >= global_size_dim1) {
    return;
  };

  const int chan_blk_idx = cw_idx / width;

  float4 data = read_imagef(input, SAMPLER, (int2)(cw_idx, hb_idx));
  float4 scale_ = read_imagef(scale, SAMPLER, (int2)(chan_blk_idx, 0));
  float4 eps_ = read_imagef(eps, SAMPLER, (int2)(chan_blk_idx, 0));
  data = mad(data, scale_, eps_);

  write_imagef(output, (int2)(cw_idx, hb_idx), data);
}