//{"currentSegmentation":0,"gvf":1,"nextSegmentation":2,"stop":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 2 | 0x10;
kernel void grow(read_only image3d_t currentSegmentation, read_only image3d_t gvf, global uchar* nextSegmentation, global int* stop) {
  int4 X = {get_global_id(0), get_global_id(1), get_global_id(2), 0};
  char value = read_imageui(currentSegmentation, sampler, X).x;

  if (value == 1) {
    nextSegmentation[hook(2, X.x + X.y * get_global_size(0) + X.z * get_global_size(0) * get_global_size(1))] = 1;

  } else if (value == 2) {
    float4 FNX = read_imagef(gvf, sampler, X);
    float FNXw = length(FNX.xyz);

    bool continueGrowing = false;
    for (int a = -1; a < 2; a++) {
      for (int b = -1; b < 2; b++) {
        for (int c = -1; c < 2; c++) {
          if (a == 0 && b == 0 && c == 0)
            continue;

          int4 Y;
          Y.x = X.x + a;
          Y.y = X.y + b;
          Y.z = X.z + c;

          char valueY = read_imageui(currentSegmentation, sampler, Y).x;
          if (valueY != 1) {
            float4 FNY = read_imagef(gvf, sampler, Y);
            FNY.w = length(FNY.xyz);
            FNY.x /= FNY.w;
            FNY.y /= FNY.w;
            FNY.z /= FNY.w;
            if (FNY.w > FNXw) {
              int4 Z;
              float maxDotProduct = -2.0f;
              for (int a2 = -1; a2 < 2; a2++) {
                for (int b2 = -1; b2 < 2; b2++) {
                  for (int c2 = -1; c2 < 2; c2++) {
                    if (a2 == 0 && b2 == 0 && c2 == 0)
                      continue;
                    int4 Zc;
                    Zc.x = Y.x + a2;
                    Zc.y = Y.y + b2;
                    Zc.z = Y.z + c2;
                    float3 YZ;
                    YZ.x = Zc.x - Y.x;
                    YZ.y = Zc.y - Y.y;
                    YZ.z = Zc.z - Y.z;
                    YZ = normalize(YZ);
                    if (dot(FNY.xyz, YZ) > maxDotProduct) {
                      maxDotProduct = dot(FNY.xyz, YZ);
                      Z = Zc;
                    }
                  }
                }
              }

              if (Z.x == X.x && Z.y == X.y && Z.z == X.z) {
                nextSegmentation[hook(2, X.x + X.y * get_global_size(0) + X.z * get_global_size(0) * get_global_size(1))] = 1;

                if (Y.x >= 0 && Y.y >= 0 && Y.z >= 0 && Y.x < get_global_size(0) && Y.y < get_global_size(1) && Y.z < get_global_size(2)) {
                  nextSegmentation[hook(2, Y.x + Y.y * get_global_size(0) + Y.z * get_global_size(0) * get_global_size(1))] = 2;
                }

                continueGrowing = true;
              }
            }
          }
        }
      }
    }

    if (continueGrowing) {
      stop[hook(3, 0)] = 0;
    } else {
      nextSegmentation[hook(2, X.x + X.y * get_global_size(0) + X.z * get_global_size(0) * get_global_size(1))] = 0;
    }
  }
}