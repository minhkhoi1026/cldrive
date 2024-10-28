//{"ang":4,"channels_map":0,"data":3,"round_counters":1,"step":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void FHTIterationG(local float* data, constant float* ang, int n, int n2, int k) {
  float a;
  float b;
  float c;
  float d;
  float e;
  float f;
  int i, j, ang_off;

  {
    i = (int)((float)k / (float)(n / 2 + 1));
    j = k - mul24(i, (n / 2 + 1));

    int diff = (j == 0) ? n : j;

    float flip_sign = (float)((j == 0) ? -1 : 1);

    ang_off = mul24(j, (n2 << 1));

    int a_off = mad24((n << 1), i, j);
    a = data[hook(3, a_off)];
    b = data[hook(3, a_off + n)];

    int c_off = mad24((n << 1), i, n - diff);
    c = data[hook(3, c_off)];
    d = data[hook(3, c_off + n)];

    float dsin = ang[hook(4, ang_off)];
    float dcos = ang[hook(4, ang_off + 1)];

    e = b * dcos + d * dsin;
    f = b * dsin - d * dcos;

    f *= flip_sign;

    data[hook(3, a_off + n)] = a - e;
    data[hook(3, a_off)] = a + e;
    data[hook(3, c_off + n)] = c - f;
    data[hook(3, c_off)] = c + f;
  }
}

void FHTIterationG2(local char* data, constant char* ang, int n, int n2, int k) {
  float a;
  float b;
  float c;
  float d;
  float e;
  float f;
  int i, j, ang_off;

  {
    i = (int)((float)k / (float)(n / 2 + 1));
    j = k - mul24(i, (n / 2 + 1));

    int diff = (j == 0) ? n : j;

    float flip_sign = (float)((j == 0) ? -1 : 1);

    ang_off = mul24(j, (n2 << 1));

    int a_off = mad24((n << 1), i, j);
    a = *(local float*)&data[hook(3, (a_off << 2))];
    b = *(local float*)&data[hook(3, (a_off + n) << 2)];

    int c_off = mad24((n << 1), i, n - diff);
    c = *(local float*)&data[hook(3, (c_off) << 2)];
    d = *(local float*)&data[hook(3, (c_off + n) << 2)];

    float dsin = *(constant float*)&ang[hook(4, (ang_off) << 2)];
    float dcos = *(constant float*)&ang[hook(4, (ang_off + 1) << 2)];

    e = b * dcos + d * dsin;
    f = b * dsin - d * dcos;

    f *= flip_sign;

    *(local float*)&data[hook(3, (a_off + n) << 2)] = a - e;
    *(local float*)&data[hook(3, (a_off) << 2)] = a + e;
    *(local float*)&data[hook(3, (c_off + n) << 2)] = c - f;
    *(local float*)&data[hook(3, (c_off) << 2)] = c + f;
  }
}
kernel void amdFHTAdvanceTime(constant unsigned int* channels_map, global unsigned int* round_counters, int step) {
  unsigned int glbl_id = get_local_id(0);
  unsigned int chnl_id = channels_map[hook(0, glbl_id)];

  round_counters[hook(1, chnl_id)] += step;
}