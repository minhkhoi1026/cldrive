//{"def":3,"in":0,"out":1,"subset_count":4,"use":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void bitset_megaop(global unsigned int* in, global unsigned int* out, global unsigned int* use, global unsigned int* def, const unsigned int subset_count) {
  unsigned int i = get_global_id(0);
  if (i < subset_count) {
    in[hook(0, i)] = out[hook(1, i)];
    in[hook(0, i)] = in[hook(0, i)] & (~(in[hook(0, i)] & def[hook(3, i)]));
    in[hook(0, i)] |= use[hook(2, i)];
  }
}