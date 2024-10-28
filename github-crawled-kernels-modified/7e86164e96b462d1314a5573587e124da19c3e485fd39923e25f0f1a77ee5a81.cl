//{"data":6,"dataBase":1,"data_offset":2,"inter":5,"interBase":3,"inter_offset":4,"n":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void uniformAdd(unsigned int n, global unsigned int* dataBase, unsigned int data_offset, global unsigned int* interBase, unsigned int inter_offset) {
  local unsigned int uni;

  global unsigned int* data = dataBase + data_offset;
  global unsigned int* inter = interBase + inter_offset;

  if (get_local_id(0) == 0) {
    uni = inter[hook(5, get_group_id(0))];
  }
  barrier(0x01);

  unsigned int g_ai = get_group_id(0) * 2 * get_local_size(0) + get_local_id(0);
  unsigned int g_bi = g_ai + get_local_size(0);

  if (g_ai < n) {
    data[hook(6, g_ai)] += uni;
  }
  if (g_bi < n) {
    data[hook(6, g_bi)] += uni;
  }
}