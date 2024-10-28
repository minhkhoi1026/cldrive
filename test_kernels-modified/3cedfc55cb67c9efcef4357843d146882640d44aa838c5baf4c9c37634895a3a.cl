//{"buf":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void __attribute__((reqd_work_group_size(1, 1, 1))) hello(global char* buf) {
  int glbId = get_global_id(0);

  if (glbId == 0) {
    buf[hook(0, 0)] = 'H';
    buf[hook(0, 1)] = 'e';
    buf[hook(0, 2)] = 'l';
    buf[hook(0, 3)] = 'l';
    buf[hook(0, 4)] = 'o';
    buf[hook(0, 5)] = ' ';
    buf[hook(0, 6)] = 'W';
    buf[hook(0, 7)] = 'o';
    buf[hook(0, 8)] = 'r';
    buf[hook(0, 9)] = 'l';
    buf[hook(0, 10)] = 'd';
    buf[hook(0, 11)] = '\n';
    buf[hook(0, 12)] = '\0';
  }
}