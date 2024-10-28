//{"a":4,"aa":2,"b":5,"c":6,"count":3,"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mul4x4(global float* input, global float* output, const float16 aa, const unsigned int count) {
  size_t ix;
  global float* b;
  global float* c;
  float* a = (float*)&aa;

  ix = get_global_id(0);
  if (ix < count) {
    int i, j, k;

    b = input + ix * 16;
    c = output + ix * 16;

    for (i = 0; i < 4; i++) {
      for (j = 0; j < 4; j++) {
        float s1 = 0.0f;
        for (k = 0; k < 4; k++) {
          float t1 = a[hook(4, 4 * i + k)];
          float t2 = b[hook(5, 4 * k + j)];
          s1 += (t1 * t2);
        }
        c[hook(6, 4 * i + j)] = s1;
      }
    }
  }
}