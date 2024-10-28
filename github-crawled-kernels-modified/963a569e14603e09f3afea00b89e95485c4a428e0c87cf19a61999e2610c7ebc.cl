//{"step":1,"tArray":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void fastWalshTransform(global float* tArray, const int step) {
  unsigned int tid = get_global_id(0);

  const unsigned int group = tid % step;
  const unsigned int pair = 2 * step * (tid / step) + group;

  const unsigned int match = pair + step;

  float T1 = tArray[hook(0, pair)];
  float float2 = tArray[hook(0, match)];

  tArray[hook(0, pair)] = T1 + float2;
  tArray[hook(0, match)] = T1 - float2;
}