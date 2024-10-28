//{"X":0,"Y":1,"kernel_height":10,"kernel_width":9,"maps":4,"pad_height":14,"pad_width":13,"samples":5,"source_height":3,"source_width":2,"stride_height":12,"stride_width":11,"target_height":7,"target_maps":8,"target_width":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void IM2COL(global float* X, global float* Y, int source_width, int source_height, int maps, int samples, int target_width, int target_height, int target_maps, int kernel_width, int kernel_height, int stride_width, int stride_height, int pad_width, int pad_height) {
  const int target_oelement = get_global_id(0);
  const int target_map = get_global_id(1);
  const int sample = get_global_id(2);

  const int ox = target_oelement % target_width;
  const int oy = target_oelement / target_width;

  const int kx = target_map % kernel_width;
  const int ky = (target_map / kernel_width) % kernel_height;
  const int imap = target_map / (kernel_width * kernel_height);

  const int iy = oy * stride_height - pad_height + ky;
  const int ix = ox * stride_width - pad_width + kx;

  if (iy >= 0 && iy < source_height && ix >= 0 && ix < source_width && imap < maps && sample < samples) {
    Y[hook(1, (target_map * samples * target_width * target_height) + (sample * target_height + oy) * target_width + ox)] = X[hook(0, (sample * maps * source_width * source_height) + (imap * source_height + iy) * source_width + ix)];
  } else {
    Y[hook(1, (target_map * samples * target_width * target_height) + (sample * target_height + oy) * target_width + ox)] = 0.0;
  }
}