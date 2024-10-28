//{"v_l_p1":0,"v_l_write":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 2 | 0x10;
constant sampler_t hpSampler = 0 | 4 | 0x10;
kernel void prolongate2(read_only image3d_t v_l_p1, global float* v_l_write) {
  const int4 writePos = {get_global_id(0), get_global_id(1), get_global_id(2), 0};
  const int4 readPos = convert_int4(floor(convert_float4(writePos) / 2.0f));

  v_l_write[hook(1, writePos.x + writePos.y * get_global_size(0) + writePos.z * get_global_size(0) * get_global_size(1))] = read_imagef(v_l_p1, hpSampler, readPos).x;
}