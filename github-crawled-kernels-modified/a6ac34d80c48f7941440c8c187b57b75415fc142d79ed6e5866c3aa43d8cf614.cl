//{}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void lowPriorityTask() {
  int workID = get_global_id(0);

  int n = 2147483647, first = 0, second = 1, next, c;

  printf("\nI'm a [low ] priority task and i'm occupying the LO-Device\t (LO-LO)");
  for (c = 0; c < n; c++) {
    if (c <= 1)
      next = c;
    else {
      next = first + second;
      first = second;
      second = next;
    }
  }
}