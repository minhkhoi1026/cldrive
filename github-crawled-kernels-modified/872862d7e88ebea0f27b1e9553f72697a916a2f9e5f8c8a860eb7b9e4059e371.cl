//{}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
event_t create_event();
kernel void k3() {
  event_t e1 = create_event();
  event_t e2 = create_event();
  event_t e[] = {e1, e2};
}