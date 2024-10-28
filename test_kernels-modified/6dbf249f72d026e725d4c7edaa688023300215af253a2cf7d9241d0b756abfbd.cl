//{"in":0,"length":2,"out":1,"sign":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void dft(global const float2* in, global float2* out, int length, int sign) {
  int i = get_global_id(0);

  if (i >= length)
    return;

  float2 tot = 0;
  float param = (-2 * sign * i) * 3.141593f / (float)length;

  for (int k = 0; k < length; k++) {
    float2 value = in[hook(0, k)];

    float c;
    float s = sincos(k * param, &c);

    tot += (float2)(dot(value, (float2)(c, -s)), dot(value, (float2)(s, c)));
  }

  if (sign == 1) {
    out[hook(1, i)] = tot;
  } else {
    out[hook(1, i)] = tot / (float)length;
  }
}