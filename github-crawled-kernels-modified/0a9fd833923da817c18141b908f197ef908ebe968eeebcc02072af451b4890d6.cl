//{"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_enqueue_marker(global int* out) {
  queue_t queue = get_default_queue();

  clk_event_t waitlist, evt;

  *out = enqueue_marker(queue, 1, &waitlist, &evt);
}