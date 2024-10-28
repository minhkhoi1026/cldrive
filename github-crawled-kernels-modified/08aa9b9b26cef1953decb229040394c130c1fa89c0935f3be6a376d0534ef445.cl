//{"AIn":3,"bIn":2,"resX":4,"resY":5,"residuum":6,"xIn":0,"xOut":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Iteration2D(global float* xIn, global float* xOut, global float* bIn, global float* AIn, int resX, int resY, global float* residuum) {
  const int idx = get_global_id(0);
  const int size = get_global_size(0);

  int2 ij;
  int2 res = (int2)(resX, resY);
  (ij).y = idx / (res).x;
  (ij).x = (idx - (ij).y * (res).x);
  ;

  float x00 = xIn[hook(0, idx)];
  float b = bIn[hook(2, idx)];
  float a00 = AIn[hook(3, idx)];
  float a10 = AIn[hook(3, idx + 1 * size)];
  float a20 = AIn[hook(3, idx + 2 * size)];
  float a01 = AIn[hook(3, idx + 3 * size)];
  float a02 = AIn[hook(3, idx + 4 * size)];

  float sum = a00 * x00;
  if (ij.x > 0)
    sum += xIn[hook(0, (((int2){ij.x - 1, ij.y}).x + ((int2){ij.x - 1, ij.y}).y * (res).x))] * a10;
  if (ij.x < resX - 1)
    sum += xIn[hook(0, (((int2){ij.x + 1, ij.y}).x + ((int2){ij.x + 1, ij.y}).y * (res).x))] * a20;
  if (ij.y > 0)
    sum += xIn[hook(0, (((int2){ij.x, ij.y - 1}).x + ((int2){ij.x, ij.y - 1}).y * (res).x))] * a01;
  if (ij.y < resY - 1)
    sum += xIn[hook(0, (((int2){ij.x, ij.y + 1}).x + ((int2){ij.x, ij.y + 1}).y * (res).x))] * a02;
  float r = b - sum;
  residuum[hook(6, idx)] = r;
  xOut[hook(1, idx)] = x00 + r / a00;
}