//{"b_threshold":4,"gb_threshold":5,"gr_threshold":2,"input":0,"output":1,"p":6,"r_threshold":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_dpc(read_only image2d_t input, write_only image2d_t output, float gr_threshold, float r_threshold, float b_threshold, float gb_threshold) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  sampler_t sampler = 0 | 2 | 0x10;
  float4 p[9];
  p[hook(6, 0)] = read_imagef(input, sampler, (int2)(x - 2, y - 2));
  p[hook(6, 1)] = read_imagef(input, sampler, (int2)(x, y - 2));
  p[hook(6, 2)] = read_imagef(input, sampler, (int2)(x + 2, y - 2));
  p[hook(6, 3)] = read_imagef(input, sampler, (int2)(x - 2, y));
  p[hook(6, 4)] = read_imagef(input, sampler, (int2)(x, y));
  p[hook(6, 5)] = read_imagef(input, sampler, (int2)(x + 2, y));
  p[hook(6, 6)] = read_imagef(input, sampler, (int2)(x - 2, y + 2));
  p[hook(6, 7)] = read_imagef(input, sampler, (int2)(x, y + 2));
  p[hook(6, 8)] = read_imagef(input, sampler, (int2)(x + 2, y + 2));

  float aveVer = (p[hook(6, 1)].x + p[hook(6, 7)].x) / 2;
  float aveHor = (p[hook(6, 3)].x + p[hook(6, 5)].x) / 2;
  float avePosDia = (p[hook(6, 0)].x + p[hook(6, 8)].x) / 2;
  float aveNegDia = (p[hook(6, 2)].x + p[hook(6, 6)].x) / 2;

  float aveMin, aveMax;
  if (aveVer > aveHor) {
    aveMin = aveHor;
    aveMax = aveVer;
  } else {
    aveMin = aveVer;
    aveMax = aveHor;
  }

  if (avePosDia < aveMin)
    aveMin = avePosDia;
  else if (avePosDia > aveMax)
    aveMax = avePosDia;

  if (aveNegDia < aveMin)
    aveMin = aveNegDia;
  else if (aveNegDia > aveMax)
    aveMax = aveNegDia;

  float edgeVer = p[hook(6, 4)].x - aveVer;
  float edgeHor = p[hook(6, 4)].x - aveHor;
  float edgeNeighbourVer = (p[hook(6, 3)].x + p[hook(6, 5)].x - (p[hook(6, 0)].x + p[hook(6, 2)].x + p[hook(6, 6)].x + p[hook(6, 8)].x) / 2) / 2;
  float edgeNeighbourHor = (p[hook(6, 1)].x + p[hook(6, 7)].x - (p[hook(6, 0)].x + p[hook(6, 2)].x + p[hook(6, 6)].x + p[hook(6, 8)].x) / 2) / 2;

  float threshold;
  if (x % 2 == 0)
    threshold = (y % 2 == 0) ? gr_threshold : b_threshold;
  else
    threshold = (y % 2 == 0) ? r_threshold : gb_threshold;

  float4 pixelOut;
  pixelOut.x = p[hook(6, 4)].x;
  pixelOut.y = p[hook(6, 4)].y;
  pixelOut.z = p[hook(6, 4)].z;
  pixelOut.w = p[hook(6, 4)].w;
  if ((edgeVer > edgeNeighbourVer) && (edgeHor > edgeNeighbourHor)) {
    if ((p[hook(6, 4)].x - aveMax) > threshold) {
      pixelOut.x = aveMax;
    }
  }
  if ((edgeVer < edgeNeighbourVer) && (edgeHor < edgeNeighbourHor)) {
    if ((aveMin - p[hook(6, 4)].x) > threshold) {
      pixelOut.x = aveMin;
    }
  }

  write_imagef(output, (int2)(x, y), pixelOut);
}