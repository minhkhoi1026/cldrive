//{"init_vector_field":0,"mu":3,"read_vector_field":1,"vectorField":0,"vectorFieldFinal":1,"write_vector_field":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 2 | 0x10;
kernel __attribute__((reqd_work_group_size(16, 16, 1))) void GVF2DIteration(read_only image2d_t init_vector_field, read_only image2d_t read_vector_field, write_only image2d_t write_vector_field, private float mu) {
  int2 pos = {get_global_id(0), get_global_id(1)};

  float2 v = read_imagef(read_vector_field, sampler, pos).xy;

  float2 init_vector = read_imagef(init_vector_field, sampler, pos).xy;

  float2 fx1, fx_1, fy1, fy_1;
  fx1 = read_imagef(read_vector_field, sampler, pos + (int2)(1, 0)).xy;
  fy1 = read_imagef(read_vector_field, sampler, pos + (int2)(0, 1)).xy;
  fx_1 = read_imagef(read_vector_field, sampler, pos - (int2)(1, 0)).xy;
  fy_1 = read_imagef(read_vector_field, sampler, pos - (int2)(0, 1)).xy;

  float2 laplacian = -4 * v + fx1 + fx_1 + fy1 + fy_1;

  v += mu * laplacian - (v - init_vector) * (init_vector.x * init_vector.x + init_vector.y * init_vector.y);

  write_imagef(write_vector_field, pos, (float4)(v.x, v.y, 0, 0));
}

kernel void GVF2DResult(read_only image2d_t vectorField, write_only image2d_t vectorFieldFinal) {
  int2 pos = {get_global_id(0), get_global_id(1)};
  float4 vector = read_imagef(vectorField, sampler, pos);
  write_imagef(vectorFieldFinal, pos, vector);
}