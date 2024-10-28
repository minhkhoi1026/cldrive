//{"box_buffer":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reset_bbox_buffer(global int* box_buffer) {
  int idx = get_global_id(0) * 4;
  box_buffer[hook(0, idx++)] = 0;
  box_buffer[hook(0, idx++)] = 0;
  box_buffer[hook(0, idx++)] = 2147483647;
  box_buffer[hook(0, idx)] = 2147483647;
}