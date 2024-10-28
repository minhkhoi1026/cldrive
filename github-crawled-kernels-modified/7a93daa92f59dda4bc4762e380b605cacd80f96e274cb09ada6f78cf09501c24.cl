//{"buffer":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void hellocl(global unsigned short* buffer) {
  size_t gidx = get_global_id(0);
  size_t gidy = get_global_id(1);
  size_t lidx = get_local_id(0);
  size_t leng = get_global_size(0);

  buffer[hook(0, gidx + leng * gidy)] = gidx + leng * gidy;
}