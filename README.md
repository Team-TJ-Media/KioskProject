# 📱 KioskProject

TJ 미디어 팀의 키오스크 애플리케이션은 사용자 친화적인 인터페이스를 제공하여 상품 주문 및 결제 과정을 간소화합니다.
이 앱은 터치 기반의 직관적인 디자인을 통해 다양한 사용자들이 쉽게 접근하고 사용할 수 있도록 설계되었습니다.

---

## 📸 화면 미리보기

---

## 🗓 프로젝트 일정

- **시작일:** 2025년 4월 7일
- **종료일:** 2025년 4월 11일

---

## 📂 폴더 구조
```
KioskProject
├── App
│   ├── Sources
│   │   └── DIContainer
│   └── Resources
├── Data
│   └── Sources
│       ├── DTO
│       │   └── ProductDTO
│       ├── Error Type
│       ├── Repository
│       ├── Service
│       └── Utils
├── Domain
│   └── Sources
│       ├── Entity
│       │   └── Product
│       ├── Repository Interface
│       ├── UseCase
│       └── UseCase Interface
├── Presentation
│   └── Sources
│       ├── Component
│       │   ├── Button
│       │   └── Style
│       ├── DIContainer Interface
│       ├── Model
│       ├── Utils
│       │   ├── Extension
│       │   ├── Protocol
│       ├── View
│       │   ├── Cell
│       │   ├── View
│       ├── ViewController
│       │   └── Delegate
│       └── ViewModel
├── Resources
│   └── Assets
└── Frameworks
```

---

## 🛠 사용 기술

- **Swift 5**
- **UIKit**
- **SnapKit** (제약 조건 설정을 위한 라이브러리)
- **Kingfisher** (이미지 다운로드 및 캐싱)
- **Then** (편리한 인스턴스 초기화)
- **MVVM 패턴 적용**
- **RxSwift, RxCocoa**
- **RxDataSources**
- **Clean Architecture**

---

## 🌟 주요 기능
- 메뉴 탐색: 카테고리별(스마트폰, 노트북, 태블릿)로 정리된 메뉴를 통해 사용자가 원하는 상품을 쉽게 찾을 수 있습니다.
- 상품 리스트: 상품 별로 상품 이미지와 이름, 가격의 정보를 2x2 가로 스크롤 형태로 제공합니다.
- 장바구니: 선택한 상품들을 장바구니에 추가하고, 수량 조절 및 삭제가 가능합니다.
- 최종금액: 장바구니에 담긴 상품의 상품금액과 배송비를 포함한 최종금액을 제공합니다.
- 주문 시스템: 주문취소 및 주문하기 기능을 통해 장바구니가 채워져 있는 경우 초기화됩니다.

---

## 🧩 Trouble Shooting

### 1. 장바구니 UITableView의 스크롤 문제
- **문제**: 장바구니를 UITableView로 구현하면서 메인 스크롤뷰와 중첩되어 이중 스크롤이 발생함
- **원인**: 테이블뷰 자체의 스크롤과 외부 스크롤뷰가 충돌하면서 레이아웃 및 스크롤 동작에 문제가 생김
- **해결**: 테이블뷰의 스크롤을 비활성화하고, 셀 개수에 따라 테이블뷰의 높이를 동적으로 조정함

---

### 2. UI 병합 시 Git 충돌 문제
- **문제**: MainViewController, MainView 등 공통 UI 파일에서 Git merge 시 충돌이 잦게 발생함
- **원인**: 동일 화면에서 여러 명이 동시에 UI 작업을 하다 보니 병합 과정에서 충돌이 발생함
- **해결**: UI 담당 인원이 모여 화면 공유를 통해 충돌 파일을 함께 보며 직접 병합을 진행함

---

### 3. 컬렉션 뷰 셀 레이아웃 과대 문제
- **문제**: 상품 리스트의 이미지 셀 높이가 과도하게 커져 화면의 절반 이상을 차지하게 됨
- **원인**: itemSize를 1:1로 설정했지만 디바이스 화면에 비례하여 크기가 과도하게 커짐
- **해결**: 셀 전체는 1:1 비율을 유지하되, 내부 이미지 뷰의 height를 유동적으로 조정하여 개선함

---

### 4. 테이블뷰 셀 내 버튼 바인딩 구조 문제
- **문제**: 각 셀에 ViewModel을 개별로 할당하면서 구조가 복잡해지고 불필요한 메모리 사용이 발생함
- **원인**: 셀 재사용이 되는 UITableView에서 매번 새로운 ViewModel을 만드는 방식이 비효율적임
- **해결**: 셀의 이벤트 처리를 모두 MainViewModel로 일원화하고, 셀은 UI 역할만 담당하도록 분리함

---



