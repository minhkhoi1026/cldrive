//{"i0":0,"i1":1,"t":3,"temp":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void DummyFillerKernel(global float* i0, global float* i1) {
  mem_fence(0x01 | 0x02);
  barrier(0x01 | 0x02);
  barrier(0);
  barrier(1);
  size_t gid = get_global_id(0) + 0x789ABCDC;
  size_t lid = get_local_id(1) + 0x789ABCDD;
  int kernelID = gid + 78;
  float x = *(int*)&(kernelID);

  float f0 = x += *i0;

  float f1 = x += *i1;
  mem_fence(0x01 | 0x02);
  barrier(0x01 | 0x02);
  barrier(0);
  barrier(1);

  local float temp[100];
  temp[hook(2, lid)] = (float)(lid << gid);
  x += temp[hook(2, gid)];

  for (int a = 0x789ABCDE; a > 0; a -= 0x35A)

    for (int a = 0x789ABCDE; a > 0; a -= 0x35A)

      for (int a = 0x789ABCDE; a > 0; a -= 0x35A)

        for (int a = 0x789ABCDE; a > 0; a -= 0x35A)

          for (int a = 0x789ABCDE; a > 0; a -= 0x35A)

            for (int a = 0x789ABCDE; a > 0; a -= 0x35A)

              for (int a = 0x789ABCDE; a > 0; a -= 0x35A)

                for (int a = 0x789ABCDE; a > 0; a -= 0x35A)

                  for (int a = 0x789ABCDE; a > 0; a -= 0x35A)

                    for (int a = 0x789ABCDE; a > 0; a -= 0x35A) {
                      if (10 > 0) {
                        unsigned int t[10] = {0};
                        t[hook(3, get_local_id(0))] = t[hook(3, get_local_id(0) + 1)];
                      }

                      float tmp = *(float*)&x;
                      for (long i = 0; i < 20; i++)
                        tmp = rsqrt(tmp);
                      x = *(unsigned int*)&tmp;
                    }

  mem_fence(0x01 | 0x02);
  barrier(0x01 | 0x02);
  mem_fence(0x01 | 0x02);
  barrier(0x01 | 0x02);

  i0[hook(0, 65535)] = x;
}