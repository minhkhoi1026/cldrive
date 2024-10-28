//{"a1":0,"b0":2,"b1":3,"d":4,"h":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void foo(double a1, global float* h, global float* b0, global double* b1, global double8* d) {
  *h = -*h;
  *b0 = -*b0;
  *b1 = -a1;
  *d = -*d;
}