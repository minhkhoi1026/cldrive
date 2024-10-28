//{"a":0,"dest":3,"offsetDest":6,"offsetX":4,"offsetY":5,"stepDest":9,"stepX":7,"stepY":8,"x":1,"y":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void AXPY(float a, global float* x, global float* y, global float* dest, long offsetX, long offsetY, long offsetDest, long stepX, long stepY, long stepDest) {
  unsigned int id = get_global_id(0);

  dest[hook(3, offsetDest + stepDest * id)] = a * x[hook(1, offsetX + stepX * id)] + y[hook(2, offsetY + stepY * id)];
}