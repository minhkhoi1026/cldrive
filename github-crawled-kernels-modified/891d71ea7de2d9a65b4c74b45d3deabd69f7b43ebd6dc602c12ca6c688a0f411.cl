//{"mu":3,"newResidual":5,"r":0,"spacing":4,"sqrMag":2,"v":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 2 | 0x10;
constant sampler_t hpSampler = 0 | 4 | 0x10;
kernel void residual(read_only image3d_t r, read_only image3d_t v, read_only image3d_t sqrMag, private float mu, private float spacing, global float* newResidual) {
  int4 writePos = {get_global_id(0), get_global_id(1), get_global_id(2), 0};

  int4 size = {get_global_size(0), get_global_size(1), get_global_size(2), 0};
  int4 pos = writePos;
  pos = select(pos, (int4)(2, 2, 2, 0), pos == (int4)(0, 0, 0, 0));
  pos = select(pos, size - 3, pos >= size - 1);

  const float value = read_imagef(r, hpSampler, pos).x - ((mu * (read_imagef(v, hpSampler, pos + (int4)(1, 0, 0, 0)).x + read_imagef(v, hpSampler, pos - (int4)(1, 0, 0, 0)).x + read_imagef(v, hpSampler, pos + (int4)(0, 1, 0, 0)).x + read_imagef(v, hpSampler, pos - (int4)(0, 1, 0, 0)).x + read_imagef(v, hpSampler, pos + (int4)(0, 0, 1, 0)).x + read_imagef(v, hpSampler, pos - (int4)(0, 0, 1, 0)).x - 6 * read_imagef(v, hpSampler, pos).x) / (spacing * spacing)) - read_imagef(sqrMag, hpSampler, pos).x * read_imagef(v, hpSampler, pos).x);

  newResidual[hook(5, writePos.x + writePos.y * get_global_size(0) + writePos.z * get_global_size(0) * get_global_size(1))] = value;
}