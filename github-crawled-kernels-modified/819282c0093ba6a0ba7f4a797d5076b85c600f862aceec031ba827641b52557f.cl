//{"input":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void incA(global unsigned* input) {
  const int i = get_global_id(0);
  if (i == 0)
    input[hook(0, i)]++;
}