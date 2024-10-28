//{"M":3,"N":4,"P":5,"data1":8,"data2":9,"m1":0,"m2":1,"maxMId":6,"maxNId":7,"mr":2,"sum":11,"sum[m]":10}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matrixMultiplyN(global const float* m1, global const float* m2, global float* mr, int M, int N, int P, int maxMId, int maxNId) {
  if (get_global_id(0) >= maxMId)
    return;
  if (get_global_id(1) >= maxNId)
    return;
  int mID = get_global_id(0) * 8;
  int nID = get_global_id(1) * 8;

  float sum[8][8];
  float data1[8];
  float data2[8];

  for (int n = 0; n < N; n++) {
    for (int i = 0; i < 8; i++) {
      data1[hook(8, i)] = m1[hook(0, (mID + i) * N + n)];
    }
    for (int i = 0; i < 8; i++) {
      data2[hook(9, i)] = m2[hook(1, nID + n * P + i)];
    }

    if (n == 0) {
      for (int m = 0; m < 8; m++) {
        for (int n = 0; n < 8; n++) {
          sum[hook(11, m)][hook(10, n)] = data1[hook(8, m)] * data2[hook(9, n)];
        }
      }
    } else {
      for (int m = 0; m < 8; m++) {
        for (int n = 0; n < 8; n++) {
          sum[hook(11, m)][hook(10, n)] += data1[hook(8, m)] * data2[hook(9, n)];
        }
      }
    }
  }
  for (int m = 0; m < 8; m++) {
    for (int n = 0; n < 8; n++) {
      mr[hook(2, (mID + m) * P + nID + n)] = sum[hook(11, m)][hook(10, n)];
    }
  }
}