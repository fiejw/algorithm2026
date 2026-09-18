int[] arr;

void setup() {
  intArr(16);
  printArr();
  heapSorting();
  printArr();
}

void intArr(int n) {
  int i;
  arr = new int[n];
  for(i=0; i<arr.length; i++) {
    arr[i] = (int) random(100);
  }
}

void printArr() {
  int i;
  for(i=0; i<arr.length; i++) {
    print(arr[i], " ");
  }
  println();
}

void heapSorting() {
  int n = arr.length;
  
  for (int i = n / 2 - 1; i >= 0; i--) {
    heapify(n, i);
  }
  
  for (int i = n - 1; i > 0; i--) {
    int tmp = arr[0];
    arr[0] = arr[i];
    arr[i] = tmp;
    
    heapify(i, 0);
  }
}

void heapify(int n, int i) {
  int largest = i;
  int left = 2 * i + 1;
  int right = 2 * i + 2;

  if (left < n && arr[left] > arr[largest]) {
    largest = left;
  }
  
  if (right < n && arr[right] > arr[largest]) {
    largest = right;
  }
  
  if (largest != i) {
    int swap = arr[i];
    arr[i] = arr[largest];
    arr[largest] = swap;
    
    heapify(n, largest);
  }
}

void draw() {
}
