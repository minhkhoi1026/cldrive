//{"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void hello_world(global char16* out) {
  const char16 text = {'H', 'e', 'l', 'l', 'o', ' ', 'W', 'o', 'r', 'l', 'd', '!', '\0', '\0', '\0', '\0'};
  size_t id = get_global_id(0);
  out[hook(0, id)] = text;
}