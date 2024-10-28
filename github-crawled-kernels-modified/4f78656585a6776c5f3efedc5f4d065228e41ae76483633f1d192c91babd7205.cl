//{"default_perm":5,"grads2d":4,"grads3d":6,"output":0,"wx":1,"wy":2,"wz":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant unsigned int default_perm[256] = {151, 91, 90, 15, 131, 13, 201, 95, 96, 53, 194, 233, 7, 225, 99, 37, 8, 240, 21, 10, 23, 190, 6, 148, 247, 120, 234, 75, 0, 26, 160, 137, 35, 11, 32, 57, 177, 33, 88, 237, 149, 56, 87, 174, 20, 125, 136, 171, 134, 139, 48, 27, 166, 77, 146, 158, 231, 83, 111, 229, 122, 60, 211, 133, 55, 46, 245, 40, 244, 102, 143, 54, 65, 25, 63, 161, 1, 216, 80, 73, 18, 169, 200, 196, 135, 130, 116, 188, 159, 86, 164, 100, 109, 198, 173, 186, 250, 124, 123, 5, 202, 38, 147, 118, 126, 255, 82, 85, 212, 207, 206, 59, 189, 28, 42, 223, 183, 170, 213, 119, 248, 152, 2, 44, 154, 163, 70, 221, 43, 172, 9, 129, 22, 39, 253, 19, 98, 108, 110, 79, 113, 224, 232, 178, 97, 228, 251, 34, 242, 193, 238, 210, 144, 12, 191, 179, 162, 241, 81, 51, 107, 49, 192, 214, 31, 181, 199, 106, 157, 184, 84, 204, 176, 115, 121, 50, 138, 236, 205, 93, 222, 114, 67, 29, 24, 72, 243, 141, 128, 195, 78, 66, 140, 36, 103, 30, 227, 47, 16, 58, 69, 17, 209, 76, 132, 187, 45, 127, 197, 62, 94, 252, 153, 101, 155, 167, 219, 182, 3, 64, 52, 217, 215, 61, 168, 68, 175, 74, 185, 112, 104, 218, 165, 246, 4, 150, 208, 254, 142, 71, 230, 220, 105, 92, 145, 235, 249, 14, 41, 239, 156, 180, 226, 89, 203, 117};

constant float2 grads2d[16] = {{-0.195090322f, -0.98078528f}, {-0.555570233f, -0.831469612f}, {-0.831469612f, -0.555570233f}, {-0.98078528f, -0.195090322f}, {-0.98078528f, 0.195090322f}, {-0.831469612f, 0.555570233f}, {-0.555570233f, 0.831469612f}, {-0.195090322f, 0.98078528f}, {0.195090322f, 0.98078528f}, {0.555570233f, 0.831469612f}, {0.831469612f, 0.555570233f}, {0.98078528f, 0.195090322f}, {0.98078528f, -0.195090322f}, {0.831469612f, -0.555570233f}, {0.555570233f, -0.831469612f}, {0.195090322f, -0.98078528f}};

constant char4 grads3d[16] = {{1, 1, 0, 0}, {-1, 1, 0, 0}, {1, -1, 0, 0}, {-1, -1, 0, 0}, {1, 0, 1, 0}, {-1, 0, 1, 0}, {1, 0, -1, 0}, {-1, 0, -1, 0}, {0, 1, 1, 0}, {0, -1, 1, 0}, {0, 1, -1, 0}, {0, -1, -1, 0}, {1, 1, 0, 0}, {-1, 1, 0, 0}, {0, -1, 1, 0}, {0, -1, -1, 0}};
unsigned int ParallelRNG(unsigned int x) {
  unsigned int value = x;

  value = (value ^ 61) ^ (value >> 16);
  value *= 9;
  value ^= value << 4;
  value *= 0x27d4eb2d;
  value ^= value >> 15;

  return value;
}
unsigned int ParallelRNG2(unsigned int x, unsigned int y) {
  unsigned int value = ParallelRNG(x);

  value = ParallelRNG(y ^ value);

  return value;
}

unsigned int ParallelRNG3(unsigned int x, unsigned int y, unsigned int z) {
  unsigned int value = ParallelRNG(x);

  value = ParallelRNG(y ^ value);

  value = ParallelRNG(z ^ value);

  return value;
}

float weight_poly3(float weight) {
  return weight * weight * (3 - weight * 2);
}

float weight_poly5(float weight) {
  return weight * weight * weight * (weight * (weight * 6 - 15) + 10);
}
float hash_grad_dot2(unsigned int hash, float2 xy) {
  unsigned int indx = hash & 0x0f;

  float2 grad2 = grads2d[hook(4, indx)];

  return dot(xy, grad2);
}

float Noise_2d(float x, float y) {
  float X = floor(x);
  float Y = floor(y);

  float2 vxy;
  vxy.x = x - X;
  vxy.y = y - Y;

  float2 vXy = vxy;
  vXy.x -= 1.0f;
  float2 vxY = vxy;
  vxY.y -= 1.0f;
  float2 vXY = vXy;
  vXY.y -= 1.0f;

  int ux = (int)(X);
  int uy = (int)(Y);
  int uX = ux + 1;
  int uY = uy + 1;

  unsigned int px = default_perm[hook(5, ux & 255)];
  unsigned int pX = default_perm[hook(5, uX & 255)];

  unsigned int pxy = default_perm[hook(5, (px + uy) & 255)];
  unsigned int pXy = default_perm[hook(5, (pX + uy) & 255)];
  unsigned int pxY = default_perm[hook(5, (px + uY) & 255)];
  unsigned int pXY = default_perm[hook(5, (pX + uY) & 255)];

  float gxy = hash_grad_dot2(pxy, vxy);
  float gXy = hash_grad_dot2(pXy, vXy);
  float gxY = hash_grad_dot2(pxY, vxY);
  float gXY = hash_grad_dot2(pXY, vXY);

  float wx = weight_poly5(vxy.x);
  float wy = weight_poly5(vxy.y);

  return mix((mix((gxy), (gXy), (wx))), (mix((gxY), (gXY), (wx))), (wy));
}

float hash_grad_dot3(unsigned int hash, float3 xyz) {
  unsigned int indx = hash & 0x0f;

  float3 grad3 = convert_float3(grads3d[hook(6, indx)].xyz);

  return dot(xyz, grad3);
}

float Noise_3d(float x, float y, float z) {
  float X = floor(x);
  float Y = floor(y);
  float Z = floor(z);

  float3 vxyz;
  vxyz.x = x - X;
  vxyz.y = y - Y;
  vxyz.z = z - Z;

  float3 vXyz, vXYz, vXyZ, vxYz, vxYZ, vxyZ, vXYZ;
  vXyz = vxyz;
  vXyz.x -= 1.0f;
  vxYz = vxyz;
  vxYz.y -= 1.0f;
  vxyZ = vxyz;
  vxyZ.z -= 1.0f;

  vXYz = vXyz;
  vXYz.y -= 1.0f;
  vXyZ = vXyz;
  vXyZ.z -= 1.0f;

  vxYZ = vxYz;
  vxYZ.z -= 1.0f;

  vXYZ = vXYz;
  vXYZ.z -= 1.0f;

  int ux = (int)(X);
  int uy = (int)(Y);
  int uz = (int)(Z);
  unsigned int uX = ux + 1;
  unsigned int uY = uy + 1;
  unsigned int uZ = uz + 1;

  unsigned int px = default_perm[hook(5, ux & 255)];
  unsigned int pX = default_perm[hook(5, uX & 255)];

  unsigned int pxy = default_perm[hook(5, (px + uy) & 255)];
  unsigned int pXy = default_perm[hook(5, (pX + uy) & 255)];
  unsigned int pxY = default_perm[hook(5, (px + uY) & 255)];
  unsigned int pXY = default_perm[hook(5, (pX + uY) & 255)];

  unsigned int pxyz = default_perm[hook(5, (pxy + uz) & 255)];
  unsigned int pXyz = default_perm[hook(5, (pXy + uz) & 255)];
  unsigned int pxYz = default_perm[hook(5, (pxY + uz) & 255)];
  unsigned int pXYz = default_perm[hook(5, (pXY + uz) & 255)];
  unsigned int pxyZ = default_perm[hook(5, (pxy + uZ) & 255)];
  unsigned int pXyZ = default_perm[hook(5, (pXy + uZ) & 255)];
  unsigned int pxYZ = default_perm[hook(5, (pxY + uZ) & 255)];
  unsigned int pXYZ = default_perm[hook(5, (pXY + uZ) & 255)];

  float gxyz = hash_grad_dot3(pxyz, vxyz);
  float gXyz = hash_grad_dot3(pXyz, vXyz);
  float gxYz = hash_grad_dot3(pxYz, vxYz);
  float gXYz = hash_grad_dot3(pXYz, vXYz);
  float gxyZ = hash_grad_dot3(pxyZ, vxyZ);
  float gXyZ = hash_grad_dot3(pXyZ, vXyZ);
  float gxYZ = hash_grad_dot3(pxYZ, vxYZ);
  float gXYZ = hash_grad_dot3(pXYZ, vXYZ);

  float wx = weight_poly5(vxyz.x);
  float wy = weight_poly5(vxyz.y);
  float wz = weight_poly5(vxyz.z);

  float result = mix((mix((mix((gxyz), (gXyz), (wx))), (mix((gxYz), (gXYz), (wx))), (wy))), (mix((mix((gxyZ), (gXyZ), (wx))), (mix((gxYZ), (gXYZ), (wx))), (wy))), (wz));
  return result;
}

float cloud(float fx, float fy, float fz, float size) {
  float value = 0.0f;

  while (size >= 1.0f) {
    value += size * Noise_3d(fx, fy, fz);

    size *= 0.5f;
    fx *= 2.0f;
    fy *= 2.0f;
  }
  return value;
}

kernel void cloud3d(global float* output, float wx, float wy, float wz) {
  int i = get_global_id(0);
  int j = get_global_id(1);
  int k = get_global_id(2);

  int Nx = get_global_size(0);
  int Ny = get_global_size(0);
  int Nz = get_global_size(0);

  float fx = (float)i / Nx * wx;
  float fy = (float)j / Ny * wy;
  float fz = (float)k / Nz * wz;
  float value = cloud(fx, fy, fz, Nx);

  value *= (float)wx;

  output[hook(0, i + j * Nx + k * Nx * Ny)] = value;
}