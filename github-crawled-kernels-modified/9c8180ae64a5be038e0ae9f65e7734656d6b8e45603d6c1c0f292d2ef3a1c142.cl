//{"corneredBuffer":2,"maxCornered":0,"normalBuffer":4,"otherCornerBuffer":3,"positionBuffer":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant float4 gravity = (float4)(0, 0, -10, 0);
kernel void calcNormals(int maxCornered, global float4* positionBuffer, global int* corneredBuffer, global int2* otherCornerBuffer, global float4* normalBuffer) {
  int point = get_global_id(0);

  float4 normal = (float4)(0);

  for (int i = 0; i < corneredBuffer[hook(2, point)]; ++i) {
    int other1 = otherCornerBuffer[hook(3, maxCornered * point + i)].x;
    int other2 = otherCornerBuffer[hook(3, maxCornered * point + i)].y;

    float4 a = positionBuffer[hook(1, point)];
    float4 b = positionBuffer[hook(1, other1)];
    float4 c = positionBuffer[hook(1, other2)];

    float4 cp = cross(b - a, c - a);
    normal += normalize(cp);
  }

  normalBuffer[hook(4, point)] = normalize(normal);
}