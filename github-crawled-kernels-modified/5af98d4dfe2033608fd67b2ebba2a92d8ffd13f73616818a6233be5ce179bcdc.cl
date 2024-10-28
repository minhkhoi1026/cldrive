//{"workBuffer":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void initWorkBuffer(global float* workBuffer) {
  int idx = get_global_id(0);
  workBuffer[hook(0, idx)] = 0;
}