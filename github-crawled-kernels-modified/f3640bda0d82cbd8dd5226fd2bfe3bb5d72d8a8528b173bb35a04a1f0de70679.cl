//{"count":2,"keys":0,"vals":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void selectionSortFinal(global float* keys, global float* vals, const int count) {
  const int i = get_local_id(0);
  const int numOfGroups = get_num_groups(0);
  const int wg = get_local_size(0);
  int pos = 0, same = 0;
  const int offset = get_group_id(0) * wg;
  const int remainder = count - wg * (numOfGroups - 1);

  if ((offset + i) >= count)
    return;
  float val1 = vals[hook(1, offset + i)];

  float key1 = keys[hook(0, offset + i)];
  float key2;

  for (int j = 0; j < numOfGroups - 1; j++) {
    for (int k = 0; k < wg; k++) {
      key2 = keys[hook(0, j * wg + k)];
      if (((key1) < (key2)))
        break;
      else {
        if (((key2) < (key1)))
          pos++;
        else
          same++;
      }
    }
  }

  for (int k = 0; k < remainder; k++) {
    key2 = keys[hook(0, (numOfGroups - 1) * wg + k)];
    if (((key1) < (key2)))
      break;
    else {
      if (((key2) < (key1)))
        pos++;
      else
        same++;
    }
  }
  for (int j = 0; j < same; j++) {
    vals[hook(1, pos + j)] = val1;
    keys[hook(0, pos + j)] = key1;
  }
}