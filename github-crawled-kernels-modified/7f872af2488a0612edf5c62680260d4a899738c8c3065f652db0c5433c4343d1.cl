//{"Mat":0,"answer":1,"n":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Mat_Trans(global const double* Mat, global double* answer, int n) {
  unsigned int i = get_global_id(0);
  unsigned int j = get_global_id(1);
  answer[hook(1, i * n + j)] = Mat[hook(0, j * n + i)];
}