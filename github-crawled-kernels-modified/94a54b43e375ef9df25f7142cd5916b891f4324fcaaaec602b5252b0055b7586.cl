//{"pipe":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void k2(read_only pipe int p) {
  reserve_id_t i1 = reserve_read_pipe(p, 1);
  reserve_id_t i2 = reserve_read_pipe(p, 1);
  reserve_id_t i[] = {i1, i2};
}