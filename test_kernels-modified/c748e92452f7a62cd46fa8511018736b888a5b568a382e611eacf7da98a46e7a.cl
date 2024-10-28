//{"array_best_pos":7,"dst":5,"position":0,"s":6,"seed":4,"space":3,"space_sugar":2,"vision":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void transHSVtoRGB(float* dst, const float h, const float s, const float v) {
  if (0.f == s) {
    dst[hook(5, 0)] = dst[hook(5, 1)] = dst[hook(5, 2)] = v;
    return;
  }

  int Hi = (int)floor(h / 60.f) % 6;
  float f = h / 60.f - (float)Hi;
  float p = v * (1.f - s);
  float q = v * (1.f - s * f);
  float t = v * (1.f - (1.f - f) * s);

  if (Hi == 0) {
    dst[hook(5, 0)] = v, dst[hook(5, 1)] = t, dst[hook(5, 2)] = p;
  } else if (Hi == 1) {
    dst[hook(5, 0)] = q, dst[hook(5, 1)] = v, dst[hook(5, 2)] = p;
  } else if (Hi == 2) {
    dst[hook(5, 0)] = p, dst[hook(5, 1)] = v, dst[hook(5, 2)] = t;
  } else if (Hi == 3) {
    dst[hook(5, 0)] = p, dst[hook(5, 1)] = q, dst[hook(5, 2)] = v;
  } else if (Hi == 4) {
    dst[hook(5, 0)] = t, dst[hook(5, 1)] = p, dst[hook(5, 2)] = v;
  } else {
    dst[hook(5, 0)] = v, dst[hook(5, 1)] = p, dst[hook(5, 2)] = q;
  }
}

unsigned int randomi(unsigned int low, unsigned int high, global uint4* s) {
  const unsigned int gid = get_global_id(0);
  unsigned int t;
  uint4 seed = s[hook(6, gid)];
  t = (seed.x ^ (seed.x << 11));
  seed.x = seed.y;
  seed.y = seed.z;
  seed.z = seed.w;
  seed.w = (seed.w ^ (seed.w >> 19)) ^ (t ^ (t >> 8));
  s[hook(6, gid)] = seed;
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
  if ((-1) == atomic_cmpxchg(&space[hook(3, getOneDimIdx(newPos))], (-1), groupNum)) {
    atomic_xchg(&space[hook(3, getOneDimIdx(oldPos))], (-1));
    return 1;
  }
  return 0;
}

kernel void moveToBestSugarSpot(global int2* position, global int* vision, global int* space_sugar, global int* space, global uint4* seed) {
  const int gid = get_global_id(0);
  const int2 pos = position[hook(0, gid)];
  const int v = vision[hook(1, gid)];

  int best_sugar = -1;
  unsigned int best_distance = 100;

  int best_pos_count = 0;
  int2 array_best_pos[4];

  for (int y = -v; y <= v; y++) {
    int2 searchPos = pos + (int2)(0, y);
    int _space_sugar = space_sugar[hook(2, getOneDimIdx(searchPos))];

    if (_space_sugar > best_sugar) {
      best_sugar = _space_sugar;
      best_distance = abs_diff(pos.y, searchPos.y);
      array_best_pos[hook(7, 0)] = searchPos;
      best_pos_count = 1;
    } else if (_space_sugar == best_sugar) {
      unsigned int d = abs_diff(pos.y, searchPos.y);

      if (d < best_distance) {
        best_distance = d;
        array_best_pos[hook(7, 0)] = searchPos;
        best_pos_count = 1;
      } else if (d == best_distance) {
        array_best_pos[hook(7, best_pos_count++)] = searchPos;
      }
    }
  }

  for (int x = -v; x <= v; x++) {
    int2 searchPos = pos + (int2)(x, 0);
    int _space_sugar = space_sugar[hook(2, getOneDimIdx(searchPos))];

    if (_space_sugar > best_sugar) {
      best_sugar = _space_sugar;
      best_distance = abs_diff(pos.x, searchPos.x);
      array_best_pos[hook(7, 0)] = searchPos;
      best_pos_count = 1;
    } else if (_space_sugar == best_sugar) {
      unsigned int d = abs_diff(pos.x, searchPos.x);

      if (d < best_distance) {
        best_distance = d;
        array_best_pos[hook(7, 0)] = searchPos;
        best_pos_count = 1;
      } else if (d == best_distance) {
        array_best_pos[hook(7, best_pos_count++)] = searchPos;
      }
    }
  }

  int2 goalPos;

  if (best_pos_count == 1) {
    goalPos = array_best_pos[hook(7, 0)];
  } else {
    int r = randomi(0, best_pos_count, seed);
    goalPos = array_best_pos[hook(7, r)];
  }

  if (moveOldPosToNewPos(pos, goalPos, space, 0)) {
    position[hook(0, gid)] = goalPos;
  }
}