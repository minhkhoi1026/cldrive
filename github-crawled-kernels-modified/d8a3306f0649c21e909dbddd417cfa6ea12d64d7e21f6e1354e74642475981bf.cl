//{"input":1,"output":2,"x":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void unsafe_builtins(float x, constant float* input, global float* output) {
  float y, z, f;
  int i;
  int2 i2;
  float2 h2;
  double2 d2;

  f = fract(x, &y);

  d2 = fract(d2, &d2);

  f = frexp(x, &i);

  h2 = frexp(h2, &i2);

  d2 = frexp(d2, &i2);

  f = modf(x, &y);

  f = lgamma_r(x, &i);

  h2 = lgamma_r(h2, &i2);

  d2 = lgamma_r(d2, &i2);

  f = remquo(x, z, &i);

  h2 = remquo(h2, h2, &i2);

  d2 = remquo(d2, d2, &i2);
}