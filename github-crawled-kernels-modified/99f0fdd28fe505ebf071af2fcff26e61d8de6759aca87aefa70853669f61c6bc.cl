//{"a":1,"c":2,"ySize":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void RunAutomata(const int ySize, global int* a, global int* c) {
  unsigned int i = get_global_id(0);
  unsigned int j = get_global_id(1);
  unsigned int my_id = i + ySize * j;
  unsigned int count = 0;

  if (a[hook(1, my_id - 1)] == 1) {
    count += 1;
  }
  if (a[hook(1, my_id + 1)] == 1) {
    count += 1;
  }
  if (a[hook(1, my_id - 1 - ySize)] == 1) {
    count += 1;
  }
  if (a[hook(1, my_id - 1 + ySize)] == 1) {
    count += 1;
  }
  if (a[hook(1, my_id + 1 - ySize)] == 1) {
    count += 1;
  }
  if (a[hook(1, my_id + 1 + ySize)] == 1) {
    count += 1;
  }
  if (a[hook(1, my_id - ySize)] == 1) {
    count += 1;
  }
  if (a[hook(1, my_id + ySize)] == 1) {
    count += 1;
  }

  c[hook(2, my_id)] = (count == 3) || (count == 2) && (a[hook(1, my_id)] != 0);
}