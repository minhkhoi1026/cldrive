//{"buffer":0,"strike":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vanillaPut(global float* buffer, float strike) {
  int i = get_global_id(0);
  buffer[hook(0, i)] = fmax(0.0f, strike - buffer[hook(0, i)]);
}