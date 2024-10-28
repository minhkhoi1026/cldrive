//{"data":0,"h":2,"w":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void label_with_id(global int* data, int w, int h) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  if (x >= w || y >= h) {
    return;
  }

  int loc = w * y + x;
  if (data[hook(0, loc)] == 1) {
    data[hook(0, loc)] = loc + 2;
  }
}