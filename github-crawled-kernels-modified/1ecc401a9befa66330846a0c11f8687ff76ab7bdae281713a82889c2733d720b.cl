//{"b":0,"c":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Threshold(global const char* b, global char* c) {
  int id = get_global_id(0);
  if ((unsigned char)b[hook(0, id)] <= 100) {
    c[hook(1, id)] = b[hook(0, id)] * 0;
  } else {
    c[hook(1, id)] = 255 + (b[hook(0, id)] * 0);
  }
}