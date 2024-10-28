//{"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ref(global int* out) {
  int a = 5;
  int* b = &a;

  out[hook(0, 0)] = *(&a);
  out[hook(0, 1)] = *b;
  out[hook(0, 2)] = *out;
}