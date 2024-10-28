//{"A":0,"B":1,"K":23,"P":22,"areas":3,"b":9,"dp":6,"dx":10,"dy":11,"l":8,"n":17,"nB":16,"nFS":15,"nSeax":18,"nSeay":19,"nW":20,"normals":4,"nx":13,"ny":14,"p":5,"positions":2,"t":12,"w":21,"waves":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float G_val(float4 r) {
  return 1.f / (4.f * 3.14159265358979323846f * length(r));
}

float H_val(float4 r, float4 n) {
  return -dot(r, n) / (4.f * 3.14159265358979323846f * pow(dot(r, r), 1.5f));
}
float waves_z(global float4* w, float4 p, float t, unsigned int nW) {
  unsigned int i;
  float z = 0.f;
  for (i = 0; i < nW; i++) {
    float omega = 2.f * 3.14159265358979323846f / w[hook(21, i)].y;
    float k = omega * omega / 9.81f;
    float beta = w[hook(21, i)].w * 3.14159265358979323846f / 180.f;
    float l = p.x * cos(beta) + p.y * sin(beta);
    z += w[hook(21, i)].x * sin(k * l - omega * t + w[hook(21, i)].z);
  }
  return z;
}
float waves_phi(global float4* w, float4 p, float t, unsigned int nW) {
  unsigned int i;
  float z = 0.f;
  for (i = 0; i < nW; i++) {
    float omega = 2.f * 3.14159265358979323846f / w[hook(21, i)].y;
    float k = omega * omega / 9.81f;
    float beta = w[hook(21, i)].w * 3.14159265358979323846f / 180.f;
    float l = p.x * cos(beta) + p.y * sin(beta);
    z -= w[hook(21, i)].x * omega / k * cos(k * l - omega * t + w[hook(21, i)].z) * exp(k * p.z);
  }
  return z;
}
float waves_gradphi(global float4* w, float4 p, float t, unsigned int nW) {
  unsigned int i;
  float z = 0.f;
  for (i = 0; i < nW; i++) {
    float omega = 2.f * 3.14159265358979323846f / w[hook(21, i)].y;
    float k = omega * omega / 9.81f;
    float beta = w[hook(21, i)].w * 3.14159265358979323846f / 180.f;
    float l = p.x * cos(beta) + p.y * sin(beta);
    z -= w[hook(21, i)].x * omega * cos(k * l - omega * t + w[hook(21, i)].z) * exp(k * p.z);
  }
  return z;
}
float2 GH(global float4* positions, global float4* w, global float4* normals, unsigned int I, unsigned int J, float L, float B, float dx, float dy, float t, unsigned int nx, unsigned int ny, unsigned int nW) {
 private
  float4 P[9];
 private
  float K[9];
  unsigned int i, j;
  float4 p = positions[hook(2, I * ny + J)];
  float4 n = normals[hook(4, I * ny + J)];
  float Dx = dx / 16;
  float Dy = dy / 16;
  for (i = 0; i < 3; i++) {
    for (j = 0; j < 3; j++) {
      P[hook(22, i * 3 + j)].x = p.x + (i - 1) * dx;
      P[hook(22, i * 3 + j)].y = p.y + (j - 1) * dy;
      if ((P[hook(22, i * 3 + j)].x > -0.5 * L) && (P[hook(22, i * 3 + j)].x < 0.5 * L) && (P[hook(22, i * 3 + j)].y > -0.5 * B) && (P[hook(22, i * 3 + j)].y < 0.5 * B))
        P[hook(22, i * 3 + j)].z = positions[hook(2, (I - 1 + i) * ny + (J - 1 + j))].z;
      else
        P[hook(22, i * 3 + j)].z = waves_z(w, P[hook(22, i * 3 + j)], t, nW);
      P[hook(22, i * 3 + j)].w = 0.f;
    }
  }

  K[hook(23, 0)] = P[hook(22, 0)].z;
  K[hook(23, 1)] = 4 * P[hook(22, 3)].z - P[hook(22, 6)].z - 3 * P[hook(22, 0)].z;
  K[hook(23, 2)] = 4 * P[hook(22, 1)].z - P[hook(22, 2)].z - 3 * P[hook(22, 0)].z;
  K[hook(23, 3)] = P[hook(22, 8)].z - 4 * P[hook(22, 7)].z + 3 * P[hook(22, 6)].z + 3 * P[hook(22, 2)].z - 12 * P[hook(22, 1)].z + 9 * P[hook(22, 0)].z + -4 * P[hook(22, 5)].z + 16 * P[hook(22, 4)].z - 12 * P[hook(22, 3)].z;
  K[hook(23, 4)] = 2 * P[hook(22, 6)].z + 2 * P[hook(22, 0)].z - 4 * P[hook(22, 3)].z;
  K[hook(23, 5)] = 2 * P[hook(22, 2)].z + 2 * P[hook(22, 0)].z - 4 * P[hook(22, 1)].z;
  K[hook(23, 6)] = -2 * P[hook(22, 8)].z + 8 * P[hook(22, 7)].z - 6 * P[hook(22, 6)].z + -2 * P[hook(22, 2)].z + 8 * P[hook(22, 1)].z - 6 * P[hook(22, 0)].z + 4 * P[hook(22, 5)].z - 16 * P[hook(22, 4)].z + 12 * P[hook(22, 3)].z;
  K[hook(23, 7)] = -2 * P[hook(22, 8)].z + 4 * P[hook(22, 7)].z - 2 * P[hook(22, 6)].z + -6 * P[hook(22, 2)].z + 12 * P[hook(22, 1)].z - 6 * P[hook(22, 0)].z + 8 * P[hook(22, 5)].z - 16 * P[hook(22, 4)].z + 8 * P[hook(22, 3)].z;
  K[hook(23, 8)] = 4 * P[hook(22, 8)].z - 8 * P[hook(22, 7)].z + 4 * P[hook(22, 6)].z + 4 * P[hook(22, 2)].z - 8 * P[hook(22, 1)].z + 4 * P[hook(22, 0)].z + -8 * P[hook(22, 5)].z + 16 * P[hook(22, 4)].z - 8 * P[hook(22, 3)].z;

  float2 gh;
  gh.x = 0.0f;
  gh.y = -0.5f;
  for (i = 0; i < 16; i++) {
    for (j = 0; j < 16; j++) {
      float4 p_a;
      float u, v;
      p_a.x = positions[hook(2, I * ny + J)].x - 0.5f * dx + (i + 0.5f) * Dx;
      p_a.y = positions[hook(2, I * ny + J)].y - 0.5f * dy + (j + 0.5f) * Dy;
      u = (p_a.x - P[hook(22, 0)].x) / (P[hook(22, 6)].x - P[hook(22, 0)].x);
      v = (p_a.y - P[hook(22, 0)].y) / (P[hook(22, 2)].y - P[hook(22, 0)].y);
      p_a.z = K[hook(23, 0)] + K[hook(23, 1)] * u + K[hook(23, 2)] * v + K[hook(23, 3)] * u * v + K[hook(23, 4)] * u * u + K[hook(23, 5)] * v * v + K[hook(23, 6)] * u * u * v + K[hook(23, 7)] * u * v * v + K[hook(23, 8)] * u * u * v * v;
      p_a.w = 1.f;
      gh.x += G_val(p_a - p) * Dx * Dy;
    }
  }
  return gh;
}
kernel void matrixGen(global float* A, global float* B, global float4* positions, global float* areas, global float4* normals, global float* p, global float* dp, global float4* waves, float l, float b, float dx, float dy, float t, unsigned int nx, unsigned int ny, unsigned int nFS, unsigned int nB, unsigned int n, int nSeax, int nSeay, unsigned int nW) {
  unsigned int i = get_global_id(0);
  unsigned int j;
  int I, J;
  if (i >= n)
    return;

  float4 p_a = positions[hook(2, i)];

  B[hook(1, i)] = 0.f;
  for (j = 0; j < nFS; j++) {
    float2 gh;
    float4 p_b = positions[hook(2, j)];
    float4 n_b = normals[hook(4, j)];
    if (i == j) {
      gh = GH(positions, waves, normals, i / ny, i % ny, l, b, dx, dy, t, nx, ny, nW);
    } else {
      p_b = positions[hook(2, j)];
      gh.x = G_val(p_b - p_a) * dx * dy;
      gh.y = H_val(p_b - p_a, n_b) * dx * dy;
    }

    A[hook(0, j + i * n)] = -gh.x;
    B[hook(1, i)] += gh.y * p[hook(5, j)];

    for (I = -nSeax; I <= nSeax; I++) {
      for (J = -nSeay; J <= nSeay; J++) {
        if ((!I) && (!J))
          continue;
        float4 p_c = p_b;
        p_c.x += I * l;
        p_c.y += J * b;
        p_c.z = waves_z(waves, p_c, t, nW);
        gh.x = G_val(p_c - p_a) * dx * dy;
        gh.y = H_val(p_c - p_a, n_b) * dx * dy;

        B[hook(1, i)] += gh.y * waves_phi(waves, p_c, t, nW) - gh.x * waves_gradphi(waves, p_c, t, nW);
      }
    }
  }
}