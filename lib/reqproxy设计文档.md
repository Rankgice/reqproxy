# ReqProxy Flutter 前端详细设计文档

## 1. 项目概述

- **项目名称**: ReqProxy
- **目标**: 使用 Flutter 复刻 Reqable 的核心抓包与展示界面，实现一个跨平台的网络调试工具。
- **技术栈**: Flutter
- **设计原则**: 组件化、响应式、状态驱动。
- **核心功能 (V1)**:
    - 实时捕获并展示 HTTP/HTTPS 请求列表。
    - 对请求列表进行筛选和搜索。
    - 查看单个请求和响应的详细信息（如 Header, Body）。
    - 多会话（Tab）管理。

## 2. 核心数据模型 (Data Models)

这是整个应用的数据基础。

### 2.1. TrafficItem (网络请求条目)

这是列表中的每一行数据所对应的模型。

```dart
enum HttpMethod { GET, POST, PUT, DELETE, OPTIONS, HEAD, PATCH }
enum TrafficStatus { Running, Success, Failed, Pending }

class TrafficItem {
  final int id;                   // 唯一ID
  final HttpMethod method;        // 请求方法
  final String url;               // 完整的请求URL
  final Uri uri;                  // 解析后的URI对象，方便提取host, path等
  final int statusCode;           // 响应状态码 (e.g., 200, 404)
  final String statusMessage;     // 响应状态消息 (e.g., "OK", "Not Found")
  final String protocol;          // 协议 (e.g., "HTTP/1.1", "h2")
  final String clientIp;          // 客户端IP
  final String serverIp;          // 服务端IP
  final int requestBodySize;      // 请求体大小 (bytes)
  final int responseBodySize;     // 响应体大小 (bytes)
  final int duration;             // 请求耗时 (ms)
  final DateTime startTime;       // 请求开始时间
  final TrafficStatus status;     // 状态 (用于显示左侧小圆点颜色)

  // 详细信息 (在详情页展示)
  final Map<String, String> requestHeaders;
  final dynamic requestBody;
  final Map<String, String> responseHeaders;
  final dynamic responseBody;
  final String contentType;       // 响应的Content-Type

  // 构造函数...
}
```

### 2.2. FilterState (过滤器状态)

管理过滤栏的状态。

```dart
class FilterState {
  final String searchKeyword;        // 搜索关键词
  final Set<String> contentTypes;    // 选中的内容类型 (e.g., {"JSON", "Image"})
  final Set<String> protocols;       // 选中的协议 (e.g., {"HTTP1", "Websocket"})
  final Set<String> statusCodes;     // 选中的状态码范围 (e.g., {"2xx", "4xx"})
  // ... 其他过滤条件

  // 构造函数和 copyWith 方法...
}
```

### 2.3. AppState (应用全局状态)

管理代理状态等全局信息。

```dart
class AppState {
  final bool isProxying;            // 是否正在代理
  final String proxyAddress;        // 代理地址
  final int proxyPort;              // 代理端口
  // ... 其他全局设置
}
```

## 3. 整体 UI 布局与组件拆解

应用界面采用经典的多区域布局，从上到下，从左到右进行拆解。

### 3.1. CustomAppBar (顶部标题栏和菜单栏)

- **功能**: 提供应用级菜单操作和显示标题。
- **UI**:
    - **菜单栏**: 位于最顶部，由 `文件`, `工具`, `视图`, `代理`, `证书`, `帮助` 等文本按钮组成。
    - **标题栏**: 位于菜单栏下方，显示应用名称 "Reqable"。

### 3.2. MainPage (主页面骨架)

这是整个应用的根 Widget，使用 `Scaffold` 或自定义布局组件搭建。

- **布局**:
    - `Body`: 由左侧导航栏和右侧主内容区组成的水平布局 (`Row` 或 `SplitView`)。
    - `BottomAppBar`: 底部状态栏。

```text
MainPage
├── Row
│   ├── LeftSideNavBar (左侧图标导航栏)
│   └── MainContentArea (右侧主内容区)
└── BottomStatusBar (底部状态栏)
```

### 3.3. LeftSideNavBar (左侧图标导航栏)

- **功能**: 提供主要功能模块的快速切换。
- **UI**: 一个垂直排列的 `Column`，包含多个 `IconButton` 或自定义的图标按钮。
- **组件**: `NavIconButton` (可复用的图标按钮组件)。
- **状态**:
    - 管理当前选中的是哪个功能模块。
    - 点击后，通过回调或状态管理器通知 `MainContentArea` 切换显示内容。
- **图标 (从上到下)**:
    - `Icons.radar` (调试) - 当前视图
    - `Icons.folder_copy_outlined` (API 集合)
    - `Icons.rule` (规则)
    - `Icons.description` (脚本)
    - `Icons.history` (历史)
    - `Icons.sync_alt` (重写)
    - `Icons.settings_outlined` (设置) - 位于底部
    - `Icons.person_outline` (账户) - 位于底部

### 3.4. MainContentArea (右侧主内容区)

这是核心工作区，包含多个子组件。

- **布局**: 一个垂直的 `Column`。

```text
MainContentArea
├── CustomAppBar (应用标题栏)
├── ProxyStatusBar (代理状态栏)
├── SessionTabBar (会话标签栏)
├── FilterBar (过滤栏)
└── TrafficSplitView (流量上下分栏视图)
    ├── TrafficListView (上半部分: 流量列表)
    └── TrafficDetailView (下半部分: 流量详情)
```

### 3.5. ProxyStatusBar (代理状态栏)

- **功能**: 显示和控制代理服务的状态。
- **UI**:
    - **左侧**:
        - 状态指示灯 (绿色表示运行中)。
        - 文本: "Proxying on [IP]:[Port]"。
        - `IconButton` (编辑)。
        - `IconButton` (消息)。
        - `IconButton` (二维码)。
    - **右侧**:
        - 一系列功能开关 `IconButton` (重写、断点、脚本、隧道、下载、飞行模式、Https等)。
        - `ElevatedButton` "暂停/继续"。
        - `IconButton` "清空" (垃圾桶图标)。
- **状态**:
    - 接收 `AppState` 来显示代理状态、IP和端口。
    - 按钮点击会触发相应的全局动作 (例如调用 `ProxyService.start()`, `ProxyService.stop()`, `clearAllTraffic()`)。

### 3.6. SessionTabBar (会话标签栏)

- **功能**: 管理和切换不同的抓包会话。
- **UI**:
    - 使用 `TabBar` 实现。
    - 每个 Tab 是一个自定义 Widget，包含 `Icon`、`Text` (会话名称和请求数量)，例如 "调试(370)"。
    - 一个 `+` 按钮用于创建新会话。
- **状态**:
    - 管理一个 `List<Session>` 对象。
    - 管理当前激活的 Tab 索引。
    - 切换 Tab 时，会通知 `TrafficListView` 更新其数据源。

### 3.7. FilterBar (过滤栏)

- **功能**: 提供多种方式过滤流量列表。
- **UI**:
    - 一个水平 `Row` 布局。
    - **左侧**: 一系列的 `FilterChip` 或 `TextButton`，用于过滤协议、内容类型等。
        - `All`, `Http`, `Https`, `Websocket`, `HTTP1`, `HTTP2`, `JSON`, `XML`, `文本`, `HTML`, `JS`, `图片`, `媒体`, `二进制`。
        - `1xx`, `2xx`, `3xx`, `4xx`, `5xx`。
    - **右侧**: 一个 `IconButton` (搜索图标)。
- **状态**:
    - 与 `FilterState` 模型绑定。
    - 当任何过滤条件改变时，更新 `FilterState`，并通知 `TrafficListView` 重新应用过滤。

### 3.7. TrafficSplitView (流量上下分栏视图)

- **功能**: 使用可拖拽的分割线，将流量列表和详情视图分开。
- **实现**: 可以使用 `multi_split_view` 或类似功能的第三方包，或者自定义一个 `Column` + `GestureDetector` 实现。

### 3.9. TrafficListView (流量列表视图)

- **功能**: 以表格形式展示所有捕获到的网络请求。
- **实现**: 使用 `DataTable` Widget 实现表格布局。
- **UI**:
    - **`DataColumn` (表头)**: 包含 "ID", "图标", "方法", "URL" 等列标题，并支持点击排序。
    - **`DataRow` (数据行)**: 每一行对应一个 `TrafficItem`。
        - **单元格 (`DataCell`)**:
            - `StatusDot`: 左侧状态小圆点 (根据 `TrafficItem.status` 显示颜色)。
            - `Text` for ID。
            - `Icon` for Content-Type (例如 JSON 用 `{}` 图标，图片用图片图标)。
            - `Text` for Method。
            - `Text` for URL (需要进行截断处理)。
- **交互**:
    - 点击行时，更新应用状态，将当前选中的 `TrafficItem` 传递给 `TrafficDetailView`。
    - 被选中的行应有高亮背景。
- **状态**:
    - 接收一个 `List<TrafficItem>` 作为数据源。
    - 应用 `FilterState` 对数据源进行过滤和排序。
    - 管理当前选中的 `TrafficItem` 的 id。

### 3.9. TrafficDetailView (流量详情视图)

- **功能**: 展示被选中 `TrafficItem` 的请求和响应详情。
- **UI**:
    - 使用 `TabBar` 分为 "Request" 和 "Response" 两个标签页。
    - **Request Tab**:
        - `Headers`: 以键值对表格形式展示请求头。
        - `Body`: 根据 `Content-Type` 展示请求体。
            - `JSON`: 格式化高亮的 JSON 视图。
            - `Form`: 表格形式展示表单数据。
            - `Text`: 纯文本。
            - `Hex`: 十六进制视图。
    - **Response Tab**:
        - `Headers`: 展示响应头。
        - `Body`: 根据 `Content-Type` 展示响应体 (同上，增加图片、网页预览等视图)。
- **状态**:
    - 接收一个可空的 `TrafficItem?` 对象。如果为 `null`，则显示提示信息 "请选择一个请求查看详情"。
    - 当接收到新的 `TrafficItem` 时，更新所有子视图。

### 3.11. BottomStatusBar (底部状态栏)

- **功能**: 显示汇总信息和一些快捷操作。
- **UI**:
    - **左侧**: 布局切换图标 (`splitscreen` 和 `vertical_split`)。
    - **中间**: 文本 "共 XXX 项"。
    - **右侧**: 新版本提示、反馈、通知等图标按钮。
- **状态**:
    - 接收当前列表的总项目数和过滤后的项目数。

## 4. 状态管理策略 (建议)

推荐使用 **Riverpod**，因为它能很好地将业务逻辑与 UI 分离，并提供精细化的状态管理。

- **`ProxyServiceProvider` (`StateNotifierProvider`)**:
    - 管理代理服务的生命周期（启动、停止）。
    - 持有 `AppState`，并暴露给 UI。
- **`TrafficRepositoryProvider` (`Provider`)**:
    - 这是数据源的抽象。它负责从后端（无论是真实的 native 代理服务还是模拟数据）接收新的 `TrafficItem`。
    - 它会是一个 `StreamProvider`，UI 可以监听这个流来实时接收新的请求。
- **`AllTrafficProvider` (`StateNotifierProvider<List<TrafficItem>>`)**:
    - 持有所有捕获到的、未经过滤的 `TrafficItem` 列表。
    - 监听 `TrafficRepositoryProvider` 的流，并将新数据添加进来。
- **`FilterStateProvider` (`StateNotifierProvider<FilterState>`)**:
    - 管理 `FilterState` 对象。`FilterBar` 组件会与它交互。
- **`FilteredTrafficProvider` (`Provider`)**:
    - 这是派生状态，是整个设计的关键。
    - 它会 `watch` `AllTrafficProvider` 和 `FilterStateProvider`。
    - 当任何一个依赖项变化时，它会重新计算并返回一个过滤和排序后的 `List<TrafficItem>`。
    - `TrafficListView` 只需监听这个 `FilteredTrafficProvider` 即可。
- **`SelectedTrafficIdProvider` (`StateProvider<int?>`)**:
    - 管理当前在列表中被选中的 `TrafficItem` 的 ID。
    - `TrafficListItem` 的点击事件会更新这个 Provider。
- **`SelectedTrafficDetailProvider` (`Provider<TrafficItem?>`)**:
    - 另一个派生状态。
    - 它 `watch` `AllTrafficProvider` 和 `SelectedTrafficIdProvider`。
    - 根据 ID 从全量列表中查找对应的 `TrafficItem` 并返回。
    - `TrafficDetailView` 只需监听这个 Provider。

## 5. 建议的目录结构

```text
lib/
├── main.dart
│
├── core/
│   ├── models/                   # 数据模型
│   │   ├── traffic_item.dart
│   │   ├── filter_state.dart
│   │   └── app_state.dart
│   ├── providers/                # Riverpod Providers
│   │   ├── traffic_provider.dart
│   │   ├── proxy_provider.dart
│   │   └── filter_provider.dart
│   └── services/                 # 业务服务 (e.g., ProxyService)
│       └── proxy_service.dart
│
└── presentation/
    ├── pages/                    # 页面级组件
    │   └── main_page.dart
    ├── widgets/                  # 可复用的通用组件
    │   ├── custom_app_bar.dart
    │   ├── nav_icon_button.dart
    │   └── split_view.dart
    └── features/                 # 功能模块组件
        ├── sidebar/
        │   └── left_side_navbar.dart
        ├── status/
        │   ├── proxy_status_bar.dart
        │   └── bottom_status_bar.dart
        ├── traffic_list/
        │   ├── traffic_list_view.dart
        │   └── traffic_list_item.dart
        ├── traffic_detail/
        │   └── traffic_detail_view.dart
        ├── filter/
        │   └── filter_bar.dart
        └── session/
            └── session_tab_bar.dart
```

## 6. 下一步

1.  **搭建项目框架**: 根据上述目录结构创建文件和文件夹。
2.  **定义数据模型**: 在 `core/models/` 中创建 Dart 类。
3.  **开发静态 UI**: 从 `MainPage` 开始，自上而下地构建静态的 UI 组件，暂时使用假数据。
4.  **集成状态管理**: 引入 Riverpod，创建 Providers，并将 UI 组件与状态连接起来。
5.  **实现业务逻辑**: 填充 `ProxyService` 和 Providers 中的逻辑，替换假数据。

这份文档为你提供了一个非常坚实的起点。祝你开发顺利！
