//{"B":0,"f":1,"g":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void bar(global float* B, float f, float g) {
  *B = f - g;
}