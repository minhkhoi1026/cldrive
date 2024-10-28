//{"bias":5,"filt":1,"image_buff":6,"in":0,"nFilterHeight":4,"nFilterWidth":3,"out":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void conv_local(global float* in, constant float* filt, global float* out, const int nFilterWidth, const int nFilterHeight, const float bias, local float* image_buff) {
  int x = get_local_id(0);
  int y = get_local_id(1);

  int row = get_global_id(1);

  const int ImWidth = get_global_size(0);
  const int ImHeight = get_global_size(1);

  image_buff[hook(6, y * (ImWidth + nFilterWidth - 1) + x)] = in[hook(0, row * (ImWidth + nFilterWidth - 1) + x)];
  if (y > (get_local_size(1) - nFilterHeight)) {
    image_buff[hook(6, (y + nFilterHeight - 1) * (ImWidth + nFilterWidth - 1) + x)] = in[hook(0, (row + nFilterHeight - 1) * (ImWidth + nFilterWidth - 1) + x)];
  }
  barrier(0x01);

  float sum = 0;
  for (int r = 0; r < nFilterHeight; r++) {
    for (int c = 0; c < nFilterWidth; c++) {
      sum += filt[hook(1, r * nFilterWidth + c)] * image_buff[hook(6, (y + r) * (ImWidth + nFilterWidth - 1) + x + c)];
    }
  }
  out[hook(2, row * ImWidth + x)] = sum + bias;
}