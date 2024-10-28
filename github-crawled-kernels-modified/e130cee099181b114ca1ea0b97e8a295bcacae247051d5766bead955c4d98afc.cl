//{"buffer":0,"ignored":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void straightPrice(global float* buffer, float ignored) {
  1;
}