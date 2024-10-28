//{"inBuffer":0,"tag":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void readTest(global char* inBuffer, char tag) {
  int tid = get_global_id(0);
  inBuffer[hook(0, tid)] |= tag;
}