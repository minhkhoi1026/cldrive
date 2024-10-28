//{"init_vector_field":0,"mu":3,"read_vector_field":1,"write_vector_field":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 2 | 0x10;
kernel void GVF3DIteration(read_only image3d_t init_vector_field, global float const* restrict read_vector_field, global float* write_vector_field, private float mu) {
  int4 writePos = {get_global_id(0), get_global_id(1), get_global_id(2), 0};

  int4 size = {get_global_size(0), get_global_size(1), get_global_size(2), 0};
  int4 pos = writePos;
  pos = select(pos, (int4)(2, 2, 2, 0), pos == (int4)(0, 0, 0, 0));
  pos = select(pos, size - 3, pos >= size - 1);
  int offset = pos.x + pos.y * size.x + pos.z * size.x * size.y;

  float4 init_vector = read_imagef(init_vector_field, sampler, pos);

  float3 v = vload3(offset, read_vector_field);
  float3 fx1 = vload3(offset + 1, read_vector_field);
  float3 fx_1 = vload3(offset - 1, read_vector_field);
  float3 fy1 = vload3(offset + size.x, read_vector_field);
  float3 fy_1 = vload3(offset - size.x, read_vector_field);
  float3 fz1 = vload3(offset + size.x * size.y, read_vector_field);
  float3 fz_1 = vload3(offset - size.x * size.y, read_vector_field);

  float3 laplacian = -6 * v.xyz + fx1 + fx_1 + fy1 + fy_1 + fz1 + fz_1;

  v += mu * laplacian - (v - init_vector.xyz) * init_vector.w;

  vstore3(v, writePos.x + writePos.y * size.x + writePos.z * size.x * size.y, write_vector_field);
}