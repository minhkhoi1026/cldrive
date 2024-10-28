//{"output":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void uninitialized_local_variable(global int* output) {
  local int x;
  if (*output > 0)
    x = *output;
  *output = x;
}