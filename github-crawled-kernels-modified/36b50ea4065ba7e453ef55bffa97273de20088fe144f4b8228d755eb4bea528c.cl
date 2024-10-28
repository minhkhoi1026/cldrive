//{"damping":5,"maxSpeed":6,"numPoints":3,"pointAcceleration":1,"pointPosition":0,"pointVelocity":2,"t":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
union BufferType {
  float f;
  unsigned int u;
};

kernel void updatePosition(global float4* pointPosition, global float4* pointAcceleration, global float4* pointVelocity, const int numPoints, const float t, const float damping, const float maxSpeed) {
  int p = get_global_id(0);
  if (p >= numPoints)
    return;

  float4 velocity = (pointVelocity[hook(2, p)] + pointAcceleration[hook(1, p)] * t) * damping;
  float speed = length(velocity);
  if (speed > maxSpeed) {
    velocity *= maxSpeed / speed;
  }
  pointVelocity[hook(2, p)] = velocity;
  pointAcceleration[hook(1, p)] = (float)0;
  pointPosition[hook(0, p)] += pointVelocity[hook(2, p)] * t;
}