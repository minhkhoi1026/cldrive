//{"size":1,"twiddle":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void twiddles(global double2* twiddle, int size) {
  int idX = get_global_id(0);
  twiddle[hook(0, idX)] = (double2)(cos(6.283185307179586476925286766559 * idX / size), -sin(6.283185307179586476925286766559 * idX / size));
}