//{"B":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void dup(global uchar4* B) {
  *B = (uchar4)(1, 128, 3, 4);
}