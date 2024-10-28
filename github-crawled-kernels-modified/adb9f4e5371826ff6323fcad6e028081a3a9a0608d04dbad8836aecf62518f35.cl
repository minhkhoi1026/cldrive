//{"A":0,"B":1,"C":2,"scratchA":4,"scratchA[tidY]":3,"scratchB":6,"scratchB[k]":7,"scratchB[tidY]":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matmul(global float* A, global float* B, global float* C) {
  local float scratchA[16][16];
  local float scratchB[16][16];

  int globalX = get_global_id(0);
  int globalY = get_global_id(1);
  int size = get_global_size(0);
  int k;
  float sum = 0.0f;
  int numBlocks = size / 16;
  int b;

  int tidX = get_local_id(0);
  int tidY = get_local_id(1);

  for (b = 0; b < numBlocks; ++b) {
    int x;
    int y;

    x = b * 16 + tidX;
    y = globalY;

    scratchA[hook(4, tidY)][hook(3, tidX)] = A[hook(0, y * size + x)];

    x = globalX;
    y = b * 16 + tidY;

    scratchB[hook(6, tidY)][hook(5, tidX)] = B[hook(1, y * size + x)];

    barrier(0x01);

    for (k = 0; k < 16; ++k) {
      float myA;
      float myB;

      myA = scratchA[hook(4, tidY)][hook(3, k)];
      myB = scratchB[hook(6, k)][hook(7, tidX)];

      sum += myA * myB;
    }

    barrier(0x01);
  }

  C[hook(2, globalY * size + globalX)] = sum;
}