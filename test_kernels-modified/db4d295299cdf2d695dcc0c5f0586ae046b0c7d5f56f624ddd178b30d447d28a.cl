//{"destValues":3,"sourceA":0,"sourceB":1,"sourceC":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sample_test(global short16* sourceA, global short16* sourceB, global short16* sourceC, global short16* destValues) {
  int tid = get_global_id(0);
  short16 sA = sourceA[hook(0, tid)];
  short16 sB = sourceB[hook(1, tid)];
  short16 sC = sourceC[hook(2, tid)];
  short16 dst = clamp(sA, sB, sC);
  destValues[hook(3, tid)] = dst;
}