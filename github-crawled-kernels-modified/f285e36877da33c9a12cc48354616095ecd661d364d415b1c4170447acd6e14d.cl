//{"foo":1,"output":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void array(global long16* output) {
  long16 data[] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11};

  int i = get_global_id(0);

  long16* foo = data;

  output[hook(0, i)] = foo[hook(1, i)];
}