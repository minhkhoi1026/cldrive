//{"A":0,"i":1,"ppp":3,"ppp[i]":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant unsigned int ppp[2][3] = {{1, 2, 3}, {5}};

kernel void foo(global unsigned int* A, unsigned int i) {
  *A = ppp[hook(3, i)][hook(2, i)];
}