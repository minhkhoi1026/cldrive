//{"w":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void set_buffer_to_zero(global float* w) {
  w[hook(0, get_global_id(0))] = 0.0;
}