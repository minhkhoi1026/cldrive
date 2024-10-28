//{"buf":0,"exit_gid":2,"size":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
extern void abort();
extern void exit(int);
kernel void devset_t(global char* buf, int size, int exit_gid) {
  int i;
  for (i = 0; i < size; i++) {
    if (i == exit_gid)
      exit(-42);
    buf[hook(0, i)] = 'x';
  }
}