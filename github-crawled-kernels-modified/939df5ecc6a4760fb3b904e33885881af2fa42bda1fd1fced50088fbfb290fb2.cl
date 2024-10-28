//{"x":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void func(local int*);
kernel void __attribute__((__overloadable__)) bar(local int* x) {
  *x = 5;
}