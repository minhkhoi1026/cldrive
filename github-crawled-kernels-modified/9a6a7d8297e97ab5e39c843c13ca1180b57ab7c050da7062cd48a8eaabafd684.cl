//{"in":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 4 | 0x10;
float alphaVal(int alphaIdx) {
  return alphaIdx / 4.0f - 1.0f;
}

kernel void processColumns(read_only image2d_t in, global int* out) {
  const int h = get_image_height(in);
  const int alphaIdx = get_global_id(1);
  const float alpha = alphaVal(alphaIdx);
  const int xOffset = get_global_id(0) + alpha * (1 - h);

  int edgeCtr = 0;
  int fgCtr = 0;
  int last = 0;
  for (int y = 0; y < h; y++) {
    const int val = read_imagei(in, sampler, (int2)(xOffset + alpha * y, y)).s0 != 0;
    edgeCtr = abs(last - val);
    fgCtr += val;

    last = val;
  }

  local int localSum;
  if (get_local_id(0) == 0) {
    localSum = 0;
  }

  barrier(0x01);

  atomic_add(&localSum, mad_sat(fgCtr, fgCtr, 0) * ((int)(edgeCtr <= 2)));

  barrier(0x01);

  if (get_local_id(0) == 0) {
    out[hook(1, get_num_groups(0) * alphaIdx + get_group_id(0))] = localSum;
  }
}