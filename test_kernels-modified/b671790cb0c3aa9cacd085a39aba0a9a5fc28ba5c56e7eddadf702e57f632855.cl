//{"a_dt":3,"a_time":2,"num_particles":0,"position":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float d_u(float x, float y, float t) {
  return (-2.0f * native_cos(3.141592653589793 * (t) / 8.0f) * native_sin(3.141592653589793 * (x)) * native_sin(3.141592653589793 * (x)) * native_cos(3.141592653589793 * (y)) * native_sin(3.141592653589793 * (y)));
}

float d_v(float x, float y, float t) {
  return (2.0f * native_cos(3.141592653589793 * (t) / 8.0f) * native_cos(3.141592653589793 * (x)) * native_sin(3.141592653589793 * (x)) * native_sin(3.141592653589793 * (y)) * native_sin(3.141592653589793 * (y)));
}

kernel void d_rungekutta(int num_particles, global float3* position, float a_time, float a_dt) {
  int index;
  float prex, prey, p1, q1, p2, q2, p3, q3, p4, q4;
  float x, y, t;
  index = get_global_id(0);
  if (index < num_particles) {
    prex = position[hook(1, index)].x;
    prey = position[hook(1, index)].y;

    p1 = d_u(prex, prey, a_time);
    q1 = d_v(prex, prey, a_time);

    x = prex + 0.5f * p1 * a_dt;
    y = prey + 0.5f * q1 * a_dt;
    t = a_time + 0.5f * a_dt;
    p2 = d_u(x, y, t);
    q2 = d_v(x, y, t);

    x = prex + 0.5f * p2 * a_dt;
    y = prey + 0.5f * q2 * a_dt;
    t = a_time + 0.5f * a_dt;
    p3 = d_u(x, y, t);
    q3 = d_v(x, y, t);

    x = prex + p3 * a_dt;
    y = prey + q3 * a_dt;
    t = a_time + a_dt;
    p4 = d_u(x, y, t);
    q4 = d_v(x, y, t);

    position[hook(1, index)].x = prex + (p1 + 2.0f * p2 + 2.0f * p3 + p4) / 6.0f * a_dt;
    position[hook(1, index)].y = prey + (q1 + 2.0f * q2 + 2.0f * q3 + q4) / 6.0f * a_dt;
  }
}