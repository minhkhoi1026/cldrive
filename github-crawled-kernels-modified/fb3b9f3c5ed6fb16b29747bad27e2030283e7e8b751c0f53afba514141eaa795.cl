//{"component":4,"mu":2,"newResidual":5,"spacing":3,"v":1,"vectorField":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 2 | 0x10;
constant sampler_t hpSampler = 0 | 4 | 0x10;
kernel void fmgResidual(read_only image3d_t vectorField, read_only image3d_t v, private float mu, private float spacing, private int component, global float* newResidual) {
  int4 writePos = {get_global_id(0), get_global_id(1), get_global_id(2), 0};

  int4 size = {get_global_size(0), get_global_size(1), get_global_size(2), 0};
  int4 pos = writePos;
  pos = select(pos, (int4)(2, 2, 2, 0), pos == (int4)(0, 0, 0, 0));
  pos = select(pos, size - 3, pos >= size - 1);

  float4 vector = read_imagef(vectorField, sampler, pos);
  float v0;
  if (component == 1) {
    v0 = vector.x;
  } else if (component == 2) {
    v0 = vector.y;
  } else {
    v0 = vector.z;
  }
  const float sqrMag = vector.x * vector.x + vector.y * vector.y + vector.z * vector.z;

  float residue = (mu * (read_imagef(v, hpSampler, pos + (int4)(1, 0, 0, 0)).x + read_imagef(v, hpSampler, pos - (int4)(1, 0, 0, 0)).x + read_imagef(v, hpSampler, pos + (int4)(0, 1, 0, 0)).x + read_imagef(v, hpSampler, pos - (int4)(0, 1, 0, 0)).x + read_imagef(v, hpSampler, pos + (int4)(0, 0, 1, 0)).x + read_imagef(v, hpSampler, pos - (int4)(0, 0, 1, 0)).x - 6 * read_imagef(v, hpSampler, pos).x)) / (spacing * spacing);

  const float value = -sqrMag * v0 - (residue - sqrMag * read_imagef(v, hpSampler, pos).x);

  newResidual[hook(5, writePos.x + writePos.y * get_global_size(0) + writePos.z * get_global_size(0) * get_global_size(1))] = value;
}