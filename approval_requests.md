# 과제 3번: 결재 시스템 테이블 정의 및 쿼리

## 요구사항

MySQL 또는 PostgreSQL을 사용하여 여러 단계의 승인 및 반려가 가능한 결재 시스템을 구축하는 시나리오에서,

1. 필요한 테이블을 최소한으로 정의해주세요.
2. 특정 사용자가 처리해야 할 결재 건을 나열하는 query를 작성해주세요.

## 테이블 구조 설계 (5개 테이블)

**5개의 테이블**을 정의:

1. **`users`**
2. **`roles`**
3. **`user_roles`**
4. **`approval_requests`**
5. **`approval_histories`**

### 테이블 개수 설명

#### (1) `users`

- **목적**: 시스템의 사용자 정보를 저장 (id, name, join_date 등).
- 결재 요청이나 승인 기록에서 사용자 ID를 참조.

#### (2) `roles`

- **목적**: 승인자 권한(예: 1단계 승인자, 2단계 승인자 등)을 정의.
- 향후 결재 단계별로 어떤 권한이 필요한지 확장 가능.

#### (3) `user_roles`

- **목적**: 사용자와 역할 간의 다대다(M:N) 관계를 관리.
- 한 사용자가 여러 역할을 가질 수 있고, 한 역할에 여러 사용자가 속할 수 있음.
- 테이블을 분리함으로써 데이터 정규화를 지키고, 확장성 확보.

이 세 테이블(`users`, `roles`, `user_roles`)은 사용자 관리 및 권한 체계를 구성하는 최소한의 테이블이라고 생각합니다.

#### (4) `approval_requests`

- **목적**: 결재 요청(문서)의 메인 정보를 저장.
- 누가(`requester_id`) 언제(`request_date`) 무엇을(`title`, `content`) 요청했고, 현재 단계(`current_step`)와 전체 단계(`total_steps`), 그리고 현재 승인자(`current_approver`)와 같은 결재 진행 상태를 저장.

#### (5) `approval_histories`

- **목적**: 각 결재 요청이 어떤 이력을 거쳤는지 기록.
- `approval_request_id`, 승인 단계(`step`), 승인자(`approver_id`), 처리 상태(`status`), 처리 시간(`action_date`).

이 두 테이블(`approval_requests`, `approval_histories`)은 결재 시스템의 핵심 로직을 담는 최소한의 테이블이라고 생각합니다.

## 쿼리 작성 의도

- 특정 사용자가 처리해야할 결재 요청 중에서, 전체 상태가 'pending' 또는 'in_progress'인 건들만 조회
- 즉, 아직 완료되지 않은 결재 요청 중 특정 사용자가 처리해야 할 건을 필터링하기 위한 쿼리

#### SELECT절 의도

- 처리해야할 결재의 필요한 정보,
- `request_date`, `title`, `content`, `current_step`, `overall_status`, `requester`만을 결재자에게 보여주기 위함

#### JOIN 의도

- `ar.requester_id`와 `u.id`를 조인하여 결재 요청자의 이름을 가져올 수 있도록 하기 위함

#### WHERE절 의도

- 특정 사용자 ID가 결재의 승인자로 지정된 결재 요청만 필터링하기 위함

#### PREPARE 의도

- 캐싱을 통해 성능을 높일 수 있고, 값이 분리 돼있기 때문에 보안 측면에서도 유리
- 재사용성을 높이기 위해 동적 파라미터 바인딩
