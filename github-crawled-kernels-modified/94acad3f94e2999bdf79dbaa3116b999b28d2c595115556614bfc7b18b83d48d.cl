//{"A":0,"B":1,"C":2,"wA":3,"wB":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void MatrixMult_naive(global float* A, global float* B, global float* C, const int wA, const int wB) {
  unsigned int col = get_global_id(0);
  unsigned int row = get_global_id(1);
}