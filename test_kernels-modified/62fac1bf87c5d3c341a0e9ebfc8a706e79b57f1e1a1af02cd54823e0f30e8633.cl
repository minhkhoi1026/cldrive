//{"numXBins":1,"numYBins":2,"seed":3,"vertex":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float random(global ulong* seed, unsigned int max) {
  *seed = (*seed * 0x5DEECE66DL + 0xBL) & ((1L << 48) - 1);
  unsigned int result = (*seed) >> 16;
  return result % max;
}
float2 particleRandomize(int numXBins, int numYBins, global ulong* seed) {
  float m = random(seed, (numXBins * numYBins));
  float yy = (int)(m / numXBins);
  float xx = m - numXBins * yy;

  float c = (cos(3.1415926535897932384626433832795f * yy / numYBins) + 1.0) * 0.5;
  c *= c;

  return (float2){xx, (numYBins - 1) * (1.0 - c)};
}
kernel void particleInit(global float2* vertex, int numXBins, int numYBins, global ulong* seed) {
  int idx = get_global_id(0);

  float2 position = particleRandomize(numXBins, numYBins, seed);

  int idx2 = 2 * idx;
  vertex[hook(0, idx2)] = position;
  vertex[hook(0, idx2 + 1)] = position;
}