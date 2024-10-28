//{"data":0,"x":1,"y":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void divide(global double2* data, int x, int y) {
  int idX = get_global_id(0);
  int idY = get_global_id(1);
  data[hook(0, idY * x + idX)] /= (x * y);
}