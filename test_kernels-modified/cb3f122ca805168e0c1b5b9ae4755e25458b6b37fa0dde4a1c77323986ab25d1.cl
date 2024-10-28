//{"N":0,"_buffer":2,"inout":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void useLocal(int N, global float* inout, local float* _buffer) {
  if ((int)get_global_id(0) < N) {
    inout[hook(1, get_global_id(0))] += 1.0f;
  }
}