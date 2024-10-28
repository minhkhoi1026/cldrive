//{"block_hists":0,"smem":3,"squares":2,"threshold":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void normalize_hists_36_kernel(global float* block_hists, const float threshold, local float* squares) {
  const int tid = get_local_id(0);
  const int gid = get_global_id(0);
  const int bid = tid / 36;
  const int boffset = bid * 36;
  const int hid = tid - boffset;

  float elem = block_hists[hook(0, gid)];
  squares[hook(2, tid)] = elem * elem;
  barrier(0x01);

  local float* smem = squares + boffset;
  float sum = smem[hook(3, hid)];
  if (hid < 18)
    smem[hook(3, hid)] = sum = sum + smem[hook(3, hid + 18)];
  barrier(0x01);
  if (hid < 9)
    smem[hook(3, hid)] = sum = sum + smem[hook(3, hid + 9)];
  barrier(0x01);
  if (hid < 4)
    smem[hook(3, hid)] = sum + smem[hook(3, hid + 4)];
  barrier(0x01);
  sum = smem[hook(3, 0)] + smem[hook(3, 1)] + smem[hook(3, 2)] + smem[hook(3, 3)] + smem[hook(3, 8)];

  elem = elem / (sqrt(sum) + 3.6f);
  elem = min(elem, threshold);

  barrier(0x01);
  squares[hook(2, tid)] = elem * elem;
  barrier(0x01);

  sum = smem[hook(3, hid)];
  if (hid < 18)
    smem[hook(3, hid)] = sum = sum + smem[hook(3, hid + 18)];
  barrier(0x01);
  if (hid < 9)
    smem[hook(3, hid)] = sum = sum + smem[hook(3, hid + 9)];
  barrier(0x01);
  if (hid < 4)
    smem[hook(3, hid)] = sum + smem[hook(3, hid + 4)];
  barrier(0x01);
  sum = smem[hook(3, 0)] + smem[hook(3, 1)] + smem[hook(3, 2)] + smem[hook(3, 3)] + smem[hook(3, 8)];

  block_hists[hook(0, gid)] = elem / (sqrt(sum) + 1e-3f);
}