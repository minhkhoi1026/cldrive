//{"Aik":0,"As":7,"As[ti]":6,"Bkj":1,"Bs":9,"Bs[k]":10,"Bs[ti]":8,"Cij":2,"ni":3,"nj":4,"nk":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
;
;
;
kernel void mmul_local(global float* Aik, global float* Bkj, global float* Cij, const int ni, const int nj, const int nk) {
  int gj = get_global_id(0);
  int gi = get_global_id(1);
  int bj = get_group_id(0);
  int bi = get_group_id(1);
  int tj = get_local_id(0);
  int ti = get_local_id(1);
  int oj = bi * 16;
  int oi = bj * 16;
  float Csub = 0;
  local float As[16][16];
  local float Bs[16][16];
  for (int ok = 0; ok < nk; ok += 16) {
    As[hook(7, ti)][hook(6, tj)] = Aik[hook(0, nk * (gi) + tj + ok)];
    Bs[hook(9, ti)][hook(8, tj)] = Bkj[hook(1, nj * (ti + ok) + gj)];
    barrier(0x01);
    for (int k = 0; k < 16; ++k)
      Csub += As[hook(7, ti)][hook(6, k)] * Bs[hook(9, k)][hook(10, tj)];
    barrier(0x01);
  }
  Cij[hook(2, nj * (gi) + gj)] = Csub;
}