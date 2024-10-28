//{"A":0,"Ar_Ar":5,"Ar_r":4,"n":6,"r":1,"x":3,"x0":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void minres(global float* A, global float* r, global float* x0, global float* x, float Ar_r, float Ar_Ar, unsigned int n) {
  unsigned int i = get_global_id(0);
  if (i >= n)
    return;

  x[hook(3, i)] = x0[hook(2, i)] + Ar_r / Ar_Ar * r[hook(1, i)];
}