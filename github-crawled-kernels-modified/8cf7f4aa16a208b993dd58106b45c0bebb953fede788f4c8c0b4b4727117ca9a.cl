//{"cids":1,"lits":2,"rids":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void produce_chunks(global unsigned int* restrict rids, global unsigned int* restrict cids, global unsigned int* restrict lits) {
  unsigned int thread = get_global_id(0);
  lits[hook(2, thread)] = 1u << (rids[hook(0, thread)] % 31u);
  lits[hook(2, thread)] |= 1u << 31u;
  cids[hook(1, thread)] = rids[hook(0, thread)] / 31u;
}