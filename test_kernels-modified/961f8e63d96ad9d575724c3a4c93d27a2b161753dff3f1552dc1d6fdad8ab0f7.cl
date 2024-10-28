//{"episodeCandidates":3,"episodePairs":5,"episodeSupport":4,"level":1,"numCandidates":6,"numPairs":2,"sizes":8,"support":0,"timestamps":9,"values":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
char* cuda_strncpy(char* s1, const char* s2, size_t n) {
  char c;
  char* s = s1;

  --s1;

  if (n >= 4) {
    size_t n4 = n >> 2;
    int skip = 0;
    for (;;) {
      c = *s2++;
      *++s1 = c;
      if (c == '\0')
        break;
      c = *s2++;
      *++s1 = c;
      if (c == '\0')
        break;
      c = *s2++;
      *++s1 = c;
      if (c == '\0')
        break;
      c = *s2++;
      *++s1 = c;
      if (c == '\0')
        break;
      if (--n4 == 0)
        skip = 1;
      break;
    }
    if (!skip) {
      n = n - (s1 - s) - 1;
      if (n == 0)
        return s;
      do
        *++s1 = '\0';
      while (--n > 0);
      return s;
    }
  }

  n &= 3;
  if (n == 0)
    return s;

  do {
    c = *s2++;
    *++s1 = c;
    if (--n == 0)
      return s;
  } while (c != '\0');

  do
    *++s1 = '\0';
  while (--n > 0);

  return s;
}
int cuda_strncmp(global const char* s1, global const char* s2, size_t n) {
  unsigned char c1 = '\0';
  unsigned char c2 = '\0';

  if (n >= 4) {
    size_t n4 = n >> 2;
    do {
      c1 = (unsigned char)*s1++;
      c2 = (unsigned char)*s2++;
      if (c1 == '\0' || c1 != c2)
        return c1 - c2;
      c1 = (unsigned char)*s1++;
      c2 = (unsigned char)*s2++;
      if (c1 == '\0' || c1 != c2)
        return c1 - c2;
      c1 = (unsigned char)*s1++;
      c2 = (unsigned char)*s2++;
      if (c1 == '\0' || c1 != c2)
        return c1 - c2;
      c1 = (unsigned char)*s1++;
      c2 = (unsigned char)*s2++;
      if (c1 == '\0' || c1 != c2)
        return c1 - c2;
    } while (--n4 > 0);
    n &= 3;
  }

  while (n > 0) {
    c1 = (unsigned char)*s1++;
    c2 = (unsigned char)*s2++;
    if (c1 == '\0' || c1 != c2)
      return c1 - c2;
    n--;
  }

  return c1 - c2;
}
typedef unsigned char UBYTE;

enum { ABSOLUTE, RATIO, STATIC, DYNAMIC, MAP_AND_MERGE, NAIVE, OPTIMAL, ONE_CHAR, TWO_CHAR };
int ffs(int x) {
  int count;
  int var = 1;
  for (count = 1; count <= 32; count++) {
    if (x & var)
      return count;
    var = var << 1;
  }
  return 0;
}

void addToList(local float* values, unsigned int* sizes, unsigned int listIdx, float newValue) {
  values[hook(7, listIdx * 11 + sizes[lhook(8, listIdx))] = newValue;
  sizes[hook(8, listIdx)]++;
}

float getFromList(local float* values, unsigned int listIdx, unsigned int valueIdx) {
  return values[hook(7, listIdx * 11 + valueIdx)];
}

void clearLists(unsigned int* sizes, const int level) {
  for (unsigned int idx = 0; idx < level; idx++)
    sizes[hook(8, idx)] = 0;
}

void resetToZero(local float* timestamps, int level) {
  for (int idx = 0; idx < level; idx++)
    timestamps[hook(9, idx)] = -1.0f;
}

void triangleToArray(int triangle, int* base, int* compare, int numCandidates) {
  *base = 0;
  int Temp = triangle + 1;
  while (Temp > 0) {
    Temp = Temp - (numCandidates - (*base) - 1);
    (*base)++;
  }

  Temp += numCandidates - (*base) - 1;
  *compare = Temp + (*base);
  (*base)--;
}

bool compareCandidates(global UBYTE* episodeCandidates, int level, int base, int compare) {
  int idx;
  for (idx = 0; idx < level - 2; idx++) {
    if (episodeCandidates[hook(3, base * (level - 1) + idx)] != episodeCandidates[hook(3, compare * (level - 1) + idx)]) {
      return false;
    }
  }

  return true;
}

kernel void analyzeSupport(float support, int level, int numPairs, global UBYTE* episodeCandidates, global float* episodeSupport, global bool* episodePairs, int numCandidates) {
  int triangleIndex = get_group_id(0) * get_local_size(0) + get_local_id(0);

  if (triangleIndex >= numPairs)
    return;

  int base, compare;
  triangleToArray(triangleIndex, &base, &compare, numCandidates);

  if (episodeSupport[hook(4, base)] < support || episodeSupport[hook(4, compare)] < support) {
    episodePairs[hook(5, triangleIndex)] = false;
    return;
  }

  episodePairs[hook(5, triangleIndex)] = compareCandidates(episodeCandidates, level, base, compare);
}