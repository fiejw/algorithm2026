int len = 16;
int max = 100;

int[] list = new int[len];

int end = len - 1;    // 현재 가장 큰 값을 넣을 위치
int j = 0;            // 배열을 탐색하는 위치
int maxIndex = 0;     // 현재까지 찾은 가장 큰 값의 위치

boolean sorting = true;


void setup() {
  size(800, 500);

  // 랜덤한 숫자 생성
  for (int i = 0; i < len; i++) {
    list[i] = (int)random(max);
  }

  maxIndex = 0;
}


void draw() {
  background(255);

  // 막대 그래프
  for (int i = 0; i < len; i++) {

    // 현재 가장 큰 값을 찾고 있는 값
    if (i == maxIndex && sorting) {
      fill(255, 0, 0);
    }

    // 현재 비교하고 있는 값
    else if (i == j && sorting) {
      fill(0, 150, 255);
    }

    // 이미 정렬된 부분
    else if (i > end) {
      fill(0, 200, 100);
    }

    // 일반적인 값
    else {
      fill(150);
    }

    float barWidth = width / (float)len;
    float barHeight = list[i] * 4;

    rect(
      i * barWidth,
      height - barHeight,
      barWidth - 2,
      barHeight
    );

    // 숫자 표시
    fill(0);
    textAlign(CENTER);
    text(
      list[i],
      i * barWidth + barWidth / 2,
      height - barHeight - 5
    );
  }

  // 선택 정렬 실행
  if (sorting) {
    selectionSortAnimation();
  }
}


void selectionSortAnimation() {

  // 배열 앞부분을 탐색
  if (j <= end) {

    // 더 큰 값을 찾았다면 maxIndex 변경
    if (list[j] > list[maxIndex]) {
      maxIndex = j;
    }

    j++;

  } 
  else {

    // 가장 큰 값과 현재 마지막 위치의 값 교환
    int temp = list[end];
    list[end] = list[maxIndex];
    list[maxIndex] = temp;

    // 다음 정렬 위치
    end--;

    if (end <= 0) {
      sorting = false;
    } 
    else {
      // 다시 처음부터 탐색
      j = 0;
      maxIndex = 0;
    }
  }

  // 애니메이션 속도
  delay(100);
}
