//{"angle_increment":10,"beam_x":7,"beam_y":8,"detector_distance":6,"image_size":15,"in_buf":1,"kappa":11,"omega":13,"out_buf":0,"phi":12,"pixel_size_x":3,"pixel_size_y":4,"sample_rotation_matrix":2,"selection":14,"start_angle":9,"wavelength":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void projectScatteringData(global float4* out_buf, global float* in_buf, constant float* sample_rotation_matrix, float pixel_size_x, float pixel_size_y, float wavelength, float detector_distance, float beam_x, float beam_y, float start_angle, float angle_increment, float kappa, float phi, float omega, int4 selection, int2 image_size) {
  int2 id_glb = (int2)(get_global_id(0), get_global_id(1));

  if ((id_glb.x < image_size.x) && (id_glb.y < image_size.y)) {
    float4 Q = (float4)(0.0f);

    if ((id_glb.x >= selection.x) && (id_glb.x < selection.y) && (id_glb.y >= selection.z) && (id_glb.y < selection.w)) {
      Q.w = in_buf[hook(1, id_glb.y * image_size.x + id_glb.x)];
      float3 OP = (float3)(-detector_distance, pixel_size_x * ((float)(image_size.y - 0.5f - id_glb.y) - beam_x),

                           pixel_size_y * ((float)-((id_glb.x + 0.5) - beam_y)));

      float k = 1.0f / wavelength;

      float3 k_i = (float3)(-k, 0, 0);
      float3 k_f = k * normalize(OP);

      Q.xyz = k_f - k_i;

      float3 temp = Q.xyz;

      Q.x = temp.x * sample_rotation_matrix[hook(2, 0)] + temp.y * sample_rotation_matrix[hook(2, 1)] + temp.z * sample_rotation_matrix[hook(2, 2)];
      Q.y = temp.x * sample_rotation_matrix[hook(2, 4)] + temp.y * sample_rotation_matrix[hook(2, 5)] + temp.z * sample_rotation_matrix[hook(2, 6)];
      Q.z = temp.x * sample_rotation_matrix[hook(2, 8)] + temp.y * sample_rotation_matrix[hook(2, 9)] + temp.z * sample_rotation_matrix[hook(2, 10)];

    } else {
      Q.w = 0.0f;
    }

    out_buf[hook(0, id_glb.y * image_size.x + id_glb.x)] = Q;
  }
}