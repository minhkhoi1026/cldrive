//{"aTimesP":2,"alpha":0,"p":1,"r":4,"x":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void updateXR(global float* alpha, global float* p, global float* aTimesP, global float* x, global float* r) {
  int id = get_global_id(0);
  x[hook(3, id)] += (*alpha) * p[hook(1, id)];
  r[hook(4, id)] -= (*alpha) * aTimesP[hook(2, id)];
}