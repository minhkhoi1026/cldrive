//{"v_l_p1":1,"v_l_read":0,"v_l_write":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 2 | 0x10;
constant sampler_t hpSampler = 0 | 4 | 0x10;
kernel void prolongate(read_only image3d_t v_l_read, read_only image3d_t v_l_p1, global float* v_l_write) {
  const int4 writePos = {get_global_id(0), get_global_id(1), get_global_id(2), 0};
  const int4 readPos = convert_int4(floor(convert_float4(writePos) / 2.0f));
  float value = read_imagef(v_l_read, hpSampler, writePos).x + read_imagef(v_l_p1, hpSampler, readPos).x;

  v_l_write[hook(2, writePos.x + writePos.y * get_global_size(0) + writePos.z * get_global_size(0) * get_global_size(1))] = value;
}