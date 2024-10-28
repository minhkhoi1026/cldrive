//{"N":0,"links":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reset_links(const unsigned int N, global int* links) {
  const int globalid = get_global_id(0);
  if (globalid >= N)
    return;

  links[hook(1, globalid)] = globalid;
}