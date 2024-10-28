//{"_numInputFeatMaps":3,"_wMaps":6,"filters":0,"hMaps":5,"indexPairs":8,"inputFeatMaps":1,"numOutFeatMaps":4,"outFeatMaps":2,"rangePairs":9,"sizeBatch":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float2 complex_mul(float2 a, float2 b) {
  float2 x;
  x.even = (a.even * b.even - a.odd * b.odd);
  x.odd = (a.even * b.odd + a.odd * b.even);
  return x;
}

kernel void dotplus(const global float2* filters, const global float2* inputFeatMaps, global float2* outFeatMaps, const int _numInputFeatMaps, const int numOutFeatMaps, const int hMaps, const int _wMaps, const int sizeBatch, const global int2* indexPairs, const global int2* rangePairs)

{
  const int numInputFeatMaps = _numInputFeatMaps;
  const int wMaps = _wMaps;

  const int x_offset = get_global_id(0);
  const int y_offset = get_global_id(1);

  if (x_offset >= numOutFeatMaps * wMaps || y_offset >= sizeBatch * hMaps)
    return;

  const int2 rp = rangePairs[hook(9, x_offset / wMaps)];
  float2 acc = 0;
  int2 index;
  const int wh = wMaps * hMaps;
  const int offset = (y_offset % hMaps) * wMaps + (x_offset % wMaps);

  for (int i = rp.even; i < rp.odd; i++) {
    index = indexPairs[hook(8, i)];
    acc.even += (filters[hook(0, index.even * wh + offset)].even * inputFeatMaps[hook(1, y_offset * wMaps * numInputFeatMaps + (index.odd / numInputFeatMaps) * wMaps + (x_offset % wMaps))].even - filters[hook(0, index.even * wh + offset)].odd * inputFeatMaps[hook(1, y_offset * wMaps * numInputFeatMaps + (index.odd / numInputFeatMaps) * wMaps + (x_offset % wMaps))].odd);
    acc.odd += (filters[hook(0, index.even * wh + offset)].even * inputFeatMaps[hook(1, y_offset * wMaps * numInputFeatMaps + (index.odd / numInputFeatMaps) * wMaps + (x_offset % wMaps))].odd + filters[hook(0, index.even * wh + offset)].odd * inputFeatMaps[hook(1, y_offset * wMaps * numInputFeatMaps + (index.odd / numInputFeatMaps) * wMaps + (x_offset % wMaps))].even);
  }

  outFeatMaps[hook(2, y_offset * (numOutFeatMaps * wMaps) + x_offset)] = acc;
}