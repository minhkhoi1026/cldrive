//{"Bias":2,"Gain":1,"HanningWindow":3,"Raw":0,"WindowMultiple":4,"Windowed":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void PreFFT_Local_32f(global unsigned short* Raw, float Gain, float Bias, global float* HanningWindow, local float* WindowMultiple, global float* Windowed) {
  WindowMultiple[hook(4, get_local_id(2))] = HanningWindow[hook(3, get_global_id(2))];

  read_mem_fence(0x01);

  int k = get_global_id(0);
  int j = get_global_id(1);
  int i = get_global_id(2);

  int linear_coord = i + get_global_size(2) * j + get_global_size(1) * get_global_size(2) * k;

  float in = ((float)Raw[hook(0, linear_coord)]) * Gain - Bias;

  WindowMultiple[hook(4, get_local_id(2))] = in * WindowMultiple[hook(4, get_local_id(2))];

  Windowed[hook(5, linear_coord)] = WindowMultiple[hook(4, get_local_id(2))];

  write_mem_fence(0x02);
}