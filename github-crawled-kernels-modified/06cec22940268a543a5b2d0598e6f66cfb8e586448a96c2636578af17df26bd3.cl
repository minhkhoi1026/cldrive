//{"in_img":0,"neighbors":2,"out_img":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant int2 neighbors[] = {(int2)(-1, -1), (int2)(0, -1), (int2)(1, -1), (int2)(1, 0), (int2)(1, 1), (int2)(0, 1), (int2)(-1, 1), (int2)(-1, 0)};

constant uint2 live_rule = (uint2)(2, 3);
constant uint2 dead_rule = (uint2)(3, 3);

constant sampler_t sampler = 0 | 0 | 0x10;

kernel void ca(read_only image2d_t in_img, write_only image2d_t out_img) {
  int2 imdim = get_image_dim(in_img);

  int2 coord = (int2)(get_global_id(0), get_global_id(1));

  if (all(coord < imdim)) {
    uint4 neighs_state;

    unsigned int neighs_alive = 0;

    uint4 state;

    unsigned int alive;

    uint4 new_state = ((uint4)(0xFF, 0xFF, 0xFF, 0xFF));

    for (int i = 0; i < 8; ++i) {
      int2 n = coord + neighbors[hook(2, i)];
      n = select(n, n - imdim, n >= imdim);
      n = select(n, imdim - 1, n < 0);

      neighs_state = read_imageui(in_img, sampler, n);

      if ((neighs_state.x == 0x00))
        neighs_alive++;
    }

    state = read_imageui(in_img, sampler, coord);
    alive = (state.x == 0x00);

    if ((alive && (neighs_alive >= live_rule.s0) && (neighs_alive <= live_rule.s1)) || (!alive && (neighs_alive >= dead_rule.s0) && (neighs_alive <= dead_rule.s1))) {
      new_state = (uint4){0x00, 0x00, 0x00, 0xFF};
    }

    write_imageui(out_img, coord, new_state);
  }
}