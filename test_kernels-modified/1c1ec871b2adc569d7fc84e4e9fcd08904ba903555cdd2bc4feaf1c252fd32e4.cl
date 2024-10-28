//{"a":0,"afactor":2,"aoffset":1,"b":3,"bfactor":5,"boffset":4,"c":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void scaleAdd_vector(global double* a, const int aoffset, const double afactor, global double* b, const int boffset, const double bfactor, const double c) {
  int i = get_global_id(0);
  a[hook(0, i + aoffset)] = (a[hook(0, i + aoffset)] * afactor) + (b[hook(3, i + boffset)] * bfactor) + c;
}