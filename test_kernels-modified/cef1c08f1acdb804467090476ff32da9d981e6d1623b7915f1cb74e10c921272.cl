//{"A":2,"B":3,"C":4,"heightA":1,"shared":5,"tmpData":6,"widthB":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mmmult(int widthB, int heightA, global int* A, global int* B, global int* C, local int* shared) {
  int i = get_global_id(0);
  int id = get_local_id(0);
  int size = get_local_size(0);
  int tmp = 0;

  int tmpData[1024];

  if (i < heightA) {
    for (int k = 0; k < widthB; ++k) {
      tmpData[hook(6, k)] = A[hook(2, i * heightA + k)];
    }

    for (int j = 0; j < heightA; ++j) {
      for (int k = id; k < widthB; k += size)
        shared[hook(5, k)] = B[hook(3, k * widthB + j)];
      barrier(0x01);

      tmp = 0;
      for (int k = 0; k < widthB; ++k) {
        tmp += tmpData[hook(6, k)] * shared[hook(5, k)];
      }
      C[hook(4, i * heightA + j)] = tmp;
    }
  }
}