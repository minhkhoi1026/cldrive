//{"a":1,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant uchar message[12] = "Hello World";
constant uchar message2[] = "Hello World!and some more text so it cannot be lowered into register";
kernel void test_register_storage(global uchar* out) {
  size_t gid = get_global_id(0);
  uchar4 pad = (uchar4)'\0';
  uchar16 a = (uchar16)('H', 'e', 'l', 'l', 'o', ' ', 'W', 'o', 'r', 'l', 'd', '\0', pad);

  out[hook(0, gid)] = a[hook(1, gid)];
}