//{"pi":1,"px":0,"py":7,"si":5,"sx":4,"sy":6,"wx":2,"wy":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void pick_fw_kernel(const global float* px, const global unsigned* pi, const unsigned wx, const unsigned wy, const unsigned sx, const unsigned si, const unsigned sy, global float* py) {
  const unsigned t = get_global_id(0);
  const unsigned bid_y = get_group_id(1);
  const unsigned ox = bid_y * sx + pi[hook(1, bid_y * si)] * wy;
  const unsigned oy = bid_y * sy;
  if (t < sy)
    py[hook(7, oy + t)] = px[hook(0, ox + (t / wy) * wx + (t % wy))];
}