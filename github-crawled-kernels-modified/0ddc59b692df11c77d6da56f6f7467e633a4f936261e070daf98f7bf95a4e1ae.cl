//{}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void zero_one_or_other(void) {
  local unsigned int local_1[1];
  local unsigned int local_2[1];
  *(local_1 > local_2 ? local_1 : local_2) = 0;
}