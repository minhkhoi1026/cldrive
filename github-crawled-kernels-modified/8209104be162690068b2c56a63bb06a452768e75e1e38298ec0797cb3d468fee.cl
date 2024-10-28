//{"abort_gid":1,"buf":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
extern void abort();
extern void exit(int);
kernel void devset(global char* buf, int abort_gid) {
  if (get_global_id(0) == abort_gid)
    abort();
  buf[hook(0, get_global_id(0))] = 'x';
}