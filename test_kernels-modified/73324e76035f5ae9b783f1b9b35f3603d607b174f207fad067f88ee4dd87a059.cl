//{"<recovery-expr>(One)":1,"<recovery-expr>(Two)":2,"id":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
unsigned char One[6442450944];
global unsigned int Two[6442450944];
kernel void large_globals(unsigned int id) {
  One[hook(1, id)] = id;
  Two[hook(2, id + 1)] = id + 1;
}