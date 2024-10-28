//{"count":2,"keys":0,"scratch":3,"vals":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void selectionSortLocal(global float* keys, global float* vals, const int count, local float* scratch) {
  int i = get_local_id(0);
  int numOfGroups = get_num_groups(0);
  int groupID = get_group_id(0);
  int wg = get_local_size(0);
  int n;

  int offset = groupID * wg;
  int same = 0;

  vals += offset;
  keys += offset;
  n = (groupID == (numOfGroups - 1)) ? (count - wg * (numOfGroups - 1)) : wg;

  int clamped_i = min(i, n - 1);

  float key1 = keys[hook(0, clamped_i)], key2;
  float val1 = vals[hook(1, clamped_i)];
  scratch[hook(3, i)] = key1;
  barrier(0x01);

  if (i >= n) {
    return;
  }

  int pos = 0;
  for (int j = 0; j < n; ++j) {
    key2 = scratch[hook(3, j)];
    if (((key2) < (key1)))
      pos++;
    else {
      if (((key1) < (key2)))
        continue;
      else {
        same++;
      }
    }
  }
  for (int j = 0; j < same; j++) {
    vals[hook(1, pos + j)] = val1;
    keys[hook(0, pos + j)] = key1;
  }
}