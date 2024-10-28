//{"alpha":5,"input":0,"model_in":1,"model_last":4,"model_out":3,"update_mask":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 0x10 | 2;
kernel void update_model(read_only image2d_t input, read_only image2d_t model_in, read_only image2d_t update_mask, write_only image2d_t model_out, write_only image2d_t model_last, float alpha) {
  int2 pos = (int2)(get_global_id(0), get_global_id(1));

  uint4 out_pxl;
  uint4 mask_pxl = read_imageui(update_mask, sampler, pos);

  if (mask_pxl.s0 == 0) {
    float4 model_pxl = convert_float4(read_imageui(model_in, sampler, pos));
    float4 input_pxl = convert_float4(read_imageui(input, sampler, pos));
    out_pxl = convert_uint4((model_pxl * (1 - alpha)) + (input_pxl * alpha));
  } else {
    out_pxl = read_imageui(model_in, sampler, pos);
  }

  barrier(0x02);
  write_imageui(model_out, pos, out_pxl);
  write_imageui(model_last, pos, out_pxl);
}