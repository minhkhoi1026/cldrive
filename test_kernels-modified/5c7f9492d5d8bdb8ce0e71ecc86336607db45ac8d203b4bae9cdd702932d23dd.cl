//{"dev_img":1,"dev_matrix":2,"dev_vol":0,"ic":8,"nrm":7,"proj_dim":6,"sad":9,"scale":10,"vol_dim":3,"vol_offset":4,"vol_spacing":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void fdk_kernel_nn(global float* dev_vol, global float* dev_img, constant float* dev_matrix, int4 vol_dim, constant float* vol_offset, constant float* vol_spacing, int2 proj_dim, constant float* nrm, constant float* ic, const float sad, const float scale) {
  unsigned int id = get_global_id(0);
  unsigned int id_l = get_local_id(0);

  int k = id / vol_dim.x / vol_dim.y;
  int j = (id - (k * vol_dim.x * vol_dim.y)) / vol_dim.x;
  int i = id - k * vol_dim.x * vol_dim.y - j * vol_dim.x;

  if (k >= vol_dim.z) {
    return;
  }

  float dev_vol_value = dev_vol[hook(0, id)];

  float4 vp;
  vp.x = vol_offset[hook(4, 0)] + (i * vol_spacing[hook(5, 0)]);
  vp.y = vol_offset[hook(4, 1)] + (j * vol_spacing[hook(5, 1)]);
  vp.z = vol_offset[hook(4, 2)] + (k * vol_spacing[hook(5, 2)]);

  float4 ip;
  ip.x = (dev_matrix[hook(2, 0)] * vp.x) + (dev_matrix[hook(2, 1)] * vp.y) + (dev_matrix[hook(2, 2)] * vp.z) + dev_matrix[hook(2, 3)];
  ip.y = (dev_matrix[hook(2, 4)] * vp.x) + (dev_matrix[hook(2, 5)] * vp.y) + (dev_matrix[hook(2, 6)] * vp.z) + dev_matrix[hook(2, 7)];
  ip.z = (dev_matrix[hook(2, 8)] * vp.x) + (dev_matrix[hook(2, 9)] * vp.y) + (dev_matrix[hook(2, 10)] * vp.z) + dev_matrix[hook(2, 11)];

  ip.x = ic[hook(8, 0)] + ip.x / ip.z;
  ip.y = ic[hook(8, 1)] + ip.y / ip.z;

  int2 pos;
  pos.y = convert_int_rtn(ip.x);
  pos.x = convert_int_rtn(ip.y);

  if (pos.x < 0 || pos.x >= proj_dim.x || pos.y < 0 || pos.y >= proj_dim.y) {
    return;
  }

  float pix_val = dev_img[hook(1, pos.y * proj_dim.x + pos.x)];

  float s = (nrm[hook(7, 0)] * vp.x) + (nrm[hook(7, 1)] * vp.y) + (nrm[hook(7, 2)] * vp.z);

  s = sad - s;
  s = (sad * sad) / (s * s);

  dev_vol[hook(0, id)] = dev_vol_value + (scale * s * pix_val);
}