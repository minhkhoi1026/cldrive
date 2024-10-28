//{"A":2,"Awrk":4,"B":3,"Bwrk":5,"C":1,"N":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void k_gen_cl_gemm_v1_(const int N, global float* restrict C, const global float* restrict A, const global float* restrict B) {
  int kloc, Kblk;

  local float Awrk[16 * 16];
  local float Bwrk[16 * 16];

  const int Num_BLK = 512 / 16;

  const int i = get_global_id(0);
  const int j = get_global_id(1);

  const int Iblk = get_group_id(0);
  const int Jblk = get_group_id(1);

  const int iloc = get_local_id(0);
  const int jloc = get_local_id(1);

  int Abase = Jblk * 16;
  const int Ainc = 16 * 512;

  int Bbase = Iblk * 512 * 16;
  const int Binc = 16;

  float Ctmp = 0.0f;

  for (Kblk = 0; Kblk < Num_BLK; Kblk++) {
    Awrk[hook(4, iloc * 16 + jloc)] = A[hook(2, Abase + iloc * 512 + jloc)];
    Bwrk[hook(5, iloc * 16 + jloc)] = B[hook(3, Bbase + iloc * 512 + jloc)];

    barrier(0x01);

    for (kloc = 0; kloc < 16; kloc++)
      Ctmp += Awrk[hook(4, kloc * 16 + jloc)] * Bwrk[hook(5, iloc * 16 + kloc)];

    barrier(0x01);
    Abase += Ainc;
    Bbase += Binc;
  }

  C[hook(1, i * 512 + j)] = Ctmp;
}