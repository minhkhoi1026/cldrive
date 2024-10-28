//{"buffer":3,"count":0,"offset1":1,"offset2":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reduce(int count, int offset1, int offset2, global int* buffer) {
  int gid = get_global_id(0);

  if (gid * 2 + 0 < count) {
    buffer[hook(3, gid + offset2)] = buffer[hook(3, gid * 2 + 0 + offset1)];
  }

  if (gid * 2 + 1 < count) {
    buffer[hook(3, gid + offset2)] += buffer[hook(3, gid * 2 + 1 + offset1)];
  }
}