//{"dota":0,"dotb":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void _redux_opencl(global double* dota, global double* dotb) {
  const int i = get_global_id(0);
  *dota += *dotb;
}