//{"<recovery-expr>()":10,"<recovery-expr>(dA)":9,"<recovery-expr>(dB)":11,"dA":1,"dA_offset":2,"dB":5,"dB_offset":6,"inca":4,"incb":8,"ldda":3,"lddb":7,"nb":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void swapdblk(int nb, global T* dA, unsigned long dA_offset, int ldda, int inca, global T* dB, unsigned long dB_offset, int lddb, int incb) {
  const int tx = get_local_id(0);
  const int bx = get_group_id(0);

  dA += tx + bx * nb * (ldda + inca) + dA_offset;
  dB += tx + bx * nb * (lddb + incb) + dB_offset;

  T tmp;

  for (int i = 0; i < nb; i++) {
    tmp = dA[i * ldda];
    dA[hook(9, i * ldda)] = dB[hook(10, i * lddb)];
    dB[hook(11, i * lddb)] = tmp;
  }
}