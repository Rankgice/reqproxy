class FilterState {
  final String searchKeyword;        // 搜索关键词
  final Set<String> contentTypes;    // 选中的内容类型 (e.g., {"JSON", "Image"})
  final Set<String> protocols;       // 选中的协议 (e.g., {"HTTP1", "Websocket"})
  final Set<String> statusCodes;     // 选中的状态码范围 (e.g., {"2xx", "4xx"})

  FilterState({
    this.searchKeyword = '',
    this.contentTypes = const {},
    this.protocols = const {},
    this.statusCodes = const {},
  });

  FilterState copyWith({
    String? searchKeyword,
    Set<String>? contentTypes,
    Set<String>? protocols,
    Set<String>? statusCodes,
  }) {
    return FilterState(
      searchKeyword: searchKeyword ?? this.searchKeyword,
      contentTypes: contentTypes ?? this.contentTypes,
      protocols: protocols ?? this.protocols,
      statusCodes: statusCodes ?? this.statusCodes,
    );
  }
}
