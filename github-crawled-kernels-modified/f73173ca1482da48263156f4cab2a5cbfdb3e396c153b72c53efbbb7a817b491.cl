//{"a":2,"b":3,"l1":1,"l2":4,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void bar(global int* out, local int* l1, int a, int b, local int* l2) {
  *out = *l1 - a - b - *l2;
}