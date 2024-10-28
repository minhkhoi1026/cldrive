//{"init_vector_field":0,"mu":3,"read_vector_field":1,"write_vector_field":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 2 | 0x10;
kernel void GVF2DIteration(read_only image2d_t init_vector_field, read_only image2d_t read_vector_field, write_only image2d_t write_vector_field, private float mu) {
  int2 writePos = {get_global_id(0), get_global_id(1)};

  int2 size = {get_global_size(0), get_global_size(1)};
  int2 pos = writePos;
  pos = select(pos, (int2)(2, 2), pos == (int2)(0, 0));
  pos = select(pos, size - 3, pos >= size - 1);

  float2 f = read_imagef(read_vector_field, sampler, pos).xy;

  const float2 init_vector = read_imagef(init_vector_field, sampler, pos).xy;

  const float2 fx1 = read_imagef(read_vector_field, sampler, pos + (int2)(1, 0)).xy;
  const float2 fy1 = read_imagef(read_vector_field, sampler, pos + (int2)(0, 1)).xy;
  const float2 fx_1 = read_imagef(read_vector_field, sampler, pos - (int2)(1, 0)).xy;
  const float2 fy_1 = read_imagef(read_vector_field, sampler, pos - (int2)(0, 1)).xy;

  float2 laplacian = -4 * f + fx1 + fx_1 + fy1 + fy_1;

  f += mu * laplacian - (f - init_vector) * (init_vector.x * init_vector.x + init_vector.y * init_vector.y);

  write_imagef(write_vector_field, writePos, (float4)(f.x, f.y, 0, 0));
}