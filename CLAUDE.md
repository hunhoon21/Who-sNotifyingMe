# Who's Notifying Me - iOS 알림 분석 앱

## 핵심 목적
**"불필요한 알림을 식별하고 끄도록 도와서, 중요한 알림을 놓치지 않게 하는 앱"**

> 상세 요구사항: [requirements/app-requirements.md](./requirements/app-requirements.md)

## MVP 기능 (v1.0)
1. **대시보드**: 오늘/주간 알림 요약, 상위 앱 목록
2. **통계/차트**: 시간대별, 일별, 카테고리별 시각화
3. **앱 목록**: 앱별 상세 통계 + iOS 설정 바로가기
4. **설정**: 권한 관리, 데이터 내보내기
5. **다국어**: 한국어 + 영어

## 추후 개발 (v2.0+)
- AI 인사이트 (패턴 분석, 끄기 추천)
- 홈 화면 위젯
- Focus 모드 연동
- 프리미엄 기능 (인앱 결제)

## 기술 스택
| 항목 | 선택 |
|------|------|
| 언어 | Swift 5.9+ |
| UI | SwiftUI |
| 아키텍처 | MVVM + Clean Architecture |
| 데이터 | Core Data |
| 차트 | Swift Charts |
| 알림 데이터 | Screen Time API (DeviceActivity) |
| 최소 iOS | 17.0 |

## 프로젝트 구조
```
Who-sNotifyingMe/
├── CLAUDE.md                    # 프로젝트 컨텍스트
├── project.yml                  # XcodeGen 설정
├── requirements/
│   └── app-requirements.md      # 상세 요구사항
├── WhosNotifyingMe/
│   ├── App/                     # 앱 진입점
│   ├── Features/
│   │   ├── Dashboard/           # 대시보드
│   │   ├── Analytics/           # 통계/차트
│   │   ├── Settings/            # 설정
│   │   └── Notifications/       # 앱 목록
│   ├── Core/
│   │   ├── Models/              # 데이터 모델
│   │   ├── Services/            # 비즈니스 로직
│   │   └── Extensions/          # Swift 확장
│   └── Resources/               # Assets, Localization
└── WhosNotifyingMeTests/        # 단위 테스트
```

## Claude Code 활용 가이드

### 에이전트
| 에이전트 | 용도 |
|----------|------|
| `Explore` | 코드베이스 탐색, 구조 파악 |
| `Plan` | 구현 전략 수립, 설계 |
| `Bash` | 빌드, 테스트, 시뮬레이터 실행 |

### 스킬
| 스킬 | 용도 |
|------|------|
| `/commit` | Git 커밋 생성 |
| `/clarify` | 요구사항 명확화 |

### 훅 설정
```json
// .claude/settings.json
{
  "hooks": {
    "pre-tool:Write": "swiftlint --fix"
  }
}
```

## 개발 컨벤션

### 코드 스타일
- SwiftLint 규칙 준수
- 한글 주석 허용 (복잡한 로직)
- 영문 변수명/함수명

### Git 커밋
```
feat: 새 기능
fix: 버그 수정
refactor: 리팩토링
docs: 문서 수정
test: 테스트
chore: 빌드/설정
```

### 브랜치
- `main`: 배포 가능 상태
- `feature/*`: 기능 개발
- `bugfix/*`: 버그 수정

## 빌드 및 실행

```bash
# Xcode 경로 설정 (최초 1회)
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer

# 프로젝트 열기
open WhosNotifyingMe.xcodeproj

# CLI 빌드
xcodebuild -scheme WhosNotifyingMe -destination 'platform=iOS Simulator,name=iPhone 15'

# 테스트 실행
xcodebuild test -scheme WhosNotifyingMe -destination 'platform=iOS Simulator,name=iPhone 15'

# 프로젝트 재생성 (project.yml 수정 후)
xcodegen generate
```

## iOS 제한사항 참고

| 제한 | 대안 |
|------|------|
| 다른 앱 알림 직접 접근 불가 | Screen Time API로 통계 수집 |
| 다른 앱 알림 직접 끄기 불가 | iOS 설정 바로가기 버튼 제공 |

## 현재 개발 상태
- [x] 프로젝트 초기 설정
- [x] 기본 UI 구조 (탭뷰, 화면들)
- [x] 요구사항 명세서 작성
- [ ] Screen Time API 연동
- [ ] 실제 데이터로 대시보드 구현
- [ ] 통계 차트 완성
- [ ] iOS 설정 바로가기 구현
- [ ] 로컬라이제이션 (한/영)
- [ ] 테스트 작성
