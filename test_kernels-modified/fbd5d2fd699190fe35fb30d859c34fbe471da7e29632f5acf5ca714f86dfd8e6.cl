//{"sum":1,"v":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test3(global float* v, global float* sum) {
  for (unsigned int i = 0; i < 1024; i++)
    *sum += v[hook(0, i)];
}