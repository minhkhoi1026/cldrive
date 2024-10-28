//{"Bias":2,"Gain":1,"HanningWindow":3,"Raw":0,"Windowed":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void PreFFT_Global_32f(global unsigned short* Raw, float Gain, float Bias, global float* HanningWindow, global float* Windowed) {
  int k = get_global_id(0);
  int j = get_global_id(1);
  int i = get_global_id(2);

  int linear_coord = i + get_global_size(2) * j + get_global_size(1) * get_global_size(2) * k;

  float in = ((float)Raw[hook(0, linear_coord)]) * Gain - Bias;

  Windowed[hook(4, linear_coord)] = in * HanningWindow[hook(3, i)];
}