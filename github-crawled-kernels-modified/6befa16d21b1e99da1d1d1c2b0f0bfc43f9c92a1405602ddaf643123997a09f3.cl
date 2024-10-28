//{"fDest":1,"fScale":5,"fSource":0,"iRadius":4,"uiHeight":3,"uiWidth":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void BoxRows_32F(global const float* fSource, global float* fDest, unsigned int uiWidth, unsigned int uiHeight, int iRadius, float fScale) {
  size_t globalPosY = get_global_id(0);
  size_t globalPosD = get_global_id(2);
  size_t offset = ((globalPosD * uiHeight) + globalPosY) * uiWidth;

  float sum = 0;

  for (int x = -iRadius; x <= iRadius; x++) {
    sum += fSource[hook(0, offset + x)];
  }
  fDest[hook(1, offset)] = sum * fScale;

  for (unsigned int x = 1; x < uiWidth; x++) {
    sum += fSource[hook(0, offset + x + iRadius)];
    sum -= fSource[hook(0, offset + x - iRadius - 1)];
    fDest[hook(1, offset + x)] = sum * fScale;
  }
}