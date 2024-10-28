//{"dT":1,"numXBins":2,"numYBins":3,"seed":5,"vectorField":4,"vertex":0}
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
kernel void particleMove(global float2* vertex, float dT, int numXBins, int numYBins, global float2* vectorField, global ulong* seed) {
  int idx = get_global_id(0);

  int idx2 = 2 * idx;

  float2 position = vertex[hook(0, idx2)];
  float2 _v = vectorField[hook(4, (int)position.x + ((int)position.y) * numXBins)];
  float2 v = _v * dT;
  float2 origPosition = position;
  position = position + v;

  float2 position_t;

  if (position.x < 0.0 && v.x < 0.0) {
    position.x = numXBins - 0.1;

    if (position.y >= numYBins)
      position.y = numYBins - 0.5;
    else if (position.y < 0.0)
      position.y = 0.0;

    position_t = position + v;
  } else if (position.x > numXBins && v.x > 0.0) {
    position.x = 0.0;
    position.y = 0.5 * (position.y + origPosition.y);

    if (position.y >= numYBins)
      position.y = numYBins - 0.5;
    else if (position.y < 0.0)
      position.y = 0.0;
    position_t = position + v;
  }

  else if (position.y < 0.0 || position.y >= numYBins - 1.0) {
    position_t = particleRandomize(numXBins, numYBins, seed);
    position = position_t;
  } else {
    float m = _v.x * _v.x + _v.y * _v.y;

    position_t = position + v;

    if (m < 2.0) {
      position_t = particleRandomize(numXBins, numYBins, seed);
      position = position_t;
    }
  }

  vertex[hook(0, idx2)] = position;
  vertex[hook(0, idx2 + 1)] = position_t;
}