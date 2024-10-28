//{"cols":3,"fx":0,"fy":1,"rows":2,"stepx":4,"stepy":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void for_matrices(global double2* fx, global double2* fy, int rows, int cols, double stepx, double stepy) {
  unsigned int n = get_global_id(0);
  int j = n / rows;
  int i = n % rows;
  fx[hook(0, n)].x = stepx * (double)(j - cols / 2);
  fx[hook(0, n)].y = 0.0;
  fy[hook(1, n)].x = stepy * (double)(i - rows / 2);
  fy[hook(1, n)].y = 0.0;
}