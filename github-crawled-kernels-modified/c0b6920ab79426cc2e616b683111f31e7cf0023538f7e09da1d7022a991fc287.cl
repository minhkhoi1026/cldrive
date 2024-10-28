//{"c":1,"d":7,"f":5,"h":6,"i":3,"l":4,"out":0,"s":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void foo(global int* out, char c, short s, int i, long l, float f, float h, double d) {
  *out = i + get_global_id(0);
}