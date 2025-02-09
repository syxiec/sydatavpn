#!/bin/bash
# Cài đặt XrayR với thông tin nhập từ người dùng

echo "Nhập tên trang web (VD: https://example.com):"
read API_HOST

echo "Nhập Key (khoá giao tiếp):"
read API_KEY

echo "Nhập node ID VMess:"
read NODE_ID_1

echo "Nhập node ID Trojan:"
read NODE_ID_2

# Cài đặt XrayR
bash <(curl -Ls https://raw.githubusercontent.com/XrayR-project/XrayR-release/master/install.sh)

# Tạo file cấu hình XrayR
cat > /etc/XrayR/config.yml <<EOF
Log:
  Level: info

DnsConfigPath: ./dns.json

Nodes:
  - PanelType: "V2board"
    ApiConfig:
      ApiHost: "$API_HOST"
      ApiKey: "$API_KEY"
      NodeID: $NODE_ID_1
      NodeType: V2ray
    ControllerConfig:
      ListenIP: 0.0.0.0
      SendIP: 0.0.0.0
      UpdatePeriodic: 60

  - PanelType: "V2board"
    ApiConfig:
      ApiHost: "$API_HOST"
      ApiKey: "$API_KEY"
      NodeID: $NODE_ID_2
      NodeType: Trojan
    ControllerConfig:
      ListenIP: 0.0.0.0
      SendIP: 0.0.0.0
      UpdatePeriodic: 60

EOF

# Khởi động lại XrayR
XrayR restart

echo "✅ XrayR đã được cài đặt thành công!"
