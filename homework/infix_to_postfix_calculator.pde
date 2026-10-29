import java.util.Stack;

PFont myFont;
String inputText = "";   // 사용자가 입력 중인 문자열
String infix = "";       // 최종 입력된 중위 표기식
String postfix = "";     // 변환된 후위 표기식
String resultText = "";  // 계산 결과 텍스트

void setup() {
  size(600, 350);
  
  // 한글 폰트 설정 (Windows: Malgun Gothic / Mac: AppleGothic)
  myFont = createFont("Malgun Gothic", 16);
  textFont(myFont);
}

void draw() {
  background(245); // 밝은 회색 배경
  
  // 1. 입력 안내 창
  fill(0);
  textSize(16);
  text("수식을 입력하고 Enter를 누르세요 (예: 3 + 5 * ( 2 - 8 ) )", 40, 50);
  text("⚠️ 주의: 모든 숫자와 연산자, 괄호 사이에 '공백(띄어쓰기)'을 꼭 넣어주세요!", 40, 75);
  
  // 2. 입력 박스 그리기
  fill(255);
  stroke(200);
  rect(40, 95, 520, 40, 5);
  
  // 3. 현재 입력 중인 텍스트 표시
  fill(0);
  text(inputText + (frameCount / 15 % 2 == 0 ? "_" : ""), 50, 120); // 깜빡이는 커서 효과
  
  // 4. 결과 출력 (Enter를 누른 이후 표시됨)
  if (!infix.equals("")) {
    stroke(180);
    line(40, 160, 560, 160); // 구분선
    
    fill(50);
    text("입력한 중위 표기식 (Infix):  " + infix, 40, 200);
    
    fill(0, 102, 204); // 파란색 강조
    text("변환된 후위 표기식 (Postfix): " + postfix, 40, 240);
    
    fill(204, 0, 0); // 빨간색 강조
    textSize(18);
    text("최종 계산 결과: " + resultText, 40, 290);
  }
}

// 키보드 입력 이벤트 함수
void keyPressed() {
  if (key == ENTER || key == RETURN) {
    if (inputText.trim().length() > 0) {
      infix = inputText.trim();
      try {
        postfix = infixToPostfix(infix);
        float res = evaluatePostfix(postfix);
        resultText = String.valueOf(res);
      } catch (Exception e) {
        postfix = "오류";
        resultText = "수식을 확인해 주세요. (공백 필수)";
      }
    }
  } else if (key == BACKSPACE) {
    // 백스페이스 키로 글자 지우기
    if (inputText.length() > 0) {
      inputText = inputText.substring(0, inputText.length() - 1);
    }
  } else if (key != CODED && key != ESC) {
    // 일반 문자 및 숫자 입력 (글자 추가)
    inputText += key;
  }
}

// --- 이하는 동일한 내부 알고리즘 함수 (Infix -> Postfix 변환 및 계산) ---

String infixToPostfix(String s) {
  StringBuilder output = new StringBuilder();
  Stack<String> stack = new Stack<>();
  String[] tokens = s.split("\\s+"); // 공백이 여러 개여도 처리 가능하도록 수정
  
  for (String token : tokens) {
    if (isNumeric(token)) {
      output.append(token).append(" ");
    }
    else if (token.equals("(")) {
      stack.push(token);
    }
    else if (token.equals(")")) {
      while (!stack.isEmpty() && !stack.peek().equals("(")) {
        output.append(stack.pop()).append(" ");
      }
      if (!stack.isEmpty() && stack.peek().equals("(")) {
        stack.pop();
      }
    }
    else if (isOperator(token)) {
      while (!stack.isEmpty() && precedence(stack.peek()) >= precedence(token)) {
        output.append(stack.pop()).append(" ");
      }
      stack.push(token);
    }
  }
  
  while (!stack.isEmpty()) {
    output.append(stack.pop()).append(" ");
  }
  
  return output.toString().trim();
}

float evaluatePostfix(String postfixStr) {
  if(postfixStr.equals("오류") || postfixStr.isEmpty()) return 0;
  
  Stack<Float> stack = new Stack<>();
  String[] tokens = postfixStr.split("\\s+");
  
  for (String token : tokens) {
    if (isNumeric(token)) {
      stack.push(Float.parseFloat(token));
    } else if (isOperator(token)) {
      if (stack.size() < 2) return 0; // 에러 방지 예외 처리
      float val2 = stack.pop();
      float val1 = stack.pop();
      float res = 0;
      
      switch (token) {
        case "+": res = val1 + val2; break;
        case "-": res = val1 - val2; break;
        case "*": res = val1 * val2; break;
        case "/": res = val1 / val2; break;
      }
      stack.push(res);
    }
  }
  return stack.isEmpty() ? 0 : stack.pop();
}

int precedence(String op) {
  if (op.equals("+") || op.equals("-")) return 1;
  if (op.equals("*") || op.equals("/")) return 2;
  return -1;
}

boolean isOperator(String token) {
  return token.equals("+") || token.equals("-") || token.equals("*") || token.equals("/");
}

boolean isNumeric(String str) {
  try {
    Float.parseFloat(str);
    return true;
  } catch (NumberFormatException e) {
    return false;
  }
}
