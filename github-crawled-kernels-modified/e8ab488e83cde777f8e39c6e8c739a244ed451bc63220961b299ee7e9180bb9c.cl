//{"in_out":0,"lMemLoad":4,"lMemStore":3,"sMem":2,"sMem[get_local_id(1)]":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void fft0(global float2* in_out) {
  const int dir = -1;
  local float2 sMem[4][272];
  int i, j;
  float ang, angf;
  local float2 *lMemStore, *lMemLoad;
  float2 a0, a1, a2, a3;
  int offset = (get_group_id(0) * 4 + get_local_id(1)) * 256 + get_local_id(0);
  in_out += offset;
  a0 = in_out[hook(0, 0)];
  a1 = in_out[hook(0, 64)];
  a2 = in_out[hook(0, 128)];
  a3 = in_out[hook(0, 192)];
  {
    {
      float2 c = ((a0));
      ((a0)) = c + ((a2));
      ((a2)) = c - ((a2));
    };
    {
      float2 c = ((a1));
      ((a1)) = c + ((a3));
      ((a3)) = c - ((a3));
    };
    {
      float2 c = ((a0));
      ((a0)) = c + ((a1));
      ((a1)) = c - ((a1));
    };
    (a3) = (float2)(dir) * (((float2)(-((a3)).y, ((a3)).x)));
    {
      float2 c = ((a2));
      ((a2)) = c + ((a3));
      ((a3)) = c - ((a3));
    };
    float2 c = (a1);
    (a1) = (a2);
    (a2) = c;
  };
  angf = (float)get_local_id(0);
  ang = dir * (2.0f * 3.14159265358979323846f * 1.0f / 256.0f) * angf;
  float2 w0 = (float2)(native_cos(ang), native_sin(ang));
  ang = dir * (2.0f * 3.14159265358979323846f * 2.0f / 256.0f) * angf;
  float2 w1 = (float2)(native_cos(ang), native_sin(ang));
  ang = dir * (2.0f * 3.14159265358979323846f * 3.0f / 256.0f) * angf;
  float2 w2 = (float2)(native_cos(ang), native_sin(ang));
  a1 = ((float2)(mad(-(a1).y, (w0).y, (a1).x * (w0).x), mad((a1).y, (w0).x, (a1).x * (w0).y)));
  a2 = ((float2)(mad(-(a2).y, (w1).y, (a2).x * (w1).x), mad((a2).y, (w1).x, (a2).x * (w1).y)));
  a3 = ((float2)(mad(-(a3).y, (w2).y, (a3).x * (w2).x), mad((a3).y, (w2).x, (a3).x * (w2).y)));
  lMemStore = &sMem[hook(2, get_local_id(1))][hook(1, get_local_id(0))];
  j = get_local_id(0) & 3;
  i = get_local_id(0) >> 2;
  lMemLoad = &sMem[hook(2, get_local_id(1))][hook(1, j * 68 + i)];
  lMemStore[hook(3, 0)] = a0;
  lMemStore[hook(3, 68)] = a1;
  lMemStore[hook(3, 136)] = a2;
  lMemStore[hook(3, 204)] = a3;
  barrier(0x01);
  a0 = lMemLoad[hook(4, 0)];
  a1 = lMemLoad[hook(4, 16)];
  a2 = lMemLoad[hook(4, 32)];
  a3 = lMemLoad[hook(4, 48)];
  barrier(0x01);
  {
    {
      float2 c = ((a0));
      ((a0)) = c + ((a2));
      ((a2)) = c - ((a2));
    };
    {
      float2 c = ((a1));
      ((a1)) = c + ((a3));
      ((a3)) = c - ((a3));
    };
    {
      float2 c = ((a0));
      ((a0)) = c + ((a1));
      ((a1)) = c - ((a1));
    };
    (a3) = (float2)(dir) * (((float2)(-((a3)).y, ((a3)).x)));
    {
      float2 c = ((a2));
      ((a2)) = c + ((a3));
      ((a3)) = c - ((a3));
    };
    float2 c = (a1);
    (a1) = (a2);
    (a2) = c;
  };
  angf = (float)(get_local_id(0) >> 2);
  ang = dir * (2.0f * 3.14159265358979323846f * 1.0f / 64.0f) * angf;
  float2 w3 = (float2)(native_cos(ang), native_sin(ang));
  ang = dir * (2.0f * 3.14159265358979323846f * 2.0f / 64.0f) * angf;
  float2 w4 = (float2)(native_cos(ang), native_sin(ang));
  ang = dir * (2.0f * 3.14159265358979323846f * 3.0f / 64.0f) * angf;
  float2 w5 = (float2)(native_cos(ang), native_sin(ang));
  a1 = ((float2)(mad(-(a1).y, (w3).y, (a1).x * (w3).x), mad((a1).y, (w3).x, (a1).x * (w3).y)));
  a2 = ((float2)(mad(-(a2).y, (w4).y, (a2).x * (w4).x), mad((a2).y, (w4).x, (a2).x * (w4).y)));
  a3 = ((float2)(mad(-(a3).y, (w5).y, (a3).x * (w5).x), mad((a3).y, (w5).x, (a3).x * (w5).y)));
  j = (get_local_id(0) & 15) >> 2;
  i = (get_local_id(0) >> 4) * 4 + (get_local_id(0) & 3);
  lMemLoad = &sMem[hook(2, get_local_id(1))][hook(1, j * 68 + i)];
  lMemStore[hook(3, 0)] = a0;
  lMemStore[hook(3, 68)] = a1;
  lMemStore[hook(3, 136)] = a2;
  lMemStore[hook(3, 204)] = a3;
  barrier(0x01);
  a0 = lMemLoad[hook(4, 0)];
  a1 = lMemLoad[hook(4, 16)];
  a2 = lMemLoad[hook(4, 32)];
  a3 = lMemLoad[hook(4, 48)];
  barrier(0x01);
  {
    {
      float2 c = ((a0));
      ((a0)) = c + ((a2));
      ((a2)) = c - ((a2));
    };
    {
      float2 c = ((a1));
      ((a1)) = c + ((a3));
      ((a3)) = c - ((a3));
    };
    {
      float2 c = ((a0));
      ((a0)) = c + ((a1));
      ((a1)) = c - ((a1));
    };
    (a3) = (float2)(dir) * (((float2)(-((a3)).y, ((a3)).x)));
    {
      float2 c = ((a2));
      ((a2)) = c + ((a3));
      ((a3)) = c - ((a3));
    };
    float2 c = (a1);
    (a1) = (a2);
    (a2) = c;
  };
  angf = (float)(get_local_id(0) >> 4);
  ang = dir * (2.0f * 3.14159265358979323846f * 1.0f / 16.0f) * angf;
  float2 w6 = (float2)(native_cos(ang), native_sin(ang));
  ang = dir * (2.0f * 3.14159265358979323846f * 2.0f / 16.0f) * angf;
  float2 w7 = (float2)(native_cos(ang), native_sin(ang));
  ang = dir * (2.0f * 3.14159265358979323846f * 3.0f / 16.0f) * angf;
  float2 w8 = (float2)(native_cos(ang), native_sin(ang));
  a1 = ((float2)(mad(-(a1).y, (w6).y, (a1).x * (w6).x), mad((a1).y, (w6).x, (a1).x * (w6).y)));
  a2 = ((float2)(mad(-(a2).y, (w7).y, (a2).x * (w7).x), mad((a2).y, (w7).x, (a2).x * (w7).y)));
  a3 = ((float2)(mad(-(a3).y, (w8).y, (a3).x * (w8).x), mad((a3).y, (w8).x, (a3).x * (w8).y)));
  j = get_local_id(0) >> 4;
  i = get_local_id(0) & 15;
  lMemLoad = &sMem[hook(2, get_local_id(1))][hook(1, j * 64 + i)];
  lMemStore[hook(3, 0)] = a0;
  lMemStore[hook(3, 64)] = a1;
  lMemStore[hook(3, 128)] = a2;
  lMemStore[hook(3, 192)] = a3;
  barrier(0x01);
  a0 = lMemLoad[hook(4, 0)];
  a1 = lMemLoad[hook(4, 16)];
  a2 = lMemLoad[hook(4, 32)];
  a3 = lMemLoad[hook(4, 48)];
  {
    {
      float2 c = ((a0));
      ((a0)) = c + ((a2));
      ((a2)) = c - ((a2));
    };
    {
      float2 c = ((a1));
      ((a1)) = c + ((a3));
      ((a3)) = c - ((a3));
    };
    {
      float2 c = ((a0));
      ((a0)) = c + ((a1));
      ((a1)) = c - ((a1));
    };
    (a3) = (float2)(dir) * (((float2)(-((a3)).y, ((a3)).x)));
    {
      float2 c = ((a2));
      ((a2)) = c + ((a3));
      ((a3)) = c - ((a3));
    };
    float2 c = (a1);
    (a1) = (a2);
    (a2) = c;
  };
  in_out[hook(0, 0)] = a0;
  in_out[hook(0, 64)] = a1;
  in_out[hook(0, 128)] = a2;
  in_out[hook(0, 192)] = a3;
}