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

kernel void lines_up(global int* data, int w, int h, global char* changed) {
  int x = get_global_id(0);
  int y = 0;
  char localchanged = 0;

  if (x >= w) {
    return;
  }

  while (y < h) {
    if (!data[hook(0, w * y + x)]) {
      ++y;
      continue;
    }
    int i = y;
    int min = data[hook(0, w * y + x)];
    int tmpmin = min;

    while (i < h && (tmpmin = data[hook(0, w * i + x)])) {
      if (tmpmin != min) {
        localchanged = 1;
      }
      if (tmpmin < min) {
        min = tmpmin;
      }
      ++i;
    }

    while (y != i) {
      data[hook(0, w * y + x)] = min;
      ++y;
    }
  }

  if (localchanged) {
    *changed = localchanged;
  }
}