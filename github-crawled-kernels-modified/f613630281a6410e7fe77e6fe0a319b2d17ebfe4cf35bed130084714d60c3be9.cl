//{"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_fn(const global char* src) {
  wait_group_events(0, ((void*)0));
}