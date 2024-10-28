//{"b":0,"offset":2,"step":3,"val":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Fill(global float* b, float val, long offset, long step) {
  unsigned int id = get_global_id(0);
  b[hook(0, offset + step * id)] = val;
}