//{"height":3,"image":0,"local_image":4,"result":1,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline unsigned int pos2idx(unsigned int x, unsigned int y, unsigned int w) {
  return (y * w + x) * 3;
}

kernel void edge_use_local_mem(const global uchar* restrict image, global uchar* result, unsigned int width, unsigned int height) {
  const unsigned int x = get_global_id(0), y = get_global_id(1);
  const unsigned int lx = get_local_id(0), ly = get_local_id(1);
  const unsigned int lwidth = get_local_size(0), lheight = get_local_size(1);
  const unsigned int left = get_group_id(0) * lwidth, up = get_group_id(1) * lheight;

  local uchar local_image[(32 + 2) * (32 + 2) * 3];

  if (x < 1 || (width - 1) <= x || y < 1 || (height - 1) <= y)
    return;

  for (int i = 0; i < 3; i++) {
    local_image[hook(4, pos2idx(lx + 1, ly + 1, 32 + 2) + i)] = image[hook(0, pos2idx(x, y, width) + i)];
  }
  if (ly <= 1) {
    for (int i = 0; i < 3; i++) {
      local_image[hook(4, pos2idx(1 + lx, (32 + 1) * ly, 32 + 2) + i)] = image[hook(0, pos2idx(x, y + 32 * ly - 1, width) + i)];
    }
  } else if (ly <= 3) {
    for (int i = 0; i < 3; i++)
      local_image[hook(4, pos2idx((32 + 1) * (ly - 2), 1 + lx, 32 + 2) + i)] = image[hook(0, pos2idx(left - 1 + (32 + 1) * (ly - 2), up + lx, width) + i)];
  }
  barrier(0x01);

  for (int i = 0; i < 3; i++) {
    int c =

        -local_image[hook(4, pos2idx(lx, ly + 1, 32 + 2) + i)] + local_image[hook(4, pos2idx(lx + 2, ly + 1, 32 + 2) + i)]

        - local_image[hook(4, pos2idx(lx + 1, ly, 32 + 2) + i)] + local_image[hook(4, pos2idx(lx + 1, ly + 2, 32 + 2) + i)];
    result[hook(1, pos2idx(x, y, width) + i)] = 255 - max(c, 0);
  }
}