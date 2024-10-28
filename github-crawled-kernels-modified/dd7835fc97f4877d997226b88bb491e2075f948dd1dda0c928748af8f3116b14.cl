//{"in":0,"n":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void factor_test(global const long* in, int n) {
  int id = get_global_id(0);
  if (id >= n)
    return;

  long zuTeilen = in[hook(0, id)];
  int first = 1;
  for (int i = 2; i <= zuTeilen;) {
    if (zuTeilen % i == 0) {
      if (first == 1) {
      } else {
        first = 0;
      }
      zuTeilen = zuTeilen / i;
    }
    if (zuTeilen % i != 0)
      i++;
  }
}