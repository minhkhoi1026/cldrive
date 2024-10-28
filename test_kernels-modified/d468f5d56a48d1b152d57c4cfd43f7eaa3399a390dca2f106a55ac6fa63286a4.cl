//{"newRDotR":0,"oldRDotR":1,"p":3,"r":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void updateDir(global float* newRDotR, global float* oldRDotR, global float* r, global float* p) {
  int id = get_global_id(0);
  p[hook(3, id)] = r[hook(2, id)] + (*newRDotR) / (*oldRDotR) * p[hook(3, id)];
}