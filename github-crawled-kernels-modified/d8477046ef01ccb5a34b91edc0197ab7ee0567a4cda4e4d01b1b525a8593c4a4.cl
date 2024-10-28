//{"delta":0,"hid":1,"in":3,"ly":2,"oldw":5,"w":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void bpnn_adjust_weights_ocl(global float* delta, int hid, global float* ly, int in, global float* w, global float* oldw) {
  int by = get_group_id(1);
  int tx = get_local_id(0);
  int ty = get_local_id(1);

  int index = (hid + 1) * 16 * by + (hid + 1) * ty + tx + 1 + (hid + 1);
  int index_y = 16 * by + ty + 1;
  int index_x = tx + 1;

  w[hook(4, index)] += ((0.3f * delta[hook(0, index_x)] * ly[hook(2, index_y)]) + (0.3f * oldw[hook(5, index)]));
  oldw[hook(5, index)] = ((0.3f * delta[hook(0, index_x)] * ly[hook(2, index_y)]) + (0.3f * oldw[hook(5, index)]));

  barrier(0x01);

  if (ty == 0 && by == 0) {
    w[hook(4, index_x)] += ((0.3f * delta[hook(0, index_x)]) + (0.3f * oldw[hook(5, index_x)]));
    oldw[hook(5, index_x)] = ((0.3f * delta[hook(0, index_x)]) + (0.3f * oldw[hook(5, index_x)]));
  }
}