//{"E":0,"EP":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void somaOLD(global int* E, local int* EP) {
  int lo_id = get_local_id(0);
  int gr_id = get_group_id(0);
  int s = get_local_size(0);

  for (; s > 0; s /= 2) {
    barrier(0x01);

    if (lo_id < s) {
      int value1 = E[hook(0, lo_id)], value2 = E[hook(0, lo_id + s)];
      EP[hook(1, lo_id)] = value1 + value2;
    }
  }

  if (lo_id == 0)
    E[hook(0, gr_id)] = EP[hook(1, 0)];
}