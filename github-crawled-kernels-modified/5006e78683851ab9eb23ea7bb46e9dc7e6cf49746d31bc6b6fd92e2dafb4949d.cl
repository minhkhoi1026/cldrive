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

kernel void lines_right(global int* data, int w, int h, global char* changed) {
  int x = 0;
  int y = get_global_id(0);
  char localchanged = 0;

  if (y >= h) {
    return;
  }

  while (x < w) {
    if (!data[hook(0, w * y + x)]) {
      ++x;
      continue;
    }
    int i = x;
    int min = data[hook(0, w * y + x)];
    int tmpmin = min;

    while (i < w && (tmpmin = data[hook(0, w * y + i)])) {
      if (tmpmin != min) {
        localchanged = 1;
      }
      if (tmpmin < min) {
        min = tmpmin;
      }
      ++i;
    }

    while (x != i) {
      data[hook(0, w * y + x)] = min;
      ++x;
    }
  }

  if (localchanged) {
    *changed = localchanged;
  }
}