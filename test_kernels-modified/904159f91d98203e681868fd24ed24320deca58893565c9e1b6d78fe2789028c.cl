//{"a":0,"b":1,"c":2,"nColumnsA":4,"nColumnsB":6,"nRowsA":5,"nRowsB":7,"sum":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mult(global const float* a, global const float* b, global float* c, local float* sum, int nColumnsA, int nRowsA, int nColumnsB, int nRowsB) {
  int id = get_global_id(0);
  int nproc = get_global_size(0);

  int grupoId = get_group_id(0);
  int localId = get_local_id(0);
  int tamGrupo = get_num_groups(0);
  int tamLocal = get_local_size(0);
  int i, j, k;

  for (i = 0; i < nRowsA; i++) {
    for (j = grupoId; j < nColumnsB; j = j + tamGrupo) {
      sum[hook(3, localId)] = 0.0f;

      for (k = localId; k < nRowsB; k = k + tamLocal) {
        sum[hook(3, localId)] = sum[hook(3, localId)] + (a[hook(0, i * nColumnsA + k)] * b[hook(1, k * nColumnsB + j)]);
      }
      barrier(0x02 | 0x01);
      if (localId == 0) {
        float sumLocal = 0.0f;
        for (k = 0; k < tamLocal; k++) {
          sumLocal = sumLocal + sum[hook(3, k)];
        }
        c[hook(2, i * nColumnsB + j)] = sumLocal;
      }
      barrier(0x02 | 0x01);
    }
  }
}