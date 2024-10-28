//{"g_in1":0,"g_in2":1,"g_out":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void k_erro(global float* g_in1, constant float* g_in2, global float* g_out) {
  ulong index = get_global_id(0);
  float out = g_out[hook(2, index)];
  float in1 = g_in1[hook(0, index)];
  float in2 = g_in2[hook(1, index)];
  if (in1 < 0.001f && in1 > -0.001f)
    out = 0.0f;
  else if (in2 < 0.001f && in2 > -0.001f)
    out = 0.0f;
  else {
    out = (in1 - in2) / in1;
    if (out < 0.0f)
      out = -out;
  }
  g_out[hook(2, index)] = out;
}