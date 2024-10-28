//{"message2":1,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant uchar message[12] = "Hello World";
constant uchar message2[] = "Hello World!and some more text so it cannot be lowered into register";
kernel void test_constant_storage2(global uchar* out) {
  size_t gid = get_global_id(0);

  out[hook(0, gid)] = message2[hook(1, gid)];
}