//{"neighbors":3,"offsets":4,"readImage":0,"stop":2,"writeImage":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 4 | 0x10;
void checkNeighborhood(const int2 position, read_only image2d_t readImage, write_only image2d_t writeImage, global char* stop, uchar add) {
  const int2 offsets[9] = {{0, 0}, {0, 1}, {1, 1}, {1, 0}, {1, -1}, {0, -1}, {-1, -1}, {-1, 0}, {-1, 1}};

  uchar neighbors[9];
  neighbors[hook(3, 0)] = read_imageui(readImage, sampler, position).x;
  if (neighbors[hook(3, 0)] == 1) {
    uchar sum = 0;
    uchar transitions = 0;
    bool previousWasZero = false;
    for (uchar i = 1; i < 9; i++) {
      neighbors[hook(3, i)] = read_imageui(readImage, sampler, position + offsets[hook(4, i)]).x;
      sum += neighbors[hook(3, i)];
      if (previousWasZero && neighbors[hook(3, i)] == 1) {
        transitions++;
      }
      if (neighbors[hook(3, i)] == 0) {
        previousWasZero = true;
      } else {
        previousWasZero = false;
      }
    }

    if (previousWasZero && neighbors[hook(3, 1)] == 1) {
      transitions++;
    }

    if (sum >= 2 && sum <= 6 && transitions == 1 && neighbors[hook(3, 1)] * neighbors[hook(3, 3)] * neighbors[hook(3, 5 + add)] == 0 && neighbors[hook(3, 3 - add)] * neighbors[hook(3, 5)] * neighbors[hook(3, 7)] == 0) {
      write_imageui(writeImage, position, 0);
      stop[hook(2, 0)] = 0;
    } else {
      write_imageui(writeImage, position, 1);
    }
  } else {
    write_imageui(writeImage, position, 0);
  }
}

kernel void thinningStep1(read_only image2d_t readImage, write_only image2d_t writeImage, global char* stop) {
  const int2 position = {get_global_id(0), get_global_id(1)};
  checkNeighborhood(position, readImage, writeImage, stop, 0);
}