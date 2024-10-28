//{"N":0,"deviceChar":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void setCharTest(int N, global char* deviceChar) {
  int i = get_global_id(0);
  if (i < N) {
    deviceChar[hook(1, i)] = 'a';
  }
}