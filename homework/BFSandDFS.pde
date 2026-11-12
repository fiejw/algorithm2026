import java.util.*;

Graph graph;
int numNodes = 8; // 노드 개수

// 애니메이션 제어 변수
ArrayList<Integer> visitOrder = new ArrayList<>(); // 방문한 노드 순서 저장
ArrayList<int[]> traversedEdges = new ArrayList<>(); // 탐색에 사용된 간선(부모->자식) 저장
int currentStep = 0;       // 현재 애니메이션 단계
int lastStepTime = 0;      // 마지막으로 단계가 넘어간 시간
int stepDelay = 650;       // 한 단계당 대기 시간 (밀리초, 650 = 0.65초)
String currentMode = "DFS";

void setup() {
  size(650, 500);
  generateNewRandomGraph();
}

void draw() {
  background(245);
  
  // 설정된 시간(stepDelay)마다 다음 노드로 진행
  if (currentStep < visitOrder.size() && millis() - lastStepTime > stepDelay) {
    currentStep++;
    lastStepTime = millis();
  }
  
  // 그래프 및 애니메이션 상태 그리기
  graph.display(visitOrder, traversedEdges, currentStep);
  
  // 상단 및 하단 UI 표시 (영문/기본 기호 전용)
  drawUI();
}

void drawUI() {
  fill(40);
  textAlign(LEFT, TOP);
  textSize(16);
  text("Mode: " + currentMode, 20, 18);
  
  fill(90);
  textSize(13);
  text("[1] DFS   |   [2] BFS   |   [Click] New Random Graph", 20, 44);
  
  // 하단에 현재까지 방문한 노드 순서 텍스트로 표시
  String pathText = "Order: ";
  for (int i = 0; i < currentStep; i++) {
    pathText += visitOrder.get(i);
    if (i < currentStep - 1) pathText += " -> ";
  }
  
  fill(30, 90, 180);
  textSize(15);
  text(pathText, 20, height - 35);
}

// 키보드로 DFS / BFS 전환
void keyPressed() {
  if (key == '1') {
    startAnimation("DFS");
  } else if (key == '2') {
    startAnimation("BFS");
  }
}

// 마우스 클릭 시 새 그래프 생성
void mousePressed() {
  generateNewRandomGraph();
}

void generateNewRandomGraph() {
  graph = new Graph(numNodes);
  graph.generateRandomEdges(0.3);
  startAnimation(currentMode); // 현재 선택된 모드로 애니메이션 시작
}

// 탐색을 실행하여 방문 순서를 기록하고 애니메이션 초기화
void startAnimation(String mode) {
  currentMode = mode;
  visitOrder.clear();
  traversedEdges.clear();
  graph.resetVisited();
  
  if (mode.equals("DFS")) {
    graph.recordDFS(0, -1, visitOrder, traversedEdges);
  } else {
    graph.recordBFS(0, visitOrder, traversedEdges);
  }
  
  currentStep = 1; // 시작 노드(0번)는 즉시 색칠된 상태로 시작
  lastStepTime = millis();
}

// -------------------------------------------------------------
// 그래프 클래스 정의
// -------------------------------------------------------------
class Graph {
  int V;
  ArrayList<Integer>[] adj;
  boolean[] visited;
  PVector[] nodePos;

  Graph(int v) {
    V = v;
    adj = new ArrayList[V];
    visited = new boolean[V];
    nodePos = new PVector[V];
    
    for (int i = 0; i < V; i++) {
      adj[i] = new ArrayList<Integer>();
    }
    
    // 겹치지 않게 노드 랜덤 배치
    for (int i = 0; i < V; i++) {
      boolean validPos = false;
      PVector candidate = new PVector();
      int attempts = 0;
      
      while (!validPos && attempts < 150) {
        candidate.set(random(70, width - 70), random(95, height - 75));
        validPos = true;
        for (int j = 0; j < i; j++) {
          if (PVector.dist(candidate, nodePos[j]) < 85) {
            validPos = false;
            break;
          }
        }
        attempts++;
      }
      nodePos[i] = candidate;
    }
  }

  void generateRandomEdges(float prob) {
    // 모든 노드가 연결되도록 기본 트리 구성
    for (int i = 1; i < V; i++) {
      int target = int(random(0, i));
      addEdge(i, target);
    }
    // 추가 랜덤 간선
    for (int i = 0; i < V; i++) {
      for (int j = i + 1; j < V; j++) {
        if (!adj[i].contains(j) && random(1) < prob) {
          addEdge(i, j);
        }
      }
    }
    for (int i = 0; i < V; i++) {
      Collections.sort(adj[i]);
    }
  }

  void addEdge(int v, int w) {
    adj[v].add(w);
    adj[w].add(v);
  }

  void resetVisited() {
    Arrays.fill(visited, false);
  }

  // DFS 경로 및 간선 기록
  void recordDFS(int v, int parent, ArrayList<Integer> order, ArrayList<int[]> edges) {
    visited[v] = true;
    order.add(v);
    if (parent != -1) {
      edges.add(new int[]{parent, v});
    }

    for (int n : adj[v]) {
      if (!visited[n]) {
        recordDFS(n, v, order, edges);
      }
    }
  }

  // BFS 경로 및 간선 기록
  void recordBFS(int start, ArrayList<Integer> order, ArrayList<int[]> edges) {
    Queue<Integer> queue = new LinkedList<>();
    visited[start] = true;
    queue.add(start);
    order.add(start);

    while (!queue.isEmpty()) {
      int v = queue.poll();

      for (int n : adj[v]) {
        if (!visited[n]) {
          visited[n] = true;
          queue.add(n);
          order.add(n);
          edges.add(new int[]{v, n});
        }
      }
    }
  }

  // 단계별 시각화
  void display(ArrayList<Integer> order, ArrayList<int[]> edges, int step) {
    // 1. 기본 회색 간선 전체 그리기
    stroke(210);
    strokeWeight(2);
    for (int i = 0; i < V; i++) {
      for (int j : adj[i]) {
        if (i < j) {
          line(nodePos[i].x, nodePos[i].y, nodePos[j].x, nodePos[j].y);
        }
      }
    }

    // 2. 현재 단계까지 탐색에 사용된 간선 강조 (파란색)
    stroke(60, 150, 250);
    strokeWeight(4);
    for (int i = 0; i < step - 1; i++) {
      if (i < edges.size()) {
        int u = edges.get(i)[0];
        int v = edges.get(i)[1];
        line(nodePos[u].x, nodePos[u].y, nodePos[v].x, nodePos[v].y);
      }
    }

    // 3. 노드 그리기
    for (int i = 0; i < V; i++) {
      int visitIndex = order.indexOf(i);
      
      // 상태별 색상 결정
      if (visitIndex != -1 && visitIndex == step - 1) {
        fill(255, 110, 50);  // 현재 방금 방문한 노드 (주황색 강조)
      } else if (visitIndex != -1 && visitIndex < step) {
        fill(60, 150, 250);  // 이미 방문 완료한 노드 (파란색)
      } else {
        fill(180);           // 아직 방문하지 않은 노드 (회색)
      }

      stroke(255);
      strokeWeight(2.5);
      ellipse(nodePos[i].x, nodePos[i].y, 44, 44);

      // 노드 번호 표시
      fill(255);
      textAlign(CENTER, CENTER);
      textSize(16);
      text(i, nodePos[i].x, nodePos[i].y);
    }
  }
}
