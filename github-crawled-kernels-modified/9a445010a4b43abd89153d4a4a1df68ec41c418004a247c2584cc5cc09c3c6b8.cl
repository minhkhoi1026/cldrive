//{"param1":0,"param2":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Simple(int param1, global int* param2) {
  param2[hook(1, get_global_id(0))] = param1;
}