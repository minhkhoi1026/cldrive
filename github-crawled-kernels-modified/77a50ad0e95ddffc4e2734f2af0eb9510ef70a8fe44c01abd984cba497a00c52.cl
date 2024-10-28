//{"nLoop":0,"pOut":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void QueryMinimumGranularity(int nLoop, global int* pOut) {
  local volatile int flag;

  int index = get_global_id(0);

  int totalItems = get_global_size(0);

  do {
    int halfIndex = totalItems / 2;

    if (index == 0)
      flag = 1;

    work_group_barrier(0x01);

    if (index < halfIndex) {
      for (int i = 0; i < nLoop; i++) {
        if (flag == -1)
          break;
      }

      if (flag != -1) {
        if (index == 0) {
          *pOut = totalItems;
          flag = 2;
        }
      }
    } else {
      if (index == halfIndex) {
        if (flag != 2)
          flag = -1;
      }
    }

    work_group_barrier(0x01);

    if (flag == 2)
      break;

    totalItems /= 2;
  } while (totalItems > 0);
}