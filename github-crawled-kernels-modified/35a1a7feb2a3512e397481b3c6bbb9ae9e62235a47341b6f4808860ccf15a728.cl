//{"A":0,"B":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void filter_r(global const uchar* A, global uchar* B) {
  int id = get_global_id(0);
  int image_size = get_global_size(0) / 3;
  int colour_channel = id / image_size;

  B[hook(1, id)] = A[hook(0, id)];
}