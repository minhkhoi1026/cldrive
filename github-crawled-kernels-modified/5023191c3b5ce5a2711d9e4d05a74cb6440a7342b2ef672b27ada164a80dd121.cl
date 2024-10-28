//{"N":2,"target":0,"value":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void cl_memset(global float* target, const float value, const int N) {
  if ((int)get_global_id(0) < N) {
    target[hook(0, get_global_id(0))] = value;
  }
}