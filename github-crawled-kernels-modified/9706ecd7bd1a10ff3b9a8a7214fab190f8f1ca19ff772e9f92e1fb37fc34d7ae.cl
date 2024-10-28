//{}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_mem_fence() {
  barrier(0x01);
  barrier(0x02);
  mem_fence(0x01);
  mem_fence(0x02);
  read_mem_fence(0x01);
  read_mem_fence(0x02);
  write_mem_fence(0x01);
  write_mem_fence(0x02);
}