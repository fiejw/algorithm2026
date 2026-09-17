int[] arr;

void setup() {
  intArr(16);
  printArr();
  mergeSorting();
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

void mergeSorting() {
  mergeSort(0, arr.length - 1);
}

void mergeSort(int p, int r) {
  if (p < r) {
    int q = (p + r) / 2;
    mergeSort(p, q);
    mergeSort(q + 1, r);
    merge(p, q, r);
  }
}

void merge(int p, int q, int r) {
  int[] tmp = new int[r - p + 1];
  int i = p;
  int j = q + 1;
  int k = 0;

  while (i <= q && j <= r) {
    if (arr[i] <= arr[j]) {
      tmp[k++] = arr[i++];
    } else {
      tmp[k++] = arr[j++];
    }
  }

  while (i <= q) {
    tmp[k++] = arr[i++];
  }

  while (j <= r) {
    tmp[k++] = arr[j++];
  }

  for (int t = 0; t < tmp.length; t++) {
    arr[p + t] = tmp[t];
  }
}

void draw() {
}
