//{"pIn":0,"pOut":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void helloworld(global char* pIn, global char* pOut) {
  int iNum = get_global_id(0);
  pOut[hook(1, iNum)] = pIn[hook(0, iNum)] + 1;
}