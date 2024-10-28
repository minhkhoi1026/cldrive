//{"filter":3,"input_img":0,"output_img":1,"sampler":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant float filter[9] = {1.0f / 9, 1.0f / 9, 1.0f / 9, 1.0f / 9, 1.0f / 9, 1.0f / 9, 1.0f / 9, 1.0f / 9, 1.0f / 9};

constant int filter_size = 3;
kernel void do_filter(read_only image2d_t input_img, write_only image2d_t output_img, sampler_t sampler) {
  int2 imdim = get_image_dim(input_img);
  int x = get_global_id(0);
  int y = get_global_id(1);

  if ((x < imdim.x) && (y < imdim.y)) {
    int half_filter = filter_size / 2;
    uint4 px_val;
    float4 px_filt = {0.0f, 0.0f, 0.0f, 0.0f};
    uint4 px_filt_int;
    int i, j, filter_i, filter_j;

    for (i = -half_filter, filter_i = 0; i <= half_filter; i++, filter_i++) {
      for (j = -half_filter, filter_j = 0; j <= half_filter; j++, filter_j++) {
        px_val = read_imageui(input_img, sampler, (int2)(x + i, y + j));
        px_filt += filter[hook(3, filter_i * filter_size + filter_j)] * convert_float4(px_val);
      }
    }

    px_filt_int = convert_uint4(px_filt);
    write_imageui(output_img, (int2)(x, y), px_filt_int);
  }
}