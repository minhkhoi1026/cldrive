//{"inputA":0,"inputB":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void TestMain(global float* inputA, global float* inputB) {
  int gid = get_local_id(0);
  inputA[hook(0, gid)] = gid;
  inputB[hook(1, gid)] = gid * gid;
}