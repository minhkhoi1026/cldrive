//{"N":1,"Y":0,"inverse":3,"twiddleFactors":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float2 rotateValue2(float2 value, float c, float s) {
  return (float2)(dot(value, (float2)(c, -s)), dot(value, (float2)(s, c)));
}

kernel void cooleyTukeyFFT(global float2* Y, int N, global float2* twiddleFactors, int inverse) {
  int k = get_global_id(0);
  int halfN = N / 2;
  int offsetY = get_global_id(1) * N;

  float2 tf = twiddleFactors[hook(2, k)];
  float c = tf.x, s = tf.y;
  if (inverse)
    s = -s;

  int o1 = offsetY + k;
  int o2 = o1 + halfN;
  float2 y1 = Y[hook(0, o1)];
  float2 y2 = Y[hook(0, o2)];

  float2 v = rotateValue2(y2, c, s);
  Y[hook(0, o1)] = y1 + v;
  Y[hook(0, o2)] = y1 - v;
}