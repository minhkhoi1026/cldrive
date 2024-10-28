//{"img1d_array":4,"img1d_buffer":3,"img2d_array":5,"img3":2,"in_img":1,"out":6,"out_img":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_images(write_only image1d_t out_img, read_only image2d_t in_img, read_only image3d_t img3, read_only image1d_buffer_t img1d_buffer, write_only image1d_array_t img1d_array, read_only image2d_array_t img2d_array, global int* out) {
  out[hook(6, 0)] = get_image_width(in_img);
  out[hook(6, 1)] = get_image_height(in_img);
  out[hook(6, 2)] = get_image_width(out_img);
  out[hook(6, 3)] = get_image_depth(img3);
  out[hook(6, 4)] = get_image_array_size(img2d_array);
  out[hook(6, 5)] = get_image_channel_data_type(img1d_buffer);
  out[hook(6, 6)] = get_image_channel_order(img3);

  float4 float3 = read_imagef(in_img, (int2)(0, 0));
  write_imagef(out_img, 0, float3.x);

  sampler_t sampler;

  int4 tmp0 = read_imagei(img3, sampler, float3);
  uint4 tmp1 = read_imageui(img3, tmp0);

  out[hook(6, 7)] = tmp1.x;
}