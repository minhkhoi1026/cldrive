//{"Bias":2,"Gain":1,"Raw":0,"Windowed":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void PreFFT_32f(global unsigned short* Raw, float Gain, float Bias, global float* Windowed) {
  int k = get_global_id(0);
  int j = get_global_id(1);
  int i = get_global_id(2);

  int linear_coord = i + get_global_size(2) * j + get_global_size(1) * get_global_size(2) * k;

  float in = ((float)Raw[hook(0, linear_coord)]) * Gain - Bias;
  float t_WindowSize = get_global_size(2);
  float t = (float)i;

  t = 2 * 3.14159265358979323846264338327950288f * t / (t_WindowSize - 1);
  Windowed[hook(3, linear_coord)] = in * (.5 - .5 * cos(t));
}