//{"iterations":1,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void loop_lt(global int* out, int iterations) {
  int i;
  int ai = 0;
  for (i = 0; i < iterations; i++) {
    out[hook(0, ai)] = i;
    ai = ai + 1;
  }
}