//{"alphaRes":2,"in":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 4 | 0x10;
float alphaVal(int alphaIdx) {
  return alphaIdx / 4.0f - 1.0f;
}

kernel void sumColumns(global int4* in, global float* out) {
  const int id = get_global_id(0);
  const int4 tmp4 = in[hook(0, id)];
  const int2 tmp2 = tmp4.s01 + tmp4.s23;
  const int res = tmp2.s0 + tmp2.s1;

  local int alphaRes[9];
  alphaRes[hook(2, id)] = res;

  barrier(0x01);
  if (id == 0) {
    int bestIdx = 0;
    int bestVal = 0;
    for (int i = 0; i < 9; ++i) {
      const int currVal = alphaRes[hook(2, i)];
      if (currVal > bestVal) {
        bestVal = currVal;
        bestIdx = i;
      }
    }
    *out = -alphaVal(bestIdx);
  }
}