//{"a":0,"b":1,"c":2,"s":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void funnyBusiness(global double* a, global double* b, global double* c, global int* s) {
  size_t i = get_global_id(0);
  double4 r = vload4(i, a) + vload4(i, b);
  double4 rsq = r * r;
  vstore4(rsq, i, c);
  s[hook(3, i)] = (int)(rsq.x + rsq.y + rsq.z + rsq.w);
}