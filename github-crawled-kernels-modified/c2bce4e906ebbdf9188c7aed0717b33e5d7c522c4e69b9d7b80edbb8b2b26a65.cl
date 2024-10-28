//{"globsum":1,"histo":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void pastehistograms(global int* restrict histo, const global int* restrict globsum) {
  int ig = get_global_id(0);
  int gr = get_group_id(0);

  int s = globsum[hook(1, gr)];

  histo[hook(0, (ig << 1))] += s;
  histo[hook(0, (ig << 1) + 1)] += s;
}