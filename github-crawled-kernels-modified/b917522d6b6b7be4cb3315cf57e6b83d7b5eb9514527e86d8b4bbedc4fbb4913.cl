//{"N":0,"twiddleFactors":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float2 rotateValue2(float2 value, float c, float s) {
  return (float2)(dot(value, (float2)(c, -s)), dot(value, (float2)(s, c)));
}

kernel void cooleyTukeyFFTTwiddleFactors(int N, global float2* twiddleFactors) {
  int k = get_global_id(0);
  float param = -3.14159265359f * 2 * k / (float)N;
  float c, s = sincos(param, &c);
  twiddleFactors[hook(1, k)] = (float2)(c, s);
}