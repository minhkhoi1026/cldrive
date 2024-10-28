//{"destValues":1,"sourceA":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sample_test(global short3* sourceA, global int* destValues) {
  int tid = get_global_id(0);
  destValues[hook(1, tid)] = all(vload3(tid, (global short*)sourceA));
}