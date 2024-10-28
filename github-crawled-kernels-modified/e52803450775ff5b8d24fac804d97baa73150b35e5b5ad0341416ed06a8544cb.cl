//{"globsum":1,"histo":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline int changeTranspositionIndex(int i, int n) {
  int ip;

  ip = i;

  return ip;
}

kernel void kernel_PasteHistograms(global int* histo, global int* globsum) {
  size_t ig = get_global_id(0);
  size_t gr = get_group_id(0);

  int s;

  s = globsum[hook(1, gr)];

  histo[hook(0, 2 * ig)] += s;
  histo[hook(0, 2 * ig + 1)] += s;

  barrier(0x02);
}