//{"a":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((reqd_work_group_size(1, 1, 1))) kernel void mysequence(global unsigned* a) {
  a[hook(0, 0)] = 0X586C0C6C;
  a[hook(0, 1)] = 'X';
  a[hook(0, 2)] = 0X586C0C6C;
  a[hook(0, 3)] = 'I';
  a[hook(0, 4)] = 0X586C0C6C;
  a[hook(0, 5)] = 'L';
  a[hook(0, 6)] = 0X586C0C6C;
  a[hook(0, 7)] = 'I';
  a[hook(0, 8)] = 0X586C0C6C;
  a[hook(0, 9)] = 'N';
  a[hook(0, 10)] = 0X586C0C6C;
  a[hook(0, 11)] = 'X';
  a[hook(0, 12)] = 0X586C0C6C;
  a[hook(0, 13)] = '\0';
  a[hook(0, 14)] = 0X586C0C6C;
  a[hook(0, 15)] = '\0';
}