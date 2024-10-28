//{"data":0,"freqU":1,"freqV":2,"numElementsU":5,"numElementsV":6,"numProj":4,"shifts":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
typedef float2 float2;
inline float2 cmult(float2 a, float2 b) {
  return (float2)(a.x * b.x - a.y * b.y, a.x * b.y + a.y * b.x);
}

kernel void shift(global float* data, global float* freqU, global float* freqV, global float* shifts, int const numProj, int const numElementsU, int const numElementsV) {
  int iGIDU = get_global_id(0);
  int iGIDV = get_global_id(1);
  if (iGIDU >= numElementsU || iGIDV >= numElementsV) {
    return;
  }

  for (int iProj = 0; iProj < numProj; iProj++) {
    float angle = freqU[hook(1, iGIDU)] * shifts[hook(3, 2 * iProj)] + freqV[hook(2, iGIDV)] * shifts[hook(3, 2 * iProj + 1)];
    float2 cshift = (float2)(cos(angle), sin(angle));
    unsigned int globalOffset = (iGIDV * numElementsU * numProj + iGIDU * numProj + iProj) * 2;
    float2 orig = (float2)(data[hook(0, globalOffset)], data[hook(0, globalOffset + 1)]);

    float2 res = cmult(cshift, orig);
    data[hook(0, globalOffset)] = res.x;
    data[hook(0, globalOffset + 1)] = res.y;
  }
}