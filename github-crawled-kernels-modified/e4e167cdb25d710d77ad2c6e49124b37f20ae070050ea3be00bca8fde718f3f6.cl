//{"gout":0,"lout":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void fill(int* out) {
  *out = 42;
}

kernel void test(global int* gout, local int* lout) {
  fill(gout);
  fill(lout);
}