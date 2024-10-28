//{"coeff":6,"dst":2,"height":4,"mid":1,"src":0,"stride":5,"width":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void blurY(global const float* restrict src, global float* restrict mid, global uchar* restrict dst, const unsigned int width, const unsigned int height, const unsigned int stride, const float4 coeff) {
  float16 in4, tmp;
  {
    global const float* restrict ptrIn = src + get_global_id(0) * height * 4;
    global float* restrict ptrOut = mid + get_global_id(0) * height * 4;
    in4.s0123 = vload4(0, ptrIn);
    tmp = (float16)(in4.s0123, in4.s0123, in4.s0123, in4.s0123);
    for (unsigned int i = 0, j = 0; j < height; j += 4) {
      in4 = vload16(i, ptrIn);
      tmp.s0123 = in4.s0123 * coeff.x + tmp.scdef * coeff.y + tmp.s89ab * coeff.z + tmp.s4567 * coeff.w;
      tmp.s4567 = in4.s4567 * coeff.x + tmp.s0123 * coeff.y + tmp.scdef * coeff.z + tmp.s89ab * coeff.w;
      tmp.s89ab = in4.s89ab * coeff.x + tmp.s4567 * coeff.y + tmp.s0123 * coeff.z + tmp.scdef * coeff.w;
      tmp.scdef = in4.scdef * coeff.x + tmp.s89ab * coeff.y + tmp.s4567 * coeff.z + tmp.s0123 * coeff.w;
      vstore16(tmp, i++, ptrOut);
    }
  }
  {
    global const float* restrict ptrIn = mid + get_global_id(0) * height * 4;
    global uchar* restrict ptrOut = dst + get_global_id(0) * 4 + stride * (height - 1) * 4;
    in4.scdef = vload4(height - 1, ptrIn);
    tmp = (float16)(in4.scdef, in4.scdef, in4.scdef, in4.scdef);
    for (unsigned int i = height / 4 - 1, j = 0; j < height; j += 4) {
      in4 = vload16(i--, ptrIn);
      tmp.scdef = in4.scdef * coeff.x + tmp.s0123 * coeff.y + tmp.s4567 * coeff.z + tmp.s89ab * coeff.w;
      vstore4(convert_uchar4(tmp.scdef), 0, ptrOut);
      ptrOut -= stride * 4;
      tmp.s89ab = in4.s89ab * coeff.x + tmp.scdef * coeff.y + tmp.s0123 * coeff.z + tmp.s4567 * coeff.w;
      vstore4(convert_uchar4(tmp.s89ab), 0, ptrOut);
      ptrOut -= stride * 4;
      tmp.s4567 = in4.s4567 * coeff.x + tmp.s89ab * coeff.y + tmp.scdef * coeff.z + tmp.s0123 * coeff.w;
      vstore4(convert_uchar4(tmp.s4567), 0, ptrOut);
      ptrOut -= stride * 4;
      tmp.s0123 = in4.s0123 * coeff.x + tmp.s4567 * coeff.y + tmp.s89ab * coeff.z + tmp.scdef * coeff.w;
      vstore4(convert_uchar4(tmp.s0123), 0, ptrOut);
      ptrOut -= stride * 4;
    }
  }
}