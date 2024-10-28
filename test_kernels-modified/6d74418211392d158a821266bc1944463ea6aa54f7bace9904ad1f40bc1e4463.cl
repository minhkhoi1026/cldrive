//{"friendRate":3,"position":2,"s":4,"seed":1,"space":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
unsigned int randomi(unsigned int low, unsigned int high, global uint4* s) {
  const unsigned int gid = get_global_id(0);
  unsigned int t;
  uint4 seed = s[hook(4, gid)];
  t = (seed.x ^ (seed.x << 11));
  seed.x = seed.y;
  seed.y = seed.z;
  seed.z = seed.w;
  seed.w = (seed.w ^ (seed.w >> 19)) ^ (t ^ (t >> 8));
  s[hook(4, gid)] = seed;
  return low + (seed.w % (high - low));
}

int2 getTorus(int2 pos) {
  return (int2)((pos.x + (100)) % (100), (pos.y + (100)) % (100));
}

int getOneDimIdx(int2 pos) {
  int2 _pos = getTorus(pos);
  return _pos.x + (100) * _pos.y;
}

unsigned int moveOldPosToNewPos(int2 oldPos, int2 newPos, global int* space, int groupNum) {
  if ((-1) == atomic_cmpxchg(&space[hook(0, getOneDimIdx(newPos))], (-1), groupNum)) {
    atomic_xchg(&space[hook(0, getOneDimIdx(oldPos))], (-1));
    return 1;
  }
  return 0;
}

kernel void moveToEmptySpot(global int* space, global uint4* seed, global int2* position, const float friendRate) {
  const int agent_id = get_global_id(0);
  int2 myPos = position[hook(2, agent_id)];

  int myGroupNum = space[hook(0, getOneDimIdx(myPos))];

  int count = 0;
  int friendCount = 0;
  for (int dy = -1; dy <= 1; dy++) {
    for (int dx = -1; dx <= 1; dx++) {
      if (dx == 0 && dy == 0)
        continue;

      int2 searchPos = getTorus(myPos + (int2)(dx, dy));
      int searchPosStatus = space[hook(0, getOneDimIdx(searchPos))];

      if (searchPosStatus != (-1)) {
        count++;
        if (searchPosStatus == myGroupNum) {
          friendCount++;
        }
      }
    }
  }

  float myRate = 0;

  if (count != 0)
    myRate = (float)friendCount / count;

  if (myRate < friendRate) {
    int moveCount = 0;
    while (moveCount < 1000) {
      int x = (int)randomi(0, (100), seed);
      int y = (int)randomi(0, (100), seed);
      int2 newPos = getTorus(myPos + (int2)(x, y));
      if (moveOldPosToNewPos(myPos, newPos, space, myGroupNum)) {
        position[hook(2, agent_id)] = newPos;
        break;
      }
      moveCount++;
    }
  }
}