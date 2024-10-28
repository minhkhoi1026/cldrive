//{"globsum":1,"histograms":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void paste(global int* histograms, global int* globsum) {
  int ig = get_global_id(0);
  int gr = get_group_id(0);

  int s;

  s = globsum[hook(1, gr)];

  histograms[hook(0, 2 * ig)] += s;
  histograms[hook(0, 2 * ig + 1)] += s;

  barrier(0x02);
}