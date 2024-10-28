//{"C":2,"G":5,"H":3,"W":4,"dst_data":1,"dst_line":6,"src_data":0,"src_line":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ShuffleChannel(global const float* restrict src_data, global float* restrict dst_data, int C, int H, int W, int G) {
  int c = get_global_id(0);
  if (c >= C)
    return;
  int CX = C / G;
  int CY = G;
  int cy = c % G;
  int cx = c / G;

  global const float8* src_line = ((global const float8*)(src_data + cy * CX * H * W + cx * H * W));
  global float8* dst_line = ((global float8*)(dst_data + cx * CY * H * W + cy * H * W));

  for (int i = 0; i < W * H / 8; i++) {
    dst_line[hook(6, i)] = src_line[hook(7, i)];
  }

  for (int i = W * H / 8 * 8; i < W * H; i++) {
    dst_data[hook(1, cx * CY * H * W + cy * H * W + i)] = src_data[hook(0, cy * CX * H * W + cx * H * W + i)];
  }
}