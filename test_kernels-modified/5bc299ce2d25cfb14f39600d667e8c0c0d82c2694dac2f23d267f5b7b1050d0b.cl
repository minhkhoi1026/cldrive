//{"m":0,"max_score":2,"scores":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void bc_normalize(int m, global float* scores, float max_score) {
  int tid = get_global_id(0);
  if (tid < m)
    scores[hook(1, tid)] = scores[hook(1, tid)] / max_score;
}