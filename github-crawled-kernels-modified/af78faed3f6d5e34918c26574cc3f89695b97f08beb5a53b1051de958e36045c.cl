//{"accumulator":0,"varB":1,"varC":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void BasicMUL(global float* accumulator, global float* varB, global float* varC) {
  unsigned int id = get_global_id(0);
  accumulator[hook(0, id)] = varB[hook(1, id)] * varC[hook(2, id)];
}