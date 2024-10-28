//{"float2":0,"float4":1,"out":3,"vec16":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_vector_param(float2 float2, float4 float4, float16 vec16, global float16* out) {
  float4.x += float2.x;
  float4.y += float2.y;

  vec16.x *= float4.x;
  vec16.y *= float4.y;
  vec16.z *= float4.z;
  vec16.w *= float4.w;

  *out = vec16;
}