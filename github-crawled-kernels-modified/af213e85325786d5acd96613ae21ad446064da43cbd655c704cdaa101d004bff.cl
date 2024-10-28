//{"atten_func":3,"atten_grad_x":0,"atten_grad_y":1,"lum":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float GL_to_CL(unsigned int val);
float3 RGBtoXYZ(float3 rgb);
const sampler_t sampler = 0 | 0 | 0x10;
kernel void grad_atten(global float* atten_grad_x, global float* atten_grad_y, global float* lum, global float* atten_func) {
  int2 pos;
  float2 grad;
  for (pos.y = get_global_id(1); pos.y < 128; pos.y += get_global_size(1)) {
    for (pos.x = get_global_id(0); pos.x < 16; pos.x += get_global_size(0)) {
      grad.x = (pos.x < 16 - 1) ? (lum[hook(2, pos.x + 1 + pos.y * 16)] - lum[hook(2, pos.x + pos.y * 16)]) : 0;
      grad.y = (pos.y < 128 - 1) ? (lum[hook(2, pos.x + (pos.y + 1) * 16)] - lum[hook(2, pos.x + pos.y * 16)]) : 0;
      atten_grad_x[hook(0, pos.x + pos.y * 16)] = grad.x * atten_func[hook(3, pos.x + pos.y * 16)];
      atten_grad_y[hook(1, pos.x + pos.y * 16)] = grad.y * atten_func[hook(3, pos.x + pos.y * 16)];
    }
  }
}