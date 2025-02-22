export function countIslands(arr: number[][]): number {
  const row = arr.length;
  if (row === 0) return 0;
  const col = arr[0].length;

  let count = 0;

  // 방문을 표시하는 2차원 배열 초기화
  const visited: number[][] = Array.from({ length: row }, () =>
    new Array(col).fill(0)
  );

  // DFS 함수 : (r, c)에서 시작해서 연결 요소를 방문 처리
  function dfs(r: number, c: number) {
    visited[r][c] = 1;

    // 8방향 탐색
    for (const [x, y] of direction) {
      const nx = r + x;
      const ny = c + y;

      // 좌표가 범위 내, 미방문, land인 경우 DFS 재귀호출
      if (
        nx >= 0 &&
        nx < row &&
        ny >= 0 &&
        ny < col &&
        !visited[nx][ny] &&
        arr[nx][ny] == 1
      ) {
        dfs(nx, ny);
      }
    }
  }

  // 전체 배열 순회하며 섬의 수 세기
  for (let r = 0; r < row; r++) {
    for (let c = 0; c < col; c++) {
      if (arr[r][c] === 1 && !visited[r][c]) {
        count++;
        dfs(r, c);
      }
    }
  }

  return count;
}

const landMap: number[][] = [
  [1, 0, 1, 0, 0],
  [1, 0, 0, 0, 0],
  [1, 0, 1, 0, 1],
  [1, 0, 0, 1, 0],
];

const direction: [number, number][] = [
  [-1, 0],
  [1, 0],
  [0, -1],
  [0, 1],
  [1, 1],
  [1, -1],
  [-1, 1],
  [-1, -1],
];

console.log("result:", countIslands(landMap));
