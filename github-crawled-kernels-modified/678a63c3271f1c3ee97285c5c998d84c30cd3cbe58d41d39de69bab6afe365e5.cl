//{"atten_grad_x":0,"atten_grad_y":1,"div_grad":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float GL_to_CL(unsigned int val);
float3 RGBtoXYZ(float3 rgb);
const sampler_t sampler = 0 | 0 | 0x10;
kernel void divG(global float* atten_grad_x, global float* atten_grad_y, global float* div_grad) {
  div_grad[hook(2, 0)] = 0;
  int2 pos;
  for (pos.x = get_global_id(0) + 1; pos.x < 16; pos.x += get_global_size(0)) {
    div_grad[hook(2, pos.x)] = atten_grad_x[hook(0, pos.x)] - atten_grad_x[hook(0, pos.x - 1)];
  }
  for (pos.y = get_global_id(1) + 1; pos.y < 128; pos.y += get_global_size(1)) {
    div_grad[hook(2, pos.y * 16)] = atten_grad_y[hook(1, pos.y * 16)] - atten_grad_y[hook(1, (pos.y - 1) * 16)];
    for (pos.x = get_global_id(0) + 1; pos.x < 16; pos.x += get_global_size(0)) {
      div_grad[hook(2, pos.x + pos.y * 16)] = (atten_grad_x[hook(0, pos.x + pos.y * 16)] - atten_grad_x[hook(0, (pos.x - 1) + pos.y * 16)]) + (atten_grad_y[hook(1, pos.x + pos.y * 16)] - atten_grad_y[hook(1, pos.x + (pos.y - 1) * 16)]);
    }
  }
}