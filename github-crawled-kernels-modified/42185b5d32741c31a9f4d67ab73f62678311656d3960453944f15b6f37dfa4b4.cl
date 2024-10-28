//{}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vectorMathBuiltinBug() {
  float4 foo = sqrt((float4)(1.0f));
}