//{"C":1,"G":0,"L":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void foo(global int* G, constant int* C, local int* L) {
  *G = *C + *L;
}