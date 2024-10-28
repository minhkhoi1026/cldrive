//{"s1":0,"s2":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((reqd_work_group_size(1, 1, 1))) kernel void migbw(global int16* restrict s1, global const int16* s2) {
  local int16 buffer0[(0x800 / 16)];
  for (int i = 0; i < 0x20000; i++) {
    event_t e = async_work_group_copy(buffer0, &s2[hook(1, (2048 / 16) * i)], (0x800 / 16), 0);
    wait_group_events(1, &e);
    e = async_work_group_copy(&s1[hook(0, (2048 / 16) * i)], buffer0, (0x800 / 16), 0);
    wait_group_events(1, &e);
  }
}