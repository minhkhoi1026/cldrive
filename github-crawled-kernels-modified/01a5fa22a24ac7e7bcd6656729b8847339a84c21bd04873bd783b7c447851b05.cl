//{"changed":3,"data":0,"h":2,"w":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int find_set(global int* data, int loc) {
  while (loc != data[hook(0, loc)] - 2) {
    loc = data[hook(0, loc)] - 2;
  }
  return loc;
}

kernel void union_find(global int* data, int w, int h, global char* changed) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  if (x >= w || y >= h) {
    return;
  }

  int oldlabel = data[hook(0, w * y + x)];
  int lowest = oldlabel;

  if (oldlabel == 0) {
    return;
  }

  bool ok_N = y - 1 >= 0 && data[hook(0, w * (y - 1) + (x))];
  bool ok_E = x + 1 < w && data[hook(0, w * (y) + (x + 1))];
  bool ok_S = y + 1 < h && data[hook(0, w * (y + 1) + (x))];
  bool ok_W = x - 1 >= 0 && data[hook(0, w * (y) + (x - 1))];
  int root_N;
  int root_E;
  int root_S;
  int root_W;

  if (ok_N) {
    root_N = find_set(data, w * (y - 1) + (x));
    if (root_N + 2 < lowest) {
      lowest = root_N + 2;
    }
  }
  if (ok_E) {
    root_E = find_set(data, w * (y) + (x + 1));
    if (root_E + 2 < lowest) {
      lowest = root_E + 2;
    }
  }
  if (ok_S) {
    root_S = find_set(data, w * (y + 1) + (x));
    if (root_S + 2 < lowest) {
      lowest = root_S + 2;
    }
  }
  if (ok_W) {
    root_W = find_set(data, w * (y) + (x - 1));
    if (root_W + 2 < lowest) {
      lowest = root_W + 2;
    }
  }

  if (lowest < oldlabel) {
    *changed = 1;
    data[hook(0, w * y + x)] = lowest;
    if (ok_N && root_N + 2 > lowest) {
      data[hook(0, root_N)] = lowest;
    }
    if (ok_E && root_E + 2 > lowest) {
      data[hook(0, root_E)] = lowest;
    }
    if (ok_S && root_S + 2 > lowest) {
      data[hook(0, root_S)] = lowest;
    }
    if (ok_W && root_W + 2 > lowest) {
      data[hook(0, root_W)] = lowest;
    }
  }
}