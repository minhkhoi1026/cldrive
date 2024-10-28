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

kernel void lineedit_down(global int* data, int w, int h, global char* changed) {
  int x = get_global_id(0);
  int y = h - 1;
  int lowest = 1 << 30;

  if (x >= w) {
    return;
  }

  while (y >= 0) {
    int curlabel = data[hook(0, w * y + x)];

    if (curlabel == 0) {
      lowest = 1 << 30;
    } else {
      if (curlabel < lowest) {
        lowest = curlabel;
      } else if (curlabel > lowest) {
        data[hook(0, w * y + x)] = lowest;
        *changed = 1;
      }
    }

    --y;
  }
}