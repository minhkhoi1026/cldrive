//{}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gemm() {
 private
  float regA, regB, regC;
  regC += regA * regB;
}