class AppState {
  final bool isProxying;            // 是否正在代理
  final String proxyAddress;        // 代理地址
  final int proxyPort;              // 代理端口

  AppState({
    this.isProxying = false,
    this.proxyAddress = '127.0.0.1',
    this.proxyPort = 8888,
  });

  AppState copyWith({
    bool? isProxying,
    String? proxyAddress,
    int? proxyPort,
  }) {
    return AppState(
      isProxying: isProxying ?? this.isProxying,
      proxyAddress: proxyAddress ?? this.proxyAddress,
      proxyPort: proxyPort ?? this.proxyPort,
    );
  }
}
