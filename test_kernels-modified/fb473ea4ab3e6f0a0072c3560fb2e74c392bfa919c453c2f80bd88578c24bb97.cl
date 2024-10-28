//{"N":0,"inout":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void notUseLocal(int N, global float* inout) {
  if ((int)get_global_id(0) < N) {
    inout[hook(1, get_global_id(0))] += 1.0f;
  }
}