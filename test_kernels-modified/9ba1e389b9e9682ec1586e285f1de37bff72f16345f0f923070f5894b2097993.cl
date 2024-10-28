//{"a":0,"id":1,"res":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void testWorkGroupBroadcast(unsigned int a, global size_t* id, global int* res) {
  res[hook(2, 0)] = work_group_broadcast(a, *id);
}