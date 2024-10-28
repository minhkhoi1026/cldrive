//{"changed":3,"data":0,"h":2,"w":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void neighbour_propagate(global int* data, int w, int h, global char* changed) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  if (x >= w || y >= h) {
    return;
  }

  int oldlabel = data[hook(0, w * y + x)];
  int curlabel = oldlabel;
  int otherlabel = 0;

  if (curlabel == 0) {
    return;
  }

  if (y + 1 < h) {
    otherlabel = data[hook(0, w * (y + 1) + (x))];
    if (otherlabel && otherlabel < curlabel) {
      curlabel = otherlabel;
    }
  }
  if (y - 1 >= 0) {
    otherlabel = data[hook(0, w * (y - 1) + (x))];
    if (otherlabel && otherlabel < curlabel) {
      curlabel = otherlabel;
    }
  }
  if (x + 1 < w) {
    otherlabel = data[hook(0, w * (y) + (x + 1))];
    if (otherlabel && otherlabel < curlabel) {
      curlabel = otherlabel;
    }
  }
  if (x - 1 >= 0) {
    otherlabel = data[hook(0, w * (y) + (x - 1))];
    if (otherlabel && otherlabel < curlabel) {
      curlabel = otherlabel;
    }
  }

  if (curlabel < oldlabel) {
    *changed = 1;
    data[hook(0, w * y + x)] = curlabel;
  }
}