//{"data_limit":4,"in_buf":0,"log":5,"out_image":1,"tsf_image":2,"tsf_sampler":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void scatteringDataToImage(global float* in_buf, write_only image2d_t out_image, read_only image2d_t tsf_image, sampler_t tsf_sampler, float2 data_limit, int log) {
  int2 id_glb = (int2)(get_global_id(0), get_global_id(1));
  int2 image_dim = get_image_dim(out_image);

  if ((id_glb.x < image_dim.x) && (id_glb.y < image_dim.y)) {
    float intensity = in_buf[hook(0, id_glb.y * image_dim.x + id_glb.x)];

    float2 tsf_position;
    float4 sample;

    if (log) {
      if (data_limit.x < 1.0) {
        float linear_fraction = (1.0 - data_limit.x) / (log10(data_limit.y) + (1.0 - data_limit.x));
        float log10_fraction = log10(data_limit.y) / (log10(data_limit.y) + (1.0 - data_limit.x));

        if (intensity < 0.0f) {
          tsf_position = (float2)(0.0f, 0.5f);
        } else if (intensity < 1.0) {
          tsf_position = (float2)(native_divide(intensity - data_limit.x, 1.0f - data_limit.x) * linear_fraction, 0.5f);
        } else {
          tsf_position = (float2)(linear_fraction + native_divide(log10(intensity), log10(data_limit.y)) * log10_fraction, 0.5f);
        }
      } else {
        if (intensity < data_limit.x) {
          tsf_position = (float2)(0.0f, 0.5f);
        } else {
          tsf_position = (float2)(native_divide(log10(intensity) - log10(data_limit.x), log10(data_limit.y) - log10(data_limit.x)), 0.5f);
        }
      }
    } else {
      tsf_position = (float2)(native_divide(intensity - data_limit.x, data_limit.y - data_limit.x), 0.5f);
    }

    sample = read_imagef(tsf_image, tsf_sampler, tsf_position);
    write_imagef(out_image, id_glb, sample);
  }
}