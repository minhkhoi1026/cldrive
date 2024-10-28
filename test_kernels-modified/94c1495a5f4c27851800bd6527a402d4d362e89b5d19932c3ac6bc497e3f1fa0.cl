//{"result":2,"voctor1":0,"voctor2":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void multi(global double* voctor1, global double* voctor2, global double* result) {
  size_t i = get_global_id(0);

  result[hook(2, i)] = voctor1[hook(0, i)] * voctor2[hook(1, i)];
}