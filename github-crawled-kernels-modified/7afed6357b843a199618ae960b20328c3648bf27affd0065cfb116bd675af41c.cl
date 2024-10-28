//{"E":0,"EP":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void soma(global double* E, local double* EP) {
  int next_power_of_2 = (int)pown((float)2.0, (int)ceil(log2((float)get_local_size(0))));

  int lo_id = get_local_id(0);
  int gr_id = get_group_id(0);
  int s = next_power_of_2 / 2;

  EP[hook(1, lo_id)] = E[hook(0, lo_id)];
  EP[hook(1, lo_id + s)] = E[hook(0, lo_id + s)];

  for (; s > 0; s /= 2) {
    barrier(0x01);

    if (lo_id < s && (lo_id + s < get_local_size(0)))
      EP[hook(1, lo_id)] += EP[hook(1, lo_id + s)];
  }

  if (lo_id == 0)
    E[hook(0, gr_id)] = EP[hook(1, 0)];
}