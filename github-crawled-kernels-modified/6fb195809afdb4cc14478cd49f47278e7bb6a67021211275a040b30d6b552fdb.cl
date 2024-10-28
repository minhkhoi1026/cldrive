//{"destin":1,"dim":2,"source":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void rotatemat(global float* source, global float* destin, int dim) {
  const int xIn = get_global_id(0);
  const int yIn = get_global_id(1);

  destin[hook(1, xIn + dim * yIn)] = source[hook(0, (dim - xIn) + dim * (dim - yIn))];
}