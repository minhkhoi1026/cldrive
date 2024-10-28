//{"channels":6,"eps":5,"global_size_dim0":0,"global_size_dim1":1,"global_size_dim2":2,"input":3,"output":8,"remain_channels":7,"scale":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t SAMPLER = 0 | 4 | 0x10;
kernel void normalize_kernel(private const int global_size_dim0, private const int global_size_dim1, private const int global_size_dim2, read_only image2d_t input, read_only image2d_t scale, private const float eps, private const int channels, private const int remain_channels, write_only image2d_t output) {
  const int chan_blk_idx = get_global_id(0);
  const int width_idx = get_global_id(1);
  const int hb_idx = get_global_id(2);

  if (chan_blk_idx >= global_size_dim0 || width_idx >= global_size_dim1 || hb_idx >= global_size_dim2) {
    return;
  };
  int chan_blks;
  if (0 == remain_channels) {
    chan_blks = global_size_dim0;
  } else {
    chan_blks = global_size_dim0 - 1;
  }

  const int width = global_size_dim1;

  int pos = width_idx;
  float sum = 0;
  float4 scale_ = 0;
  float4 data;
  for (short i = 0; i < chan_blks; ++i) {
    data = read_imagef(input, SAMPLER, (int2)(pos, hb_idx));
    sum += data.x * data.x;
    sum += data.y * data.y;
    sum += data.z * data.z;
    sum += data.w * data.w;
    pos += width;
  }

  data = read_imagef(input, SAMPLER, (int2)(pos, hb_idx));
  switch (remain_channels) {
    case 1:
      sum += data.x * data.x;
      sum += data.y * data.y;
      sum += data.z * data.z;
    case 2:
      sum += data.x * data.x;
      sum += data.y * data.y;
    case 3:
      sum += data.x * data.x;
  }

  sum = 1.0f / sqrt(sum + eps);

  pos = mad24(chan_blk_idx, width, width_idx);

  data = read_imagef(input, SAMPLER, (int2)(pos, hb_idx));
  scale_ = read_imagef(scale, SAMPLER, (int2)(chan_blk_idx, 0));

  float4 sum_vec = (float4)(sum);
  data = data * sum_vec * scale_;

  write_imagef(output, (int2)(pos, hb_idx), data);
}