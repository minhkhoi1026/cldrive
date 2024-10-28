//{"n":0,"sxorig":1,"sydest":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void scopy(int n, global float* sxorig, global float* sydest) {
  int i, tid, totalThreads, ctaStart;

  tid = get_local_id(0);
  int locsiz = get_local_size(0);
  int gridDimx = get_num_groups(0);
  int gid = get_group_id(0);

  totalThreads = gridDimx * locsiz;
  ctaStart = locsiz * gid;

  for (i = ctaStart + tid; i < n; i += totalThreads) {
    sydest[hook(2, i)] = sxorig[hook(1, i)];
  }
}