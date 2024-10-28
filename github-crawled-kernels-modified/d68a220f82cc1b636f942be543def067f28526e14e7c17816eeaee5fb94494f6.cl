//{"A":1,"Awrk":4,"B":2,"Bwrk":5,"C":3,"N":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mmul(const unsigned int N, global const float* restrict A, global const float* restrict B, global float* restrict C, local float* restrict Awrk, local float* restrict Bwrk) {
  int kloc, Kblk;
  float Ctmp = 0.0f;

  const int i = get_global_id(0);
  const int j = get_global_id(1);

  const int Iblk = get_group_id(0);
  const int Jblk = get_group_id(1);

  const int iloc = get_local_id(0);
  const int jloc = get_local_id(1);

  const int Num_BLK = N / 16;

  int Abase = Iblk * N * 16;
  const int Ainc = 16;

  int Bbase = Jblk * 16;
  const int Binc = 16 * N;

  for (Kblk = 0; Kblk < Num_BLK; Kblk++) {
    Awrk[hook(4, jloc * 16 + iloc)] = A[hook(1, Abase + jloc * N + iloc)];
    Bwrk[hook(5, jloc * 16 + iloc)] = B[hook(2, Bbase + jloc * N + iloc)];

    barrier(0x01);

    for (kloc = 0; kloc < 16; kloc++)
      Ctmp += Awrk[hook(4, jloc * 16 + kloc)] * Bwrk[hook(5, kloc * 16 + iloc)];

    barrier(0x01);
    Abase += Ainc;
    Bbase += Binc;
  }

  C[hook(3, j * N + i)] = Ctmp;
}