//{"gp":0,"lp":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test(global float* gp, local float* lp) {
  global float* ghp;
  local float* lhp;
}