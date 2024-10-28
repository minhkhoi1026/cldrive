//{"in":0,"length":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reduceStatistic(global int* in, int length) {
  int gloId = get_global_id(0);

  for (int i = gloId + 256; i < length; i += 256) {
    in[hook(0, gloId)] += in[hook(0, i)];
  }
}