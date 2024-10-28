//{"data":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void highPriorityTask(global int* data) {
  int workID = get_global_id(0);
  printf("\nI'm a [high] priority task ");
  data[hook(0, workID)] == 1 ? printf("and I'm running on the HI-device\t (HI-HI)") : printf("but I'm running on the LO-device\t (LO-LO)");
}