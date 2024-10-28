//{"count":4,"force":3,"mass":2,"objX":0,"objY":1,"sm":7,"sx":5,"sy":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float2 unit_vector(float2 p1, float2 p2) {
  float2 v = p2 - p1;

  const float dist = length(v);

  v.x /= dist;
  v.y /= dist;

  return v;
}

kernel void forces(global const float* objX, global const float* objY, global const float* mass, global float2* force, const int count) {
  const float G = 6.6732e-11;
  const int count_local = ((count + 2048 - 1) / 2048) * 2048;

  local float sx[2048];
  local float sy[2048];
  local float sm[2048];

  const float xi = objX[hook(0, get_global_id(0))];
  const float yi = objY[hook(1, get_global_id(0))];
  const float mi = mass[hook(2, get_global_id(0))];

  float fx = 0, fy = 0;

  for (int c = 0; c < count_local; c += 2048) {
    const int n = min(count - c, 2048);

    for (int k = get_local_id(0); k < n; k += get_local_size(0)) {
      sx[hook(5, k)] = objX[hook(0, c + k)];
      sy[hook(6, k)] = objY[hook(1, c + k)];
      sm[hook(7, k)] = mass[hook(2, c + k)];
    }

    barrier(0x01);

    for (int k = 0; k < n; ++k) {
      const float xk = sx[hook(5, k)];
      const float yk = sy[hook(6, k)];
      const float mk = sm[hook(7, k)];
      const float dx = xk - xi;
      const float dy = yk - yi;
      float len2 = dx * dx + dy * dy;
      const int notzero = (len2 != 0);
      len2 += (len2 == 0);
      const float Fg = (G * mi) * (mk / len2);
      const float len = sqrt(len2);
      fx += dx * Fg / len * notzero;
      fy += dy * Fg / len * notzero;
    }

    barrier(0x01);
  }

  if (get_global_id(0) < count) {
    force[hook(3, get_global_id(0))] = (float2)(fx, fy);
  }
}