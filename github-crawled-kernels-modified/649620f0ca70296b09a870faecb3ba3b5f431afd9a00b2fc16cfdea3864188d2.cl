//{"in":0,"in2":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test(int global* in, int global* in2) {
  if (!in)
    return;
  if (in == 1)
    return;
  if (in > in2)
    return;
  if (in < in2)
    return;
}