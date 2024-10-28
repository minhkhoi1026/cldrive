//{"K":2,"filter_in":1,"image_in":0,"image_out":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Conv2D(global int* image_in, global int* filter_in, int K, global int* image_out) {
  int W;
  int Wn;
  int x;
  int y;
  int ki, kj;

  int sum = 0;

  W = get_global_size(0);
  x = get_global_id(0);
  y = get_global_id(1);
  Wn = W + (K - 1);

  for (ki = 0; ki < K; ki++)
    for (kj = 0; kj < K; kj++) {
      sum = sum + filter_in[hook(1, ki * K + kj)] * image_in[hook(0, Wn * (y + ki) + x + kj)];
    }

  image_out[hook(3, y * W + x)] = sum;
}