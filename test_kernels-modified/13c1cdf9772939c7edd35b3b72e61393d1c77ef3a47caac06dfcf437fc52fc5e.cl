//{"input":1,"output":0,"shared":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void QuasiRandomSequence(global float4* output, global uint4* input, local uint4* shared) {
  unsigned int global_id = get_global_id(0);
  unsigned int local_id = get_local_id(0);
  unsigned int group_id = get_group_id(0);

  for (int i = 0; i < 32 / 4; i++) {
    shared[hook(2, i)] = input[hook(1, group_id * 32 / 4 + i)];
  }

  uint4 temp = 0;

  unsigned int factor = local_id * 4;

  uint4 vlid = (uint4)(factor, factor + 1, factor + 2, factor + 3);

  for (int k = 0; k < 32 / 4; k++) {
    unsigned int fK = k * 4;
    uint4 vK = (uint4)(fK, fK + 1, fK + 2, fK + 3);

    uint4 two = (uint4)(2, 2, 2, 2);

    uint4 mask = (uint4)(pow(2.0f, (float)vK.x), pow(2.0f, (float)vK.y), pow(2.0f, (float)vK.z), pow(2.0f, (float)vK.w));

    temp.x ^= (((vlid.x & mask.x) >> vK.x) * shared[hook(2, k)].x) ^ (((vlid.x & mask.y) >> vK.y) * shared[hook(2, k)].y) ^ (((vlid.x & mask.z) >> vK.z) * shared[hook(2, k)].z) ^ (((vlid.x & mask.w) >> vK.w) * shared[hook(2, k)].w);

    temp.y ^= (((vlid.y & mask.x) >> vK.x) * shared[hook(2, k)].x) ^ (((vlid.y & mask.y) >> vK.y) * shared[hook(2, k)].y) ^ (((vlid.y & mask.z) >> vK.z) * shared[hook(2, k)].z) ^ (((vlid.y & mask.w) >> vK.w) * shared[hook(2, k)].w);

    temp.z ^= (((vlid.z & mask.x) >> vK.x) * shared[hook(2, k)].x) ^ (((vlid.z & mask.y) >> vK.y) * shared[hook(2, k)].y) ^ (((vlid.z & mask.z) >> vK.z) * shared[hook(2, k)].z) ^ (((vlid.z & mask.w) >> vK.w) * shared[hook(2, k)].w);

    temp.w ^= (((vlid.w & mask.x) >> vK.x) * shared[hook(2, k)].x) ^ (((vlid.w & mask.y) >> vK.y) * shared[hook(2, k)].y) ^ (((vlid.w & mask.z) >> vK.z) * shared[hook(2, k)].z) ^ (((vlid.w & mask.w) >> vK.w) * shared[hook(2, k)].w);
  }

  output[hook(0, global_id)] = convert_float4(temp) / (float)pow(2.0f, 32.0f);
}