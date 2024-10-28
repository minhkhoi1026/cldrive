//{"depth":2,"float3":1,"h":7,"ipt":5,"kin":0,"mat":8,"pt":4,"rgb":3,"w":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float4 matmult4(constant float* mat, float4 vec) {
  float4 rvec;
  rvec.x = dot((float4)(mat[hook(8, 0)], mat[hook(8, 4)], mat[hook(8, 8)], mat[hook(8, 12)]), vec);
  rvec.y = dot((float4)(mat[hook(8, 1)], mat[hook(8, 5)], mat[hook(8, 9)], mat[hook(8, 13)]), vec);
  rvec.z = dot((float4)(mat[hook(8, 2)], mat[hook(8, 6)], mat[hook(8, 10)], mat[hook(8, 14)]), vec);
  rvec.w = dot((float4)(mat[hook(8, 3)], mat[hook(8, 7)], mat[hook(8, 11)], mat[hook(8, 15)]), vec);
  return rvec;
}

kernel void project(global float4* kin, global float4* float3, global float* depth, global uchar* rgb, constant float* pt, constant float* ipt, int w, int h) {
  unsigned int i = get_global_id(0);
  int c = i % w;
  int r = (int)(i / w);

  float d = depth[hook(2, i)];
  int irgb = i * 3;
  float4 col = (float4)(rgb[hook(3, irgb + 2)] / 255.f, rgb[hook(3, irgb + 1)] / 255.f, rgb[hook(3, irgb)] / 255.f, 1.0f);
  float4 epix = (float4)(d * c, d * r, d, 1.0f);
  kin[hook(0, i)] = matmult4(ipt, epix);

  kin[hook(0, i)].w = 1.f;

  epix = matmult4(pt, kin[hook(0, i)]);

  int x = (int)(epix.x / epix.z);
  int y = (int)(epix.y / epix.z);

  if (x >= 0 && y >= 0 && x < w && y < h) {
    irgb = y * w * 3 + x * 3;
    float3[hook(1, i)].x = rgb[hook(3, irgb + 2)] / 255.;
    float3[hook(1, i)].y = rgb[hook(3, irgb + 1)] / 255.;
    float3[hook(1, i)].z = rgb[hook(3, irgb)] / 255.;
    float3[hook(1, i)].w = 1.0f;

  } else {
    float3[hook(1, i)] = (float4)(0.f, 0.f, 1.f, 1.f);
  }
}