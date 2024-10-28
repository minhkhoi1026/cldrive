//{}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void foo(event_t evt);
kernel void ker() {
  event_t e;

  foo(e);

  foo(0);
}