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

kernel void lineedit_left(global int* data, int w, int h, global char* changed) {
  int x = w - 1;
  int y = get_global_id(0);
  int lowest = 1 << 30;

  if (y >= h) {
    return;
  }

  while (x >= 0) {
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

    --x;
  }
}