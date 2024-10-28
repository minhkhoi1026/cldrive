//{"colour_map":1,"conv_table":0,"img_edge":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kirsch_edges(global const uchar* conv_table, global const uchar* colour_map, global uchar3* img_edge) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  img_edge[hook(2, y * 2560 + x)].x = 255;
  img_edge[hook(2, y * 2560 + x)].y = 255;
  img_edge[hook(2, y * 2560 + x)].z = 255;
}