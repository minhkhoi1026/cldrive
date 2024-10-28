//{"copiesPerWorkItem":2,"dst":0,"localBuffer":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_load_bool_imm(global int* dst, local int* localBuffer, int copiesPerWorkItem) {
  int i;
  for (i = 0; i < copiesPerWorkItem; i++)
    localBuffer[hook(1, get_local_id(0) * copiesPerWorkItem + i)] = copiesPerWorkItem;
  barrier(0x01);

  for (i = 0; i < copiesPerWorkItem; i++)
    dst[hook(0, get_global_id(0) * copiesPerWorkItem + i)] = localBuffer[hook(1, get_local_id(0) * copiesPerWorkItem + i)];
  barrier(0x01);
}