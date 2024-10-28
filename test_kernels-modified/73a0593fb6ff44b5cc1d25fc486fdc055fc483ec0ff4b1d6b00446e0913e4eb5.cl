//{"D":4,"SMem":6,"count":2,"index":3,"k":1,"m":0,"out":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void findMin(int m, int k, int count, global int* index, global int* D, global int* out, local int* SMem) {
  int i = get_group_id(0);

  int tid = get_local_id(0);

  int s = get_local_size(0) / 2;
  int resultValue = 10000000;
  int resultIndex = 10000000;

  int indexBase = (m < 1024) ? m : 1024;

  for (int num = 0; num < m; num += 1024) {
    for (int j = tid; j < indexBase; j += get_local_size(0)) {
      if (j + num == i) {
        SMem[hook(6, j)] = 10000000;
      } else {
        SMem[hook(6, j)] = D[hook(4, i * m + num + j)];
      }

      SMem[hook(6, indexBase + j)] = j + num;
      barrier(0x01);
    }
    for (int j = 0; j < count; j++) {
      if (out[hook(5, i * k + j)] - num >= 0 && out[hook(5, i * k + j)] - num < indexBase) {
        SMem[hook(6, out[ihook(5, i * k + j) - num)] = 10000000;
      }
      barrier(0x01);
    }
    barrier(0x01);
    for (s = indexBase / 2; s > 0; s >>= 1)

    {
      for (int j = tid; j < indexBase; j += get_local_size(0)) {
        if (j < s) {
          if (SMem[hook(6, j)] == SMem[hook(6, j + s)]) {
            if (SMem[hook(6, indexBase + j)] > SMem[hook(6, indexBase + j + s)]) {
              SMem[hook(6, indexBase + j)] = SMem[hook(6, indexBase + j + s)];
            }
          } else if (SMem[hook(6, j)] > SMem[hook(6, j + s)]) {
            SMem[hook(6, j)] = SMem[hook(6, j + s)];
            SMem[hook(6, indexBase + j)] = SMem[hook(6, indexBase + j + s)];
          }
        }
        barrier(0x01);
      }
    }
    barrier(0x01);
    if (resultValue == SMem[hook(6, 0)]) {
      if (resultIndex > SMem[hook(6, indexBase)]) {
        resultIndex = SMem[hook(6, indexBase)];
      }
    } else if (resultValue > SMem[hook(6, 0)]) {
      resultValue = SMem[hook(6, 0)];
      resultIndex = SMem[hook(6, indexBase)];
    }
    barrier(0x01);
  }
  (*index) = resultIndex;
}