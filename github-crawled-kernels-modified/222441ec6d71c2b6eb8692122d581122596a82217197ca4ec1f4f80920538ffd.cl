//{"v_read":0,"v_write":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 2 | 0x10;
constant sampler_t hpSampler = 0 | 4 | 0x10;
kernel void restrictVolume(read_only image3d_t v_read, global float* v_write) {
  int4 writePos = {get_global_id(0), get_global_id(1), get_global_id(2), 0};

  int4 size = {get_global_size(0) * 2, get_global_size(1) * 2, get_global_size(2) * 2, 0};
  int4 pos = writePos * 2;
  pos = select(pos, size - 3, pos >= size - 1);

  const int4 readPos = pos;
  const float value = 0.125 * (read_imagef(v_read, hpSampler, readPos + (int4)(0, 0, 0, 0)).x + read_imagef(v_read, hpSampler, readPos + (int4)(1, 0, 0, 0)).x + read_imagef(v_read, hpSampler, readPos + (int4)(0, 1, 0, 0)).x + read_imagef(v_read, hpSampler, readPos + (int4)(0, 0, 1, 0)).x + read_imagef(v_read, hpSampler, readPos + (int4)(1, 1, 0, 0)).x + read_imagef(v_read, hpSampler, readPos + (int4)(0, 1, 1, 0)).x + read_imagef(v_read, hpSampler, readPos + (int4)(1, 1, 1, 0)).x + read_imagef(v_read, hpSampler, readPos + (int4)(1, 0, 1, 0)).x);

  v_write[hook(1, writePos.x + writePos.y * get_global_size(0) + writePos.z * get_global_size(0) * get_global_size(1))] = value;
}