//{"alpha":2,"apDotp":1,"oldRDotR":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void updateAlpha(global float* oldRDotR, global float* apDotp, global float* alpha) {
  *alpha = (*oldRDotR) / (*apDotp);
}