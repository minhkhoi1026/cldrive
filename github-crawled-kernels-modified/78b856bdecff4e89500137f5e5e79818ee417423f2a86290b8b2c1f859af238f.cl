//{"a":2,"b":4,"c":5,"count":3,"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mul4x4(global float* input, global float* output, const float16 a, const unsigned int count) {
  size_t ix;
  global float* b;
  global float* c;

  ix = get_global_id(0);
  if (ix < count) {
    b = input + 16 * ix;
    c = output + 16 * ix;

    for (int i = 0; i < 4; ++i) {
      for (int j = 0; j < 4; ++j) {
        float s1 = 0.0;
        for (int k = 0; k < 4; ++k) {
          float t1 = a[hook(2, 4 * i + k)];
          float t2 = b[hook(4, 4 * k + j)];
          s1 += (t1 * t2);
        }
        c[hook(5, 4 * i + j)] = s1;
      }
    }
  }
}