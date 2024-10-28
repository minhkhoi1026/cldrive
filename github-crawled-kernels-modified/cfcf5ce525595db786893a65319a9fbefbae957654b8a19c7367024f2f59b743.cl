//{"out":0,"tmpF":1,"tmpI":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void constant_kernel(global float* out, constant float* tmpF, constant int* tmpI) {
  int tid = get_global_id(0);

  float ftmp = tmpF[hook(1, tid)];
  float Itmp = tmpI[hook(2, tid)];
  out[hook(0, tid)] = ftmp * Itmp;
}