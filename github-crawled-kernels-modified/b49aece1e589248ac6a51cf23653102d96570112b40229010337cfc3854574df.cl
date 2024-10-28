//{"data":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void wait_event_invalid(global int* data) {
  event_t event = 0;
  wait_group_events(1, &event);
}