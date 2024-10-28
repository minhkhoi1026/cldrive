//{"message":1,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant uchar message[12] = "Hello World";
kernel void test_constant_storage(global uchar* out) {
  size_t gid = get_global_id(0);

  out[hook(0, gid)] = message[hook(1, gid)];
}