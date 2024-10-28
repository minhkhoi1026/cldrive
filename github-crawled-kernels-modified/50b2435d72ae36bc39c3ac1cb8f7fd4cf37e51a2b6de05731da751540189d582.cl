//{"counters":0,"res":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void clearCounter(global uint4* counters, global uint4* res) {
  unsigned int gId = get_global_id(0);
  counters[hook(0, gId)] = (uint4)0;

  if (gId == 0) {
    res[hook(1, 0)] = (uint4)0;
  }
}