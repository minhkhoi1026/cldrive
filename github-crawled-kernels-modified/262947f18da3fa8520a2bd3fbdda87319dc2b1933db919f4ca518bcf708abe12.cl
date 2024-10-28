//{"edges":0,"input":1,"out":2}
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

kernel void krnFinal(read_only image2d_t edges, read_only image2d_t input, write_only image2d_t out) {
  float4 edge, pix;
  int2 uv;

  uv = (int2){get_global_id(0), get_global_id(1)};
  edge = read_imagef(edges, sampler, uv);
  pix = read_imagef(input, sampler, uv);

  write_imagef(out, uv, edge.x + pix);
}