//{"C":4,"E":5,"N":1,"NE":2,"NW":0,"S":7,"SE":8,"SW":6,"W":3,"height":11,"vel":9,"width":10}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void getVelocity(global float* NW, global float* N, global float* NE, global float* W, global float* C, global float* E, global float* SW, global float* S, global float* SE, global float* vel, int width, int height) {
  const int globalx = get_global_id(0);
  const int globaly = get_global_id(1);

  const int index = globaly * width + globalx;

  if (globalx < 0 || globalx >= width || globaly < 0 || globaly >= height)
    return;

  vel[hook(9, index * 2)] = (NE[hook(2, index)] - NW[hook(0, index)] + E[hook(5, index)] - W[hook(3, index)] + SE[hook(8, index)] - SW[hook(6, index)]);

  vel[hook(9, index * 2 + 1)] = (SW[hook(6, index)] - NW[hook(0, index)] + S[hook(7, index)] - N[hook(1, index)] + SE[hook(8, index)] - NE[hook(2, index)]);
}