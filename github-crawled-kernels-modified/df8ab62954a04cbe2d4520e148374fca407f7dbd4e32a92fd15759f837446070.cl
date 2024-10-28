//{"arg":1,"dest":2,"offsetDest":4,"offsetX":3,"stepDest":6,"stepX":5,"x":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Map_ADD(global float* x, float arg, global float* dest, long offsetX, long offsetDest, long stepX, long stepDest) {
  unsigned int id = get_global_id(0);
  float a = x[hook(0, offsetX + stepX * id)];
  float b = arg;
  float c = a + b;
  dest[hook(2, offsetDest + stepDest * id)] = c;
}