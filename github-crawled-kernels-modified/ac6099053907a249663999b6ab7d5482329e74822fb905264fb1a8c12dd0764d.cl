//{"depth":4,"height":3,"out":0,"velocity":1,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void project1(global float* out, global float* velocity, int width, int height, int depth) {
  const int xpos = get_global_id(0);
  const int ypos = get_global_id(1);
  const int zpos = get_global_id(2);
  const int wh = width * height;
  const int index = xpos + ypos * width + zpos * wh;
  const float hx = 1.0f / width;
  const float hy = 1.0f / height;
  const float hz = 1.0f / depth;

  float dr = velocity[hook(1, 3 * (index + 1))];
  float dl = velocity[hook(1, 3 * (index - 1))];
  float dd = velocity[hook(1, 3 * (index + width) + 1)];
  float du = velocity[hook(1, 3 * (index - width) + 1)];
  float dt = velocity[hook(1, 3 * (index + wh) + 2)];
  float db = velocity[hook(1, 3 * (index - wh) + 2)];

  float value = -0.5f * (hx * (dr - dl) + hy * (dd - du) + hz * (dt - db));

  out[hook(0, xpos + ypos * width + zpos * wh)] = value;
}