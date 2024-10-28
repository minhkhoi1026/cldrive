//{"block_count_x":6,"in":0,"out":1,"roi_x":4,"roi_y":5,"xsize":2,"ysize":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_pixelise(global float4* in, global float4* out, int xsize, int ysize, int roi_x, int roi_y, int block_count_x) {
  int gidx = get_global_id(0);
  int gidy = get_global_id(1);

  int src_width = get_global_size(0);
  int cx = (gidx + roi_x) / xsize - roi_x / xsize;
  int cy = (gidy + roi_y) / ysize - roi_y / ysize;
  out[hook(1, gidx + gidy * src_width)] = in[hook(0, cx + cy * block_count_x)];
}