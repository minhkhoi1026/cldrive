//{"depth":4,"height":3,"in":0,"velocity":1,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void project2(global float* in, global float* velocity, int width, int height, int depth) {
  const int xpos = get_global_id(0);
  const int ypos = get_global_id(1);
  const int zpos = get_global_id(2);

  const int wh = width * height;
  const int index = xpos + ypos * width + zpos * wh;

  float dr = in[hook(0, index + 1)];
  float dl = in[hook(0, index - 1)];
  float dd = in[hook(0, index + width)];
  float du = in[hook(0, index - width)];
  float dt = in[hook(0, index + wh)];
  float db = in[hook(0, index - wh)];

  velocity[hook(1, 3 * index + 0)] -= 0.5f * (dr - dl) * width;
  velocity[hook(1, 3 * index + 1)] -= 0.5f * (dd - du) * height;
  velocity[hook(1, 3 * index + 2)] -= 0.5f * (dt - db) * depth;
}