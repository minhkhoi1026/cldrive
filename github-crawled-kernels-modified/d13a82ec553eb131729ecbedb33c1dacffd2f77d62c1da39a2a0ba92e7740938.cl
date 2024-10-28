//{"dst":0,"inp":1,"salt":5,"size":2,"sizein":3,"str":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void __attribute__((reqd_work_group_size(64, 1, 1))) strmodify(global unsigned int* dst, global unsigned int* inp, global unsigned int* size, global unsigned int* sizein, uint16 str, uint16 salt) {
  unsigned int a, tmp1, tmp2, elem, l;

  size[hook(2, get_global_id(0))] = sizein[hook(3, get_global_id(0))];
  a = inp[hook(1, get_global_id(0) * 24)];
  {
    l = (a);
    tmp1 = rotate(l, 8U);
    tmp2 = rotate(l, 24U);
    (a) = bitselect(tmp2, tmp1, 0x00FF00FFU);
  };
  dst[hook(0, get_global_id(0) * 24)] = a;
  a = inp[hook(1, get_global_id(0) * 24 + 1)];
  {
    l = (a);
    tmp1 = rotate(l, 8U);
    tmp2 = rotate(l, 24U);
    (a) = bitselect(tmp2, tmp1, 0x00FF00FFU);
  };
  dst[hook(0, get_global_id(0) * 24 + 1)] = a;
  a = inp[hook(1, get_global_id(0) * 24 + 2)];
  {
    l = (a);
    tmp1 = rotate(l, 8U);
    tmp2 = rotate(l, 24U);
    (a) = bitselect(tmp2, tmp1, 0x00FF00FFU);
  };
  dst[hook(0, get_global_id(0) * 24 + 2)] = a;
  a = inp[hook(1, get_global_id(0) * 24 + 3)];
  {
    l = (a);
    tmp1 = rotate(l, 8U);
    tmp2 = rotate(l, 24U);
    (a) = bitselect(tmp2, tmp1, 0x00FF00FFU);
  };
  dst[hook(0, get_global_id(0) * 24 + 3)] = a;
  a = inp[hook(1, get_global_id(0) * 24 + 4)];
  {
    l = (a);
    tmp1 = rotate(l, 8U);
    tmp2 = rotate(l, 24U);
    (a) = bitselect(tmp2, tmp1, 0x00FF00FFU);
  };
  dst[hook(0, get_global_id(0) * 24 + 4)] = a;
  a = inp[hook(1, get_global_id(0) * 24 + 5)];
  {
    l = (a);
    tmp1 = rotate(l, 8U);
    tmp2 = rotate(l, 24U);
    (a) = bitselect(tmp2, tmp1, 0x00FF00FFU);
  };
  dst[hook(0, get_global_id(0) * 24 + 5)] = a;
  a = inp[hook(1, get_global_id(0) * 24 + 6)];
  {
    l = (a);
    tmp1 = rotate(l, 8U);
    tmp2 = rotate(l, 24U);
    (a) = bitselect(tmp2, tmp1, 0x00FF00FFU);
  };
  dst[hook(0, get_global_id(0) * 24 + 6)] = a;
  a = inp[hook(1, get_global_id(0) * 24 + 7)];
  {
    l = (a);
    tmp1 = rotate(l, 8U);
    tmp2 = rotate(l, 24U);
    (a) = bitselect(tmp2, tmp1, 0x00FF00FFU);
  };
  dst[hook(0, get_global_id(0) * 24 + 7)] = a;
  a = inp[hook(1, get_global_id(0) * 24 + 8)];
  {
    l = (a);
    tmp1 = rotate(l, 8U);
    tmp2 = rotate(l, 24U);
    (a) = bitselect(tmp2, tmp1, 0x00FF00FFU);
  };
  dst[hook(0, get_global_id(0) * 24 + 8)] = a;
  a = inp[hook(1, get_global_id(0) * 24 + 9)];
  {
    l = (a);
    tmp1 = rotate(l, 8U);
    tmp2 = rotate(l, 24U);
    (a) = bitselect(tmp2, tmp1, 0x00FF00FFU);
  };
  dst[hook(0, get_global_id(0) * 24 + 9)] = a;
  a = inp[hook(1, get_global_id(0) * 24 + 10)];
  {
    l = (a);
    tmp1 = rotate(l, 8U);
    tmp2 = rotate(l, 24U);
    (a) = bitselect(tmp2, tmp1, 0x00FF00FFU);
  };
  dst[hook(0, get_global_id(0) * 24 + 10)] = a;
  a = inp[hook(1, get_global_id(0) * 24 + 11)];
  {
    l = (a);
    tmp1 = rotate(l, 8U);
    tmp2 = rotate(l, 24U);
    (a) = bitselect(tmp2, tmp1, 0x00FF00FFU);
  };
  dst[hook(0, get_global_id(0) * 24 + 11)] = a;
  a = inp[hook(1, get_global_id(0) * 24 + 12)];
  {
    l = (a);
    tmp1 = rotate(l, 8U);
    tmp2 = rotate(l, 24U);
    (a) = bitselect(tmp2, tmp1, 0x00FF00FFU);
  };
  dst[hook(0, get_global_id(0) * 24 + 12)] = a;
  a = inp[hook(1, get_global_id(0) * 24 + 13)];
  {
    l = (a);
    tmp1 = rotate(l, 8U);
    tmp2 = rotate(l, 24U);
    (a) = bitselect(tmp2, tmp1, 0x00FF00FFU);
  };
  dst[hook(0, get_global_id(0) * 24 + 13)] = a;
  a = inp[hook(1, get_global_id(0) * 24 + 14)];
  {
    l = (a);
    tmp1 = rotate(l, 8U);
    tmp2 = rotate(l, 24U);
    (a) = bitselect(tmp2, tmp1, 0x00FF00FFU);
  };
  dst[hook(0, get_global_id(0) * 24 + 14)] = a;
  a = inp[hook(1, get_global_id(0) * 24 + 15)];
  {
    l = (a);
    tmp1 = rotate(l, 8U);
    tmp2 = rotate(l, 24U);
    (a) = bitselect(tmp2, tmp1, 0x00FF00FFU);
  };
  dst[hook(0, get_global_id(0) * 24 + 15)] = a;
  a = inp[hook(1, get_global_id(0) * 24 + 16)];
  {
    l = (a);
    tmp1 = rotate(l, 8U);
    tmp2 = rotate(l, 24U);
    (a) = bitselect(tmp2, tmp1, 0x00FF00FFU);
  };
  dst[hook(0, get_global_id(0) * 24 + 16)] = a;
  a = inp[hook(1, get_global_id(0) * 24 + 17)];
  {
    l = (a);
    tmp1 = rotate(l, 8U);
    tmp2 = rotate(l, 24U);
    (a) = bitselect(tmp2, tmp1, 0x00FF00FFU);
  };
  dst[hook(0, get_global_id(0) * 24 + 17)] = a;
  a = inp[hook(1, get_global_id(0) * 24 + 18)];
  {
    l = (a);
    tmp1 = rotate(l, 8U);
    tmp2 = rotate(l, 24U);
    (a) = bitselect(tmp2, tmp1, 0x00FF00FFU);
  };
  dst[hook(0, get_global_id(0) * 24 + 18)] = a;
  a = inp[hook(1, get_global_id(0) * 24 + 19)];
  {
    l = (a);
    tmp1 = rotate(l, 8U);
    tmp2 = rotate(l, 24U);
    (a) = bitselect(tmp2, tmp1, 0x00FF00FFU);
  };
  dst[hook(0, get_global_id(0) * 24 + 19)] = a;
  a = inp[hook(1, get_global_id(0) * 24 + 20)];
  {
    l = (a);
    tmp1 = rotate(l, 8U);
    tmp2 = rotate(l, 24U);
    (a) = bitselect(tmp2, tmp1, 0x00FF00FFU);
  };
  dst[hook(0, get_global_id(0) * 24 + 20)] = a;
  a = inp[hook(1, get_global_id(0) * 24 + 21)];
  {
    l = (a);
    tmp1 = rotate(l, 8U);
    tmp2 = rotate(l, 24U);
    (a) = bitselect(tmp2, tmp1, 0x00FF00FFU);
  };
  dst[hook(0, get_global_id(0) * 24 + 21)] = a;
  a = inp[hook(1, get_global_id(0) * 24 + 22)];
  {
    l = (a);
    tmp1 = rotate(l, 8U);
    tmp2 = rotate(l, 24U);
    (a) = bitselect(tmp2, tmp1, 0x00FF00FFU);
  };
  dst[hook(0, get_global_id(0) * 24 + 22)] = a;
  a = inp[hook(1, get_global_id(0) * 24 + 23)];
  {
    l = (a);
    tmp1 = rotate(l, 8U);
    tmp2 = rotate(l, 24U);
    (a) = bitselect(tmp2, tmp1, 0x00FF00FFU);
  };
  dst[hook(0, get_global_id(0) * 24 + 23)] = a;
}