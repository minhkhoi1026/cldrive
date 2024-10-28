//{}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gemm() {
  barrier(0x01);
  barrier(0x01);
  barrier(0x01);
  barrier(0x01);
  barrier(0x01);

  barrier(0x01);
  barrier(0x01);
  barrier(0x01);
  barrier(0x01);
  barrier(0x01);
}