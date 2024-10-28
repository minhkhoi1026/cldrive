//{"b":3,"p":2,"r":1,"x":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void initVects(global float* x, global float* r, global float* p, global float* b) {
  int id = get_global_id(0);
  x[hook(0, id)] = 0.0f;
  r[hook(1, id)] = b[hook(3, id)];
  p[hook(2, id)] = b[hook(3, id)];
}