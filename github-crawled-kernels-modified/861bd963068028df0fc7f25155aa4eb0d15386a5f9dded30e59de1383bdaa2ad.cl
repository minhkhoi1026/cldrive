//{"X":0,"X[i + 1]":5,"X[i + 2]":6,"X[i - 1]":2,"X[i - 2]":3,"X[i]":4,"Y":1,"Y[i - 2]":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void FIR_GPU_dev(global const unsigned char X[2048][2048], global float Y[2048][2048]) {
  size_t i, j;
  i = get_global_id(1) + 2;
  j = get_global_id(2) + 2;
  if (j < 2048 - 2) {
    float r1;
    r1 = (float)-2. * X[hook(0, i - 1)][hook(2, j - 2)] + (float)5. * X[hook(0, i - 1)][hook(2, j - 1)] + (float)3. * X[hook(0, i - 1)][hook(2, j)] + (float)5. * X[hook(0, i - 1)][hook(2, j + 1)] + (float)-2. * X[hook(0, i - 1)][hook(2, j + 2)];
    r1 += (float)-1. * X[hook(0, i - 2)][hook(3, j - 2)] + (float)-2. * X[hook(0, i - 2)][hook(3, j - 1)] + (float)-3. * X[hook(0, i - 2)][hook(3, j)] + (float)-2. * X[hook(0, i - 2)][hook(3, j + 1)] + (float)-1. * X[hook(0, i - 2)][hook(3, j + 2)];
    r1 += (float)-3. * X[hook(0, i)][hook(4, j - 2)] + (float)3. * X[hook(0, i)][hook(4, j - 1)] + (float)0. * X[hook(0, i)][hook(4, j)] + (float)3. * X[hook(0, i)][hook(4, j + 1)] + (float)-3. * X[hook(0, i)][hook(4, j + 2)];
    r1 += (float)-2. * X[hook(0, i + 1)][hook(5, j - 2)] + (float)5. * X[hook(0, i + 1)][hook(5, j - 1)] + (float)3. * X[hook(0, i + 1)][hook(5, j)] + (float)5. * X[hook(0, i + 1)][hook(5, j + 1)] + (float)-2. * X[hook(0, i + 1)][hook(5, j + 2)];
    r1 += (float)-1. * X[hook(0, i + 2)][hook(6, j - 2)] + (float)-2. * X[hook(0, i + 2)][hook(6, j - 1)] + (float)-3. * X[hook(0, i + 2)][hook(6, j)] + (float)-2. * X[hook(0, i + 2)][hook(6, j + 1)] + (float)-1. * X[hook(0, i + 2)][hook(6, j + 2)];
    Y[hook(1, i - 2)][hook(7, j - 2)] = r1;
  }
}