//{"Lengths":2,"Results":3,"Temp1":4,"Temp2":5,"Word":1,"_Dict":0,"b":8,"d1":6,"d2":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void LevenshteinDistanceGpuKernel(global char* _Dict, constant char* Word, global char* Lengths, global char* Results, global char* Temp1, global char* Temp2) {
  int dictSize = 796032;
  int x = get_global_id(0);

  global char* t1 = Temp1 + x;
  global char* t2 = Temp2 + x;

  global char* const b = _Dict + x;
  const int aN = Word[hook(1, 16)];
  const int bN = Lengths[hook(2, x)];

  global char* d1 = t1;
  global char* d2 = t2;
  int j = 0;
  while (j <= bN) {
    d1[hook(6, dictSize * j)] = j;
    j++;
  }
  int i = 1;
  while (i <= aN) {
    d2[hook(7, 0)] = i;
    j = 1;
    while (j <= bN) {
      char ra = d1[hook(6, j * dictSize)] + 1;
      char rb = d2[hook(7, (j - 1) * dictSize)] + 1;
      char rc = d1[hook(6, (j - 1) * dictSize)];
      if ((Word[hook(1, i - 1)] != b[hook(8, dictSize * (j - 1))])) {
        rc += 1;
      }

      if (ra < rb)
        rb = ra;
      if (rc < rb)
        rb = rc;
      d2[hook(7, j * dictSize)] = rb;
      j++;
    }
    d1 = (d1 == t1) ? t2 : t1;
    d2 = (d2 == t2) ? t1 : t2;
    i++;
  }

  Results[hook(3, x)] = d1[hook(6, bN * dictSize)];
}