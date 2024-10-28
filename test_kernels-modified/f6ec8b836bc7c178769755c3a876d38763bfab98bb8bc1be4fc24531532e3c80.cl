//{"array":0,"higherLevelArray":1,"localBlock":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Scan_WorkEfficient(global unsigned int* array, global unsigned int* higherLevelArray, local unsigned int* localBlock) {
  unsigned int id = get_local_id(0);
  unsigned int size = get_local_size(0);
  unsigned int pos = get_group_id(0) * size * 2 + id;

  localBlock[hook(2, id)] = array[hook(0, pos)];
  localBlock[hook(2, id + size)] = array[hook(0, pos + size)];

  barrier(0x01);

  for (unsigned int step = 2; step <= size * 2; step = step * 2) {
    if (id < (size * 2) / step) {
      unsigned int index = (id + 1) * step - 1;
      localBlock[hook(2, index)] += localBlock[hook(2, index - step / 2)];
    }

    barrier(0x01);
  }

  if (id == 0) {
    localBlock[hook(2, size * 2 - 1)] = 0;
  }

  barrier(0x01);

  for (unsigned int step = size * 2; step > 1; step = step / 2) {
    if (id < (size * 2) / step) {
      unsigned int index = (id + 1) * step - 1;
      unsigned int left_value = localBlock[hook(2, index - step / 2)];
      unsigned int right_value = localBlock[hook(2, index)];

      localBlock[hook(2, index - step / 2)] = right_value;

      localBlock[hook(2, index)] = left_value + right_value;
    }

    barrier(0x01);
  }

  localBlock[hook(2, id)] += array[hook(0, pos)];
  localBlock[hook(2, id + size)] += array[hook(0, pos + size)];
  barrier(0x01);

  array[hook(0, pos)] = localBlock[hook(2, id)];
  array[hook(0, pos + size)] = localBlock[hook(2, id + size)];

  if (id == 0) {
    higherLevelArray[hook(1, get_group_id(0))] = localBlock[hook(2, size * 2 - 1)];
  }
}