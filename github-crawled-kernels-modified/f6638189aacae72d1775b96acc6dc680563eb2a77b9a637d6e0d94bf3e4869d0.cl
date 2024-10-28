//{"bias":5,"coef_matrix":3,"coef_matrix_dim":2,"div":4,"dst":0,"src":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void convolution_global(write_only image2d_t dst, read_only image2d_t src, int coef_matrix_dim, constant float* coef_matrix, float div, float bias) {
  const sampler_t sampler = (0 | 2 | 0x10);

  const int half_matrix_dim = (coef_matrix_dim / 2);
  int2 loc = (int2)(get_global_id(0), get_global_id(1));
  float4 convPix = (float4)(0.0f, 0.0f, 0.0f, 0.0f);

  for (int conv_i = -half_matrix_dim; conv_i <= half_matrix_dim; conv_i++) {
    for (int conv_j = -half_matrix_dim; conv_j <= half_matrix_dim; conv_j++) {
      float4 px = read_imagef(src, sampler, loc + (int2)(conv_j, conv_i));
      convPix += px * coef_matrix[hook(3, (conv_i + half_matrix_dim) * coef_matrix_dim + (conv_j + half_matrix_dim))];
    }
  }
  float4 dstPix = convPix * div + bias;
  write_imagef(dst, loc, dstPix);
}