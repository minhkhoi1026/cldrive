//{"X":0,"Y":1,"Z":3,"anotherArg":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void foo(global int* restrict X, const int Y, volatile int anotherArg, constant float* restrict Z) {
  *X = Y + anotherArg;
}