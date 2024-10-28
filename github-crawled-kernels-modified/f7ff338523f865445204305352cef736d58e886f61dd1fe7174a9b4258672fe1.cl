//{"bs1":0,"bs2":1,"subset_count":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void bitset_or(global unsigned int* bs1, global unsigned int* bs2, const unsigned int subset_count) {
  unsigned int i = get_global_id(0);
  if (i < subset_count) {
    bs1[hook(0, i)] |= bs2[hook(1, i)];
  }
}