//{"OFF3X3":2,"OFF5X5":3,"nms":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0x10 | 0 | 2;
constant float TLOW = 0.01;
constant float THIGH = 0.3;
constant int2 OFF3X3[] = {
    (int2)(-1, -1), (int2)(0, -1), (int2)(1, -1), (int2)(-1, 0), (int2)(1, 0), (int2)(-1, 1), (int2)(0, 1), (int2)(1, 1),
};

constant int2 OFF5X5[] = {(int2)(-2, -2), (int2)(-1, -2), (int2)(0, -2), (int2)(1, -2), (int2)(2, -2), (int2)(-2, -1), (int2)(2, -1), (int2)(-2, 0), (int2)(2, 0), (int2)(-2, 1), (int2)(2, 1), (int2)(-2, 2), (int2)(-1, 2), (int2)(0, 2), (int2)(1, 2), (int2)(2, 2)};

kernel void krnHysteresis(read_only image2d_t nms, write_only image2d_t out) {
  int2 uv;
  int i;
  bool cont;
  float4 pix, neigh;

  uv = (int2){get_global_id(0), get_global_id(1)};
  pix = read_imagef(nms, sampler, uv);

  if (pix.x >= THIGH) {
    write_imagef(out, uv, (float4)(1));
    return;
  } else if (pix.x >= TLOW) {
    cont = false;
    for (i = 0; i < 8; ++i) {
      neigh = read_imagef(nms, sampler, uv + OFF3X3[hook(2, i)]);
      if (neigh.x >= THIGH) {
        write_imagef(out, uv, (float4)(1));
        return;
      } else if (neigh.x >= TLOW) {
        cont = true;
      }
    }

    if (cont) {
      for (i = 0; i < 16; ++i) {
        neigh = read_imagef(nms, sampler, uv + OFF5X5[hook(3, i)]);
        if (neigh.x >= THIGH) {
          write_imagef(out, uv, (float4)(1));
          return;
        }
      }
    }
  }

  write_imagef(out, uv, (float)(0.0));
}