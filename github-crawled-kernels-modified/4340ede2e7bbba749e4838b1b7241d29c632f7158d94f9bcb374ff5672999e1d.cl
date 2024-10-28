//{"data":0,"x":1,"y":2,"z":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void divide(global double2* data, int x, int y, int z) {
  int idX = get_global_id(0);
  int idY = get_global_id(1);
  int idZ = get_global_id(2);
  data[hook(0, idZ * x * y + idY * x + idX)] /= (x * y * z);
}