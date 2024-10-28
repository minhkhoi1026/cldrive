//{"A":0,"B":1,"C":2,"wA":3,"wB":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void MatrixMult_opt(global float* A, global float* B, global float* C, const int wA, const int wB) {
  local float sma[256];
  local float smb[256];

  int bx = get_group_id(0);
  int by = get_group_id(1);

  int tx = get_local_id(0);
  int ty = get_local_id(1);
}