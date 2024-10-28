//{"array":6,"cap":5,"cost":12,"demand":18,"fftt":3,"flow":4,"head":11,"input":1,"maxCost":14,"maxPath":17,"minCost":7,"minPath":16,"multiplier":2,"nextMaxArc":15,"nextMinArc":8,"output":0,"pointer":9,"tail":13,"topoOrder":10}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float setCost(int arc, float fftt[], float flow[], float cap[]) {
  return fftt[hook(3, arc)] * (1.0F + 0.15F * powr((flow[hook(4, arc)] / cap[hook(5, arc)]), 4.0F));
}

float calcCost(int arc, float deltaV, float fftt[], float flow[], float cap[]) {
  return fftt[hook(3, arc)] * (1.0F + 0.15F * powr(((flow[hook(4, arc)] + deltaV) / cap[hook(5, arc)]), 4.0F));
}

float calcCostPrime(int arc, float deltaV, float fftt[], float flow[], float cap[]) {
  return 0.6F * fftt[hook(3, arc)] * powr(flow[hook(4, arc)] + deltaV, 3.0F) / powr(cap[hook(5, arc)], 4.0F);
}

int isInNodeArray(int array[], int n) {
  int i;
  for (i = 0; i < 25; ++i) {
    if (array[hook(6, i)] == n) {
      return 1;
    }
  }
  return 0;
}

void updateCost(float minCost[], float maxCost[], float cost[], float flow[], int sinkNode, int pointer[], int tail[], int head[], int topoOrder[], int nextMinArc[], int nextMaxArc[]) {
  int i;
  int arc;
  float costCand;

  for (i = 0; i < 25; i++) {
    minCost[hook(7, i)] = 999999;
  }

  minCost[hook(7, sinkNode - 1)] = 0;
  nextMinArc[hook(8, sinkNode - 1)] = 80;
  for (i = 0; i < 25; i++) {
    arc = pointer[hook(9, topoOrder[ihook(10, i) - 1)] - 1;
    while (head[hook(11, arc)] == topoOrder[hook(10, i)]) {
      costCand = cost[hook(12, arc)] + minCost[hook(7, head[ahook(11, arc) - 1)];
      if (costCand < minCost[hook(7, tail[ahook(13, arc) - 1)]) {
        minCost[hook(7, tail[ahook(13, arc) - 1)] = costCand;
        nextMinArc[hook(8, tail[ahook(13, arc) - 1)] = arc;
      }
      ++arc;
    }
  }

  for (i = 0; i < 25; i++) {
    maxCost[hook(14, i)] = 0;
  }

  maxCost[hook(14, sinkNode - 1)] = 0;
  nextMaxArc[hook(15, sinkNode - 1)] = 80;
  for (i = 0; i < 25; i++) {
    arc = pointer[hook(9, topoOrder[ihook(10, i) - 1)] - 1;
    while (head[hook(11, arc)] == topoOrder[hook(10, i)]) {
      costCand = cost[hook(12, arc)] + maxCost[hook(14, head[ahook(11, arc) - 1)];
      if (costCand >= maxCost[hook(14, tail[ahook(13, arc) - 1)] && flow[hook(4, arc)] > 0) {
        maxCost[hook(14, tail[ahook(13, arc) - 1)] = costCand;
        nextMaxArc[hook(15, tail[ahook(13, arc) - 1)] = arc;
      }
      ++arc;
    }
  }
}

void getPaths(int origin, int sinkNode, int head[], int minPath[], int maxPath[], int nextMinArc[], int nextMaxArc[]) {
  int i, j, k;
  int length = 0;
  int hasCommonNode = 1;

  minPath[hook(16, length)] = origin;
  maxPath[hook(17, length)] = origin;

  while (hasCommonNode) {
    if (nextMaxArc[hook(15, minPath[lhook(16, length))] == nextMinArc[hook(8, maxPath[lhook(17, length))]) {
      minPath[hook(16, length)] = head[hook(11, nextMaxArc[mhook(15, minPath[lhook(16, length)))] - 1;
      maxPath[hook(17, length)] = minPath[hook(16, length)];
      continue;
    }
    hasCommonNode = 0;
  }

  while (!hasCommonNode) {
    ++length;
    if (minPath[hook(16, length - 1)] != sinkNode - 1) {
      minPath[hook(16, length)] = head[hook(11, nextMinArc[mhook(8, minPath[lhook(16, length - 1)))] - 1;
    } else {
      minPath[hook(16, length)] = 25;
    }
    if (maxPath[hook(17, length - 1)] != sinkNode - 1) {
      maxPath[hook(17, length)] = head[hook(11, nextMaxArc[mhook(15, maxPath[lhook(17, length - 1)))] - 1;
    } else {
      maxPath[hook(17, length)] = 25;
    }
    for (i = 1; i < length + 1; ++i) {
      for (j = 1; j < length + 1; ++j) {
        if (maxPath[hook(17, i)] == minPath[hook(16, j)]) {
          for (k = j; k < 25; ++k) {
            minPath[hook(16, k + 1)] = 25;
          }
          for (k = i; k < 25; ++k) {
            maxPath[hook(17, k + 1)] = 25;
          }
          hasCommonNode = 1;
          return;
        }
      }
    }
  }
}

void shiftFlow(int sinkNode, int maxPath[], int minPath[], int pointer[], int tail[], int head[], int topoOrder[], int nextMinArc[], int nextMaxArc[], float flow[], float fftt[], float cap[], float cost[], float minCost[], float maxCost[]) {
  int i = 0;
  float nextFlow;
  float max = 999999;
  float root = 0;
  float f = 1.0F;
  float fPrime;
  int maxIter = 10;
  int iter = 0;

  for (i = 0; i < 25; ++i) {
    if (maxPath[hook(17, i)] >= 25 - 1) {
      break;
    }
    nextFlow = flow[hook(4, nextMaxArc[mhook(15, maxPath[ihook(17, i)))];
    if (nextFlow < max) {
      max = nextFlow;
    }
  }
  root = 0;

  while (fabs(f) > 0.001F) {
    if (iter >= maxIter) {
      break;
    }
    ++iter;
    i = 0;
    f = 0;
    fPrime = 0;
    while (minPath[hook(16, i + 1)] < 25 || maxPath[hook(17, i + 1)] < 25) {
      if (minPath[hook(16, i + 1)] < 25) {
        f += calcCost(nextMinArc[hook(8, minPath[ihook(16, i))], root, fftt, flow, cap);
        fPrime += calcCostPrime(nextMinArc[hook(8, minPath[ihook(16, i))], root, fftt, flow, cap);
      }
      if (maxPath[hook(17, i + 1)] < 25) {
        f -= calcCost(nextMaxArc[hook(15, maxPath[ihook(17, i))], -1 * root, fftt, flow, cap);
        fPrime += calcCostPrime(nextMaxArc[hook(15, maxPath[ihook(17, i))], -1 * root, fftt, flow, cap);
      }
      ++i;
    }

    root -= f / fPrime;
  }
  if (root > max) {
    root = max;
  } else if (root < 0.0001f) {
    root = 0;
    return;
  }
  i = 0;
  while (minPath[hook(16, i + 1)] < 25 || maxPath[hook(17, i + 1)] < 25) {
    if (minPath[hook(16, i + 1)] < 25) {
      flow[hook(4, nextMinArc[mhook(8, minPath[ihook(16, i)))] += root;
      cost[hook(12, nextMinArc[mhook(8, minPath[ihook(16, i)))] = setCost(nextMinArc[hook(8, minPath[ihook(16, i))], fftt, flow, cap);
    }
    if (maxPath[hook(17, i + 1)] < 25) {
      flow[hook(4, nextMaxArc[mhook(15, maxPath[ihook(17, i)))] -= root;
      cost[hook(12, nextMaxArc[mhook(15, maxPath[ihook(17, i)))] = setCost(nextMaxArc[hook(15, maxPath[ihook(17, i))], fftt, flow, cap);
    }
    ++i;
  }
  updateCost(minCost, maxCost, cost, flow, sinkNode, pointer, tail, head, topoOrder, nextMinArc, nextMaxArc);
}

void equilibrateBush(int sinkNode, int maxPath[], int minPath[], int nextMinArc[], int nextMaxArc[], int pointer[], int demand[], int tail[], int head[], int topoOrder[], float flow[], float fftt[], float cap[], float cost[], float minCost[], float maxCost[]) {
  int i;
  int eqBush = 0;
  float nextCost = 0;

  while (!eqBush) {
    for (i = 0; i < 25; ++i) {
      if (maxCost[hook(14, i)] - minCost[hook(7, i)] > 0.01F && demand[hook(18, i)] > 0) {
        getPaths(i, sinkNode, head, minPath, maxPath, nextMinArc, nextMaxArc);
        nextCost = maxCost[hook(14, i)];
        shiftFlow(sinkNode, maxPath, minPath, pointer, tail, head, topoOrder, nextMinArc, nextMaxArc, flow, fftt, cap, cost, minCost, maxCost);

        if (maxCost[hook(14, i)] == nextCost) {
          continue;
        }

        break;
      }
      if (i == 25 - 1) {
        eqBush = 1;
      }
    }
  }
}

void initNetwork(int sinkNode, int topoOrder[], int tail[], int head[], int pointer[], int demand[], int nextMinArc[], int nextMaxArc[], float minCost[], float maxCost[], float cost[], float fftt[], float cap[], float flow[]) {
  int i;
  int place = 0;
  int queue = 0;
  int arc;
  float costCand;
  int nextArc;

  for (i = 0; i < 80; ++i) {
    flow[hook(4, i)] = 0;
    cost[hook(12, i)] = 0;
  }

  i = 0;
  topoOrder[hook(10, queue)] = sinkNode;
  ++queue;
  for (; place < 80; ++place) {
    for (i = 0; i < 80; ++i) {
      if (head[hook(11, i)] == topoOrder[hook(10, place)] && !isInNodeArray(topoOrder, tail[hook(13, i)])) {
        topoOrder[hook(10, queue)] = tail[hook(13, i)];
        ++queue;
      }
    }
  }

  for (i = 0; i < 80; ++i) {
    cost[hook(12, i)] = 999999;
  }

  for (i = 0; i < 25; i++) {
    minCost[hook(7, i)] = 999999;
  }
  minCost[hook(7, sinkNode - 1)] = 0;
  nextMinArc[hook(8, sinkNode - 1)] = 80;
  for (i = 0; i < 25; i++) {
    arc = pointer[hook(9, topoOrder[ihook(10, i) - 1)] - 1;
    while (head[hook(11, arc)] == topoOrder[hook(10, i)]) {
      costCand = fftt[hook(3, arc)] + minCost[hook(7, head[ahook(11, arc) - 1)];
      if (costCand < minCost[hook(7, tail[ahook(13, arc) - 1)]) {
        minCost[hook(7, tail[ahook(13, arc) - 1)] = costCand;
        nextMinArc[hook(8, tail[ahook(13, arc) - 1)] = arc;
      }
      ++arc;
    }
  }

  for (i = 0; i < 25; i++) {
    maxCost[hook(14, i)] = 0;
  }
  maxCost[hook(14, sinkNode - 1)] = 0;
  nextMaxArc[hook(15, sinkNode - 1)] = 80;
  for (i = 0; i < 25; i++) {
    arc = pointer[hook(9, topoOrder[ihook(10, i) - 1)] - 1;
    while (head[hook(11, arc)] == topoOrder[hook(10, i)]) {
      costCand = fftt[hook(3, arc)] + maxCost[hook(14, head[ahook(11, arc) - 1)];
      if (costCand > maxCost[hook(14, tail[ahook(13, arc) - 1)]) {
        maxCost[hook(14, tail[ahook(13, arc) - 1)] = costCand;
        nextMaxArc[hook(15, tail[ahook(13, arc) - 1)] = arc;
      }
      ++arc;
    }
  }

  nextArc = 80;
  for (i = 0; i < 25; ++i) {
    nextArc = nextMinArc[hook(8, i)];
    while (nextArc < 80) {
      flow[hook(4, nextArc)] += demand[hook(18, i)];
      nextArc = nextMinArc[hook(8, head[nhook(11, nextArc) - 1)];
    }
  }

  for (arc = 0; arc < 80; ++arc) {
    if (minCost[hook(7, head[ahook(11, arc) - 1)] < minCost[hook(7, tail[ahook(13, arc) - 1)]) {
      cost[hook(12, arc)] = setCost(arc, fftt, flow, cap);
    }
  }

  updateCost(minCost, maxCost, cost, flow, sinkNode, pointer, tail, head, topoOrder, nextMinArc, nextMaxArc);
}

int updateBush(int sinkNode, int topoOrder[], int tail[], int head[], int pointer[], int nextMinArc[], int nextMaxArc[], float minCost[], float maxCost[], float cost[], float fftt[], float cap[], float flow[])

{
  int i;
  int j;
  int isUpdated = 0;

  for (i = 0; i < 80; ++i) {
    if (flow[hook(4, i)] == 0 && cost[hook(12, i)] < 999999) {
      j = pointer[hook(9, tail[ihook(13, i) - 1)] - 1;
      while (head[hook(11, j)] == tail[hook(13, i)]) {
        if (tail[hook(13, j)] == head[hook(11, i)] && fftt[hook(3, j)] + minCost[hook(7, head[jhook(11, j) - 1)] < minCost[hook(7, tail[jhook(13, j) - 1)]) {
          cost[hook(12, i)] = 999999;
          cost[hook(12, j)] = setCost(j, fftt, flow, cap);
          isUpdated = 1;
        }
        ++j;
      }
    }
  }
  updateCost(minCost, maxCost, cost, flow, sinkNode, pointer, tail, head, topoOrder, nextMinArc, nextMaxArc);
  return isUpdated;
}

void testFunc(float flow[]) {
  flow[hook(4, 2)] = 666.f;
}

void equilibrateNetwork(int sinkNode, int maxPath[], int minPath[], int nextMinArc[], int nextMaxArc[], int pointer[], int demand[], int tail[], int head[], int topoOrder[], float flow[], float fftt[], float cap[], float cost[], float minCost[], float maxCost[]) {
  int bushUpdated = 1;
  while (bushUpdated) {
    equilibrateBush(sinkNode, maxPath, minPath, nextMinArc, nextMaxArc, pointer, demand, tail, head, topoOrder, flow, fftt, cap, cost, minCost, maxCost);

    bushUpdated = updateBush(sinkNode, topoOrder, tail, head, pointer, nextMinArc, nextMaxArc, minCost, maxCost, cost, fftt, cap, flow);
  }
}
kernel void kernelB(global unsigned int* output, global unsigned int* input, const unsigned int multiplier)

{
  unsigned int tid = get_global_id(0);

  int sinkNode = 24;
  int pointer[] = {1, 3, 6, 9, 12, 14, 17, 21, 25, 29, 32, 35, 39, 43, 47, 50, 53, 57, 61, 65, 68, 70, 73, 76, 79};

  int demand[] = {50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 0, 50};

  int tail[] = {2, 6, 1, 3, 7, 2, 4, 8, 3, 5, 9, 4, 10, 1, 7, 11, 2, 6, 8, 12, 3, 7, 9, 13, 4, 8, 10, 14, 5, 9, 15, 6, 12, 16, 7, 11, 13, 17, 8, 12, 14, 18, 9, 13, 15, 19, 10, 14, 20, 11, 17, 21, 12, 16, 18, 22, 13, 17, 19, 23, 14, 18, 20, 24, 15, 19, 25, 16, 22, 17, 21, 23, 18, 22, 24, 19, 23, 25, 20, 24};
  int head[] = {1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 6, 6, 6, 7, 7, 7, 7, 8, 8, 8, 8, 9, 9, 9, 9, 10, 10, 10, 11, 11, 11, 12, 12, 12, 12, 13, 13, 13, 13, 14, 14, 14, 14, 15, 15, 15, 16, 16, 16, 17, 17, 17, 17, 18, 18, 18, 18, 19, 19, 19, 19, 20, 20, 20, 21, 21, 22, 22, 22, 23, 23, 23, 24, 24, 24, 25, 25};
  float fftt[] = {3.72f, 3.72f, 3.72f, 5.4f, 4.02f, 5.4f, 3.3f, 1.37f, 3.3f, 4.98f, 3.09f, 4.98f, 4.59f, 3.72f, 4.17f, 4.32f, 4.02f, 4.17f, 4.02f, 4.11f, 1.37f, 4.02f, 5.55f, 1.41f, 3.09f, 5.55f, 3.42f, 4.11f, 4.59f, 3.42f, 3.42f, 4.32f, 1.23f, 4.35f, 4.11f, 1.23f, 1.85f, 5.49f, 1.41f, 1.85f, 1.89f, 2.15f, 4.11f, 1.89f, 1.03f, 5.46f, 3.42f, 1.03f, 6.09f, 4.35f, 3.09f, 5.58f, 5.49f, 3.09f, 4.5f, 4.02f, 2.15f, 4.5f, 5.94f, 1.79f, 5.46f, 5.94f, 2.97f, 5.85f, 6.09f, 2.97f, 4.05f, 5.58f, 5.76f, 4.02f, 5.76f, 4.44f, 1.79f, 4.44f, 5.1f, 5.85f, 5.1f, 3.f, 4.05f, 3.f};
  float cap[] = {300, 300, 300, 300, 300, 300, 300, 200, 300, 300, 300, 300, 300, 300, 300, 300, 300, 300, 300, 300, 200, 300, 300, 200, 300, 300, 300, 300, 300, 300, 300, 300, 200, 300, 300, 200, 200, 300, 200, 200, 200, 200, 300, 200, 200, 300, 300, 200, 300, 300, 300, 300, 300, 300, 300, 300, 200, 300, 300, 200, 300, 300, 300, 300, 300, 300, 300, 300, 300, 300, 300, 300, 200, 300, 300, 300, 300, 300, 300, 300};

  int topoOrder[25];
  float minCost[25];
  float maxCost[25];

  float flow[80];
  float cost[80];
  int nextMaxArc[25];
  int nextMinArc[25];
  int minPath[25];
  int maxPath[25];

  initNetwork(sinkNode, topoOrder, tail, head, pointer, demand, nextMinArc, nextMaxArc, minCost, maxCost, cost, fftt, cap, flow);

  output[hook(0, tid)] = flow[hook(4, tid)];
}