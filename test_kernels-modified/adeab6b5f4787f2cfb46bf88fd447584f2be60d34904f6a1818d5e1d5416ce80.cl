//{"GRAPH_SIZE":4,"dist":0,"mid":2,"mval":1,"result":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void FindMinDist(global int* dist, global int* mval, global int* mid, global ulong* result, const int GRAPH_SIZE) {
  int global_id = get_global_id(0);
  const int cur_size = get_global_size(0);

  if (cur_size == GRAPH_SIZE >> 1) {
    int left = dist[hook(0, global_id)];
    int right = global_id + cur_size < GRAPH_SIZE ? dist[hook(0, global_id + cur_size)] : -1;
    if ((left > 0 && left < right) || right < 0) {
      mval[hook(1, global_id)] = left;
      mid[hook(2, global_id)] = global_id;
    } else {
      mval[hook(1, global_id)] = right;
      mid[hook(2, global_id)] = global_id + cur_size;
    }
  } else {
    int left = mval[hook(1, global_id)];
    int right = mval[hook(1, global_id + cur_size)];
    if ((left < 0 || left > right) && right > 0) {
      mval[hook(1, global_id)] = right;
      mid[hook(2, global_id)] = mid[hook(2, global_id + cur_size)];
    }
  }

  if (cur_size == 1 && global_id == 0) {
    dist[hook(0, mid[0hook(2, 0))] = -1;
    *result += mval[hook(1, 0)];
  }
}