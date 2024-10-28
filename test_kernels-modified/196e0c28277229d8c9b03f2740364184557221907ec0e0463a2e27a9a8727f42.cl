//{"array":1,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant float array[2] = {0.0f, 1.0f};

kernel void test(global float* out) {
  *out = array[hook(1, 0)];
}