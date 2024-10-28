//{"block_rows":5,"height":3,"in":0,"out":1,"tile":4,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void copy2d(global double* in, global double* out, const unsigned int width, const unsigned int height, const unsigned int tile, const unsigned int block_rows) {
  int xid = get_global_id(0);
  int yid = get_global_id(1);

  int index = xid + width * yid;
  out[hook(1, index)] = in[hook(0, index)];
}