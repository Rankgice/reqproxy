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

  TrafficItem({
    required this.id,
    required this.method,
    required this.url,
    required this.uri,
    required this.statusCode,
    required this.statusMessage,
    required this.protocol,
    required this.clientIp,
    required this.serverIp,
    required this.requestBodySize,
    required this.responseBodySize,
    required this.duration,
    required this.startTime,
    required this.status,
    required this.requestHeaders,
    this.requestBody,
    required this.responseHeaders,
    this.responseBody,
    required this.contentType,
  });
}
