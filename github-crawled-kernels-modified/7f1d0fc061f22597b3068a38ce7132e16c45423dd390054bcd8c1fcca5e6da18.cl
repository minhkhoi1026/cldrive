//{"AIn":3,"bIn":2,"resX":4,"resY":5,"resZ":6,"residuum":7,"xIn":0,"xOut":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Iteration3D(global float* xIn, global float* xOut, global float* bIn, global float* AIn, int resX, int resY, int resZ, global float* residuum) {
  const int idx = get_global_id(0);
  const int size = get_global_size(0);

  int3 ijk;
  int3 res = (int3)(resX, resY, resZ);
  (ijk).z = idx / ((res).x * (res).y);
  (ijk).y = (idx - (ijk).z * (res).x * (res).y) / (res).x;
  (ijk).x = idx - (res).x * ((ijk).y + (ijk).z * (res).y);
  ;

  float x000 = xIn[hook(0, idx)];
  float b = bIn[hook(2, idx)];
  float a000 = AIn[hook(3, idx)];
  float a100 = AIn[hook(3, idx + 1 * size)];
  float a200 = AIn[hook(3, idx + 2 * size)];
  float a010 = AIn[hook(3, idx + 3 * size)];
  float a020 = AIn[hook(3, idx + 4 * size)];
  float a001 = AIn[hook(3, idx + 5 * size)];
  float a002 = AIn[hook(3, idx + 6 * size)];

  float sum = a000 * x000;
  if (ijk.x > 0)
    sum += xIn[hook(0, (((int3){ijk.x - 1, ijk.y, ijk.z}).x + (((int3){ijk.x - 1, ijk.y, ijk.z}).y + ((int3){ijk.x - 1, ijk.y, ijk.z}).z * (res).y) * (res).x))] * a100;
  if (ijk.x < resX - 1)
    sum += xIn[hook(0, (((int3){ijk.x + 1, ijk.y, ijk.z}).x + (((int3){ijk.x + 1, ijk.y, ijk.z}).y + ((int3){ijk.x + 1, ijk.y, ijk.z}).z * (res).y) * (res).x))] * a200;
  if (ijk.y > 0)
    sum += xIn[hook(0, (((int3){ijk.x, ijk.y - 1, ijk.z}).x + (((int3){ijk.x, ijk.y - 1, ijk.z}).y + ((int3){ijk.x, ijk.y - 1, ijk.z}).z * (res).y) * (res).x))] * a010;
  if (ijk.y < resY - 1)
    sum += xIn[hook(0, (((int3){ijk.x, ijk.y + 1, ijk.z}).x + (((int3){ijk.x, ijk.y + 1, ijk.z}).y + ((int3){ijk.x, ijk.y + 1, ijk.z}).z * (res).y) * (res).x))] * a020;
  if (ijk.z > 0)
    sum += xIn[hook(0, (((int3){ijk.x, ijk.y, ijk.z - 1}).x + (((int3){ijk.x, ijk.y, ijk.z - 1}).y + ((int3){ijk.x, ijk.y, ijk.z - 1}).z * (res).y) * (res).x))] * a001;
  if (ijk.z < resZ - 1)
    sum += xIn[hook(0, (((int3){ijk.x, ijk.y, ijk.z + 1}).x + (((int3){ijk.x, ijk.y, ijk.z + 1}).y + ((int3){ijk.x, ijk.y, ijk.z + 1}).z * (res).y) * (res).x))] * a002;
  float r = b - sum;
  residuum[hook(7, idx)] = r;
  xOut[hook(1, idx)] = x000 + r / a000;
}