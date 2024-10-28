//{"mu":2,"r":0,"spacing":3,"sqrMag":1,"v_read":4,"v_write":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 2 | 0x10;
constant sampler_t hpSampler = 0 | 4 | 0x10;
kernel void GVFgaussSeidel2(read_only image3d_t r, read_only image3d_t sqrMag, private float mu, private float spacing, read_only image3d_t v_read, global float* v_write) {
  int4 writePos = {get_global_id(0), get_global_id(1), get_global_id(2), 0};

  int4 size = {get_global_size(0), get_global_size(1), get_global_size(2), 0};
  int4 pos = writePos;
  pos = select(pos, (int4)(2, 2, 2, 0), pos == (int4)(0, 0, 0, 0));
  pos = select(pos, size - 3, pos >= size - 1);

  int i = pos.x + pos.y + pos.z;
  float value;
  if (i % 2 == 0) {
    value = read_imagef(v_read, sampler, pos).x;
  } else {
    value = native_divide(2.0f * mu * (read_imagef(v_read, sampler, pos + (int4)(1, 0, 0, 0)).x + read_imagef(v_read, sampler, pos - (int4)(1, 0, 0, 0)).x + read_imagef(v_read, sampler, pos + (int4)(0, 1, 0, 0)).x + read_imagef(v_read, sampler, pos - (int4)(0, 1, 0, 0)).x + read_imagef(v_read, sampler, pos + (int4)(0, 0, 1, 0)).x + read_imagef(v_read, sampler, pos - (int4)(0, 0, 1, 0)).x) - 2.0f * spacing * spacing * read_imagef(r, sampler, pos).x, 12.0f * mu + spacing * spacing * read_imagef(sqrMag, sampler, pos).x);
  }

  v_write[hook(5, writePos.x + writePos.y * get_global_size(0) + writePos.z * get_global_size(0) * get_global_size(1))] = value;
}