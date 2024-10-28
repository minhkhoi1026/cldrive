//{"X":0,"offset":2,"value":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void SET_VALUE(global float* X, float value, unsigned int offset) {
  unsigned int element = get_global_id(0);
  X[hook(0, element + offset)] = value;
}