//{"array":0,"length":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sum(global int* array, const int length) {
  int i = get_global_id(0);

  unsigned int dist = 1;
  unsigned int l = length / 2;

  while (l > 0) {
    if (i % (dist * 2) == 0) {
      array[hook(0, i)] = array[hook(0, i)] + array[hook(0, i + dist)];
    }

    dist = dist * 2;
    l = l / 2;

    barrier(0x01);
  }
}