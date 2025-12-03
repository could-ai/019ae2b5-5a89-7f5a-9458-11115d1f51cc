class VpnServer {
  final String name;
  final String flag; // Using emoji for simplicity
  final String ip;
  final String countryCode;

  VpnServer({
    required this.name,
    required this.flag,
    required this.ip,
    required this.countryCode,
  });

  static List<VpnServer> get defaultServers => [
    VpnServer(name: "United States", flag: "🇺🇸", ip: "192.168.1.101", countryCode: "US"),
    VpnServer(name: "United Kingdom", flag: "🇬🇧", ip: "192.168.1.102", countryCode: "GB"),
    VpnServer(name: "Germany", flag: "🇩🇪", ip: "192.168.1.103", countryCode: "DE"),
    VpnServer(name: "Japan", flag: "🇯🇵", ip: "192.168.1.104", countryCode: "JP"),
    VpnServer(name: "India", flag: "🇮🇳", ip: "192.168.1.105", countryCode: "IN"),
    VpnServer(name: "Singapore", flag: "🇸🇬", ip: "192.168.1.106", countryCode: "SG"),
    VpnServer(name: "Canada", flag: "🇨🇦", ip: "192.168.1.107", countryCode: "CA"),
    VpnServer(name: "Australia", flag: "🇦🇺", ip: "192.168.1.108", countryCode: "AU"),
  ];
}
