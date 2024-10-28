//{"data":0,"size":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void divide1D(global double2* data, const int size) {
  int idX = get_global_id(0);
  data[hook(0, idX)] /= size;
}