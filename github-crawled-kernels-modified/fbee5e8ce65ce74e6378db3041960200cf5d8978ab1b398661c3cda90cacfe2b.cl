//{"alpha":9,"cols":7,"dstoffset":5,"dstptr":3,"dststep":4,"exptab":8,"rows":6,"srcoffset":2,"srcptr":0,"srcstep":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void anisodiff(global const uchar* srcptr, int srcstep, int srcoffset, global uchar* dstptr, int dststep, int dstoffset, int rows, int cols, constant float* exptab, float alpha) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if (x < cols && y < rows) {
    int yofs = y * dststep + x * 3;
    int xofs = y * srcstep + x * 3;
    float4 s = 0.f;

    float4 c = (float4)(srcptr[hook(0, xofs)], srcptr[hook(0, xofs + 1)], srcptr[hook(0, xofs + 2)], 0.f);
    float4 delta, adelta;
    float w;

    delta = (float4)(srcptr[hook(0, xofs + 3)], srcptr[hook(0, xofs + 3 + 1)], srcptr[hook(0, xofs + 3 + 2)], 0.f) - c;
    adelta = fabs(delta);
    w = exptab[hook(8, convert_int(adelta.x + adelta.y + adelta.z))];
    s += delta * w;
    delta = (float4)(srcptr[hook(0, xofs + -3)], srcptr[hook(0, xofs + -3 + 1)], srcptr[hook(0, xofs + -3 + 2)], 0.f) - c;
    adelta = fabs(delta);
    w = exptab[hook(8, convert_int(adelta.x + adelta.y + adelta.z))];
    s += delta * w;
    delta = (float4)(srcptr[hook(0, xofs + -srcstep - 3)], srcptr[hook(0, xofs + -srcstep - 3 + 1)], srcptr[hook(0, xofs + -srcstep - 3 + 2)], 0.f) - c;
    adelta = fabs(delta);
    w = exptab[hook(8, convert_int(adelta.x + adelta.y + adelta.z))];
    s += delta * w;
    delta = (float4)(srcptr[hook(0, xofs + -srcstep)], srcptr[hook(0, xofs + -srcstep + 1)], srcptr[hook(0, xofs + -srcstep + 2)], 0.f) - c;
    adelta = fabs(delta);
    w = exptab[hook(8, convert_int(adelta.x + adelta.y + adelta.z))];
    s += delta * w;
    delta = (float4)(srcptr[hook(0, xofs + -srcstep + 3)], srcptr[hook(0, xofs + -srcstep + 3 + 1)], srcptr[hook(0, xofs + -srcstep + 3 + 2)], 0.f) - c;
    adelta = fabs(delta);
    w = exptab[hook(8, convert_int(adelta.x + adelta.y + adelta.z))];
    s += delta * w;
    delta = (float4)(srcptr[hook(0, xofs + srcstep - 3)], srcptr[hook(0, xofs + srcstep - 3 + 1)], srcptr[hook(0, xofs + srcstep - 3 + 2)], 0.f) - c;
    adelta = fabs(delta);
    w = exptab[hook(8, convert_int(adelta.x + adelta.y + adelta.z))];
    s += delta * w;
    delta = (float4)(srcptr[hook(0, xofs + srcstep)], srcptr[hook(0, xofs + srcstep + 1)], srcptr[hook(0, xofs + srcstep + 2)], 0.f) - c;
    adelta = fabs(delta);
    w = exptab[hook(8, convert_int(adelta.x + adelta.y + adelta.z))];
    s += delta * w;
    delta = (float4)(srcptr[hook(0, xofs + srcstep + 3)], srcptr[hook(0, xofs + srcstep + 3 + 1)], srcptr[hook(0, xofs + srcstep + 3 + 2)], 0.f) - c;
    adelta = fabs(delta);
    w = exptab[hook(8, convert_int(adelta.x + adelta.y + adelta.z))];
    s += delta * w;

    s = s * alpha + c;
    uchar4 d = convert_uchar4_sat(convert_int4_rte(s));
    dstptr[hook(3, yofs)] = d.x;
    dstptr[hook(3, yofs + 1)] = d.y;
    dstptr[hook(3, yofs + 2)] = d.z;
  }
}