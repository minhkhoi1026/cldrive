//{"out":3,"sigmaD":4,"xx":0,"xy":1,"yy":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void hessian(global float* xx, global float* xy, global float* yy, global float* out, float sigmaD) {
  int i = get_global_id(0);
  out[hook(3, i)] = fabs(((xx[hook(0, i)] * yy[hook(2, i)] - pow(xy[hook(1, i)], 2)) * pow(sigmaD, 2)));
}