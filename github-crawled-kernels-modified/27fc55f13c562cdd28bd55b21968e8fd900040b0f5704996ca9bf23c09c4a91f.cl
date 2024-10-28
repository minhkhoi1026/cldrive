//{"beam_center_x":11,"beam_center_y":12,"detector_distance":10,"exposure_time":17,"flux":16,"image_size":2,"in_buf":0,"isCorrectionExposureActive":8,"isCorrectionFluxActive":7,"isCorrectionLorentzActive":3,"isCorrectionNoiseActive":4,"isCorrectionPixelProjectionActive":9,"isCorrectionPlaneActive":5,"isCorrectionPolarizationActive":6,"noise_low":18,"out_buf":1,"pixel_size_x":13,"pixel_size_y":14,"wavelength":15}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void correctScatteringData(global float* in_buf, global float* out_buf, int2 image_size, int isCorrectionLorentzActive, int isCorrectionNoiseActive, int isCorrectionPlaneActive, int isCorrectionPolarizationActive, int isCorrectionFluxActive, int isCorrectionExposureActive, int isCorrectionPixelProjectionActive, float detector_distance, float beam_center_x, float beam_center_y, float pixel_size_x, float pixel_size_y, float wavelength, float flux, float exposure_time, float noise_low) {
  int2 id_glb = (int2)(get_global_id(0), get_global_id(1));

  if ((id_glb.x < image_size.x) && (id_glb.y < image_size.y)) {
    float4 Q = (float4)(0.0f);
    Q.w = in_buf[hook(0, id_glb.y * image_size.x + id_glb.x)];

    if (isCorrectionNoiseActive) {
      Q.w = clamp(Q.w, noise_low, Q.w);
      Q.w -= noise_low;
    }
    float3 OP = (float3)(-detector_distance, pixel_size_x * ((float)(image_size.y - id_glb.y - 0.5) - beam_center_x),

                         pixel_size_y * ((float)-((id_glb.x + 0.5) - beam_center_y)));

    float k = 1.0 / wavelength;

    if (isCorrectionPixelProjectionActive) {
      float forward_projected_area;
      {
        float3 a_vec = k * normalize((float3)(-detector_distance, (float)pixel_size_x * 0.5, -(float)pixel_size_y * 0.5));
        float3 b_vec = k * normalize((float3)(-detector_distance, -(float)pixel_size_x * 0.5, -(float)pixel_size_y * 0.5));
        float3 c_vec = k * normalize((float3)(-detector_distance, -(float)pixel_size_x * 0.5, (float)pixel_size_y * 0.5));
        float3 d_vec = k * normalize((float3)(-detector_distance, (float)pixel_size_x * 0.5, (float)pixel_size_y * 0.5));

        float3 ab_vec = b_vec - a_vec;
        float3 ac_vec = c_vec - a_vec;
        float3 ad_vec = d_vec - a_vec;

        forward_projected_area = 0.5 * fabs(length(cross(ab_vec, ac_vec))) + 0.5 * fabs(length(cross(ac_vec, ad_vec)));
      }

      float projected_area;
      {
        float3 a_vec = k * normalize(convert_float3(OP) + (float3)(0, (float)pixel_size_x * 0.5, -(float)pixel_size_y * 0.5));
        float3 b_vec = k * normalize(convert_float3(OP) + (float3)(0, -(float)pixel_size_x * 0.5, -(float)pixel_size_y * 0.5));
        float3 c_vec = k * normalize(convert_float3(OP) + (float3)(0, -(float)pixel_size_x * 0.5, (float)pixel_size_y * 0.5));
        float3 d_vec = k * normalize(convert_float3(OP) + (float3)(0, (float)pixel_size_x * 0.5, (float)pixel_size_y * 0.5));

        float3 ab_vec = b_vec - a_vec;
        float3 ac_vec = c_vec - a_vec;
        float3 ad_vec = d_vec - a_vec;

        projected_area = 0.5 * fabs(length(cross(ab_vec, ac_vec))) + 0.5 * fabs(length(cross(ac_vec, ad_vec)));
      }

      Q.w = Q.w * (forward_projected_area / projected_area);
    }

    float3 k_i = (float3)(-k, 0, 0);
    float3 k_f = k * normalize(OP);

    Q.xyz = k_f - k_i;

    {
      if (isCorrectionLorentzActive) {
        float3 axis_rot = (float3)(0.0f, 0.0f, 1.0f);
        Q.w *= wavelength * fabs((dot(cross(normalize(axis_rot), Q.xyz), normalize(k_f))));
      }
    }

    out_buf[hook(1, id_glb.y * image_size.x + id_glb.x)] = Q.w;
  }
}