//{"input":3,"input_len":4,"macd_pct":0,"wll":1,"wls":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void macd(global float* macd_pct, global unsigned int* wll, global unsigned int* wls, global float* input, const unsigned int input_len) {
 private
  int global_id = get_global_id(0);
 private
  int group_id = get_group_id(0);
 private
  int local_id = get_local_id(0);

 private
  float ema_short_mult = (2.0 / (wls[hook(2, global_id)] + 1));
 private
  float ema_long_mult = (2.0 / (wll[hook(1, global_id)] + 1));
 private
  float ema_short = 0;
 private
  float ema_long = 0;

  for (unsigned int j = 0; j < input_len; j++) {
    ema_long = (input[hook(3, j)] - ema_long) * ema_long_mult + ema_long;
    ema_short = (input[hook(3, j)] - ema_short) * ema_short_mult + ema_short;

    macd_pct[hook(0, (global_id * input_len) + j)] = (float)global_id;
    mem_fence(0x01 | 0x02);
  }
}