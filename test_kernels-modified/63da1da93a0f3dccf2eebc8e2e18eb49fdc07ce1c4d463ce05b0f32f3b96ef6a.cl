//{"corneredBuffer":3,"forceBuffer":5,"maxCornered":1,"otherCornerBuffer":4,"positionBuffer":2,"pressureDiff":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant float4 gravity = (float4)(0, 0, -10, 0);
kernel void applyPressure(float pressureDiff, int maxCornered, global float4* positionBuffer, global int* corneredBuffer, global int2* otherCornerBuffer, global float4* forceBuffer) {
  int point = get_global_id(0);

  for (int i = 0; i < corneredBuffer[hook(3, point)]; ++i) {
    int other1 = otherCornerBuffer[hook(4, maxCornered * point + i)].x;
    int other2 = otherCornerBuffer[hook(4, maxCornered * point + i)].y;

    float4 a = positionBuffer[hook(2, point)];
    float4 b = positionBuffer[hook(2, other1)];
    float4 c = positionBuffer[hook(2, other2)];

    float4 cp = cross(b - a, c - a);
    forceBuffer[hook(5, point)] += cp * pressureDiff * 20000;
  }
}