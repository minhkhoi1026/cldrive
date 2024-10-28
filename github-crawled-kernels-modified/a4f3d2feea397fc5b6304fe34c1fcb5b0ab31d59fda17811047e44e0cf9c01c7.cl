//{"deviation":7,"image_size":3,"in_buf":0,"isCorrectionExposureActive":12,"isCorrectionFluxActive":11,"isCorrectionLorentzActive":4,"isCorrectionNoiseActive":8,"isCorrectionPixelProjectionActive":14,"isCorrectionPlaneActive":9,"isCorrectionPolarizationActive":10,"mean":6,"out_buf":1,"parameter":2,"plane":13,"task":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void processScatteringData(global float* in_buf, global float* out_buf, constant float* parameter, int2 image_size, int isCorrectionLorentzActive, int task, float mean, float deviation, int isCorrectionNoiseActive, int isCorrectionPlaneActive, int isCorrectionPolarizationActive, int isCorrectionFluxActive, int isCorrectionExposureActive, float4 plane, int isCorrectionPixelProjectionActive) {
  float noise_low = parameter[hook(2, 0)];
  float noise_high = parameter[hook(2, 1)];
  float pct_low = parameter[hook(2, 2)];
  float pct_high = parameter[hook(2, 3)];
  float flux = parameter[hook(2, 4)];
  float exp_time = parameter[hook(2, 5)];
  float wavelength = parameter[hook(2, 6)];
  float det_dist = parameter[hook(2, 7)];
  float beam_x = parameter[hook(2, 8)];
  float beam_y = parameter[hook(2, 9)];
  float pix_size_x = parameter[hook(2, 10)];
  float pix_size_y = parameter[hook(2, 11)];

  int2 id_glb = (int2)(get_global_id(0), get_global_id(1));

  if ((id_glb.x < image_size.x) && (id_glb.y < image_size.y)) {
    float4 Q = (float4)(0.0f);
    Q.w = in_buf[hook(0, id_glb.y * image_size.x + id_glb.x)];

    if (task == 0) {
      if (isCorrectionNoiseActive) {
        Q.w = clamp(Q.w, noise_low, noise_high);
        Q.w -= noise_low;
      }

      if (isCorrectionPlaneActive) {
        float plane_z = -(plane.x * (float)id_glb.x + plane.y * (float)id_glb.y + plane.w) / plane.z;

        if (plane_z < 0) {
          plane_z = 0;
        }

        Q.w = clamp(Q.w, plane_z, noise_high);
        Q.w -= plane_z;
      }

      float3 OP = (float3)(-det_dist, pix_size_x * ((float)(image_size.y - id_glb.y - 0.5) - beam_x),

                           pix_size_y * ((float)-((id_glb.x + 0.5) - beam_y)));

      float k = 1.0 / wavelength;

      if (isCorrectionPixelProjectionActive) {
        float forward_projected_area;
        {
          float3 a_vec = k * normalize((float3)(-det_dist, (float)pix_size_x * 0.5, -(float)pix_size_y * 0.5));
          float3 b_vec = k * normalize((float3)(-det_dist, -(float)pix_size_x * 0.5, -(float)pix_size_y * 0.5));
          float3 c_vec = k * normalize((float3)(-det_dist, -(float)pix_size_x * 0.5, (float)pix_size_y * 0.5));
          float3 d_vec = k * normalize((float3)(-det_dist, (float)pix_size_x * 0.5, (float)pix_size_y * 0.5));

          float3 ab_vec = b_vec - a_vec;
          float3 ac_vec = c_vec - a_vec;
          float3 ad_vec = d_vec - a_vec;

          forward_projected_area = 0.5 * fabs(length(cross(ab_vec, ac_vec))) + 0.5 * fabs(length(cross(ac_vec, ad_vec)));
        }

        float projected_area;
        {
          float3 a_vec = k * normalize(convert_float3(OP) + (float3)(0, (float)pix_size_x * 0.5, -(float)pix_size_y * 0.5));
          float3 b_vec = k * normalize(convert_float3(OP) + (float3)(0, -(float)pix_size_x * 0.5, -(float)pix_size_y * 0.5));
          float3 c_vec = k * normalize(convert_float3(OP) + (float3)(0, -(float)pix_size_x * 0.5, (float)pix_size_y * 0.5));
          float3 d_vec = k * normalize(convert_float3(OP) + (float3)(0, (float)pix_size_x * 0.5, (float)pix_size_y * 0.5));

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
    } else if (task == 1) {
      out_buf[hook(1, id_glb.y * image_size.x + id_glb.x)] = pow(Q.w - mean, 2.0f);
    } else if (task == 2) {
      out_buf[hook(1, id_glb.y * image_size.x + id_glb.x)] = pow((Q.w - mean) / deviation, 3.0f);
    } else if (task == 3) {
      out_buf[hook(1, id_glb.y * image_size.x + id_glb.x)] = Q.w * ((float)id_glb.x + 0.5f);
    } else if (task == 4) {
      out_buf[hook(1, id_glb.y * image_size.x + id_glb.x)] = Q.w * ((float)id_glb.y + 0.5f);
    } else {
      out_buf[hook(1, id_glb.y * image_size.x + id_glb.x)] = (float)id_glb.y * image_size.x + id_glb.x;
    }
  }
}