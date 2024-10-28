//{"arg":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void format_string_warnings(constant char* arg) {
  printf("%d", arg);

  printf("not enough arguments %d %d", 4);

  printf("too many arguments", 4);
}