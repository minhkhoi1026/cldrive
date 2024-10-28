//{"dst":1,"ldata":2,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_getelementptr_bitcast(global float* src, global float* dst) {
  int i = get_global_id(0);

  local float ldata[256];
  ldata[hook(2, get_local_id(0))] = src[hook(0, i)];

  local uchar* pldata = (local uchar*)&ldata[hook(2, 0)];
  uchar data;
  for (int k = 0; k < 3; k++) {
    data = *pldata;
    pldata++;
  }

  dst[hook(1, i)] = data;
}