//{}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void zero_low_or_high_bits_of_local(void) {
  local long a;
  local long b;
  local int* c = (local int*)&a;
  if (&a > &b)
    c++;
  *c = 0;
}