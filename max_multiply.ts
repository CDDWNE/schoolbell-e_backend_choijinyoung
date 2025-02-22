class MaxProductor {
  memo: Map<string, number> = new Map();
  maxVal: number = 0;
  bestPair: [number, number] = [0, 0];

  // DFS 함수: num1, num2는 현재 구성된 두 수, remaining은 아직 사용하지 않은 숫자들
  dfs(num1: number, num2: number, remaining: number[]): number {
    const state = `${num1},${num2},${remaining.join(",")}`;
    if (this.memo.has(state)) {
      return this.memo.get(state)!;
    }

    // 모든 숫자를 사용했다면 두 수의 곱 계산
    if (remaining.length === 0) {
      const product = num1 * num2;
      if (product > this.maxVal) {
        this.maxVal = product;
        this.bestPair = [num1, num2];
      }
      this.memo.set(state, product);
      return product;
    }

    const next = remaining[0];
    const res1 = this.dfs(num1 * 10 + next, num2, remaining.slice(1));
    const res2 = this.dfs(num1, num2 * 10 + next, remaining.slice(1));
    const result = Math.max(res1, res2);
    this.memo.set(state, result);
    return result;
  }
}

function maxProduct(numbers: number[]): {
  bestPair: [number, number];
  maxVal: number;
} {
  // 내림차순 정렬
  numbers.sort((a, b) => b - a);

  const prod = new MaxProductor();
  // DFS 시작: 첫 숫자를 num1에 할당하는 경우와 num2에 할당하는 경우로 분기
  prod.dfs(numbers[0], 0, numbers.slice(1));
  prod.dfs(0, numbers[0], numbers.slice(1));

  return { bestPair: prod.bestPair, maxVal: prod.maxVal };
}

const input = [1, 3, 5, 7, 9];
const result = maxProduct(input);
console.log(`result: ${result.bestPair[0]}, ${result.bestPair[1]} `);
