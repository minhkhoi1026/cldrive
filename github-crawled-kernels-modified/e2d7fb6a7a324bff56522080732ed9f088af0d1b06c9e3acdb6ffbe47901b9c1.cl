//{"pi":1,"px":0,"py":4,"si":2,"sy":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void batch_pick_fw_kernel(const global float* px, const global unsigned* pi, const unsigned si, const unsigned sy, global float* py) {
  const unsigned t = get_global_id(0);
  const unsigned bid_y = get_group_id(1);
  const unsigned ox = pi[hook(1, bid_y * si)] * sy;
  const unsigned oy = bid_y * sy;
  if (t < sy)
    py[hook(4, oy + t)] = px[hook(0, ox + t)];
}