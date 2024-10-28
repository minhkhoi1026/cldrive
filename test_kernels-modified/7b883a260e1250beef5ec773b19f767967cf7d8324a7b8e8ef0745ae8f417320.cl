//{"collisionBuffer":1,"minMaxBuffer":0,"numberOfBoxes":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void getCollisions(global float4* minMaxBuffer, global int* collisionBuffer, const ulong numberOfBoxes) {
  unsigned int index = get_global_id(0);

  if (index >= numberOfBoxes)
    return;

  float3 currentMin = minMaxBuffer[hook(0, (index * 2U))].xyz;
  float3 currentMax = minMaxBuffer[hook(0, (index * 2U) + 1U)].xyz;
  int result = -1;

  for (int j = 0; j < numberOfBoxes; j++) {
    if (index == j) {
      continue;
    }

    float3 otherMin = minMaxBuffer[hook(0, j * 2)].xyz;
    float3 otherMax = minMaxBuffer[hook(0, (j * 2) + 1)].xyz;

    if (((otherMin.x < currentMax.x && otherMin.x > currentMin.x) || (otherMax.x < currentMax.x && otherMax.x > currentMin.x) || (otherMax.x > currentMax.x && otherMin.x < currentMin.x) || (otherMax.x < currentMax.x && otherMin.x > currentMin.x)) && ((otherMin.z < currentMax.z && otherMin.z > currentMin.z) || (otherMax.z < currentMax.z && otherMax.z > currentMin.z) || (otherMax.z > currentMax.z && otherMin.z < currentMin.z) || (otherMax.z < currentMax.z && otherMin.z > currentMin.z)) && ((otherMin.y < currentMax.y && otherMin.y > currentMin.y) || (otherMax.y < currentMax.y && otherMax.y > currentMin.y) || (otherMax.y > currentMax.y && otherMin.y < currentMin.y) || (otherMax.y < currentMax.y && otherMin.y > currentMin.y))) {
      result = j;
      break;
    }
  }

  collisionBuffer[hook(1, index)] = result;
}