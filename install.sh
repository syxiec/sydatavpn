#!/bin/bash
# Cài đặt XrayR với thông tin nhập từ người dùng (hỗ trợ nhiều node)

# Nhập thông tin chung
echo "Nhập tên trang web (Bản quyền:4gquocte.com không cần thêm https):"
read API_HOST_INPUT

# Nếu không có giao thức, tự động thêm https://
if [[ "$API_HOST_INPUT" != http://* && "$API_HOST_INPUT" != https://* ]]; then
    API_HOST="https://$API_HOST_INPUT"
else
    API_HOST="$API_HOST_INPUT"
fi

echo "Nhập Key (khoá giao tiếp):"
read API_KEY

echo "Nhập số lượng node cần cài:"
read NODE_COUNT

# Biến chứa cấu hình cho các node
node_configs=""

# Lặp để lấy thông tin cho từng node
for ((i=1; i<=NODE_COUNT; i++)); do
  echo "----- Node thứ $i -----"
  echo "Nhập loại node (VMess hoặc Trojan):"
  read NODE_TYPE
  echo "Nhập Node ID cho node thứ $i:"
  read NODE_ID
  
  # Xác định NodeType trong cấu hình
  if [[ "$NODE_TYPE" == "VMess" || "$NODE_TYPE" == "vmess" ]]; then
      NODE_TYPE_STR="V2ray"
  elif [[ "$NODE_TYPE" == "Trojan" || "$NODE_TYPE" == "trojan" ]]; then
      NODE_TYPE_STR="Trojan"
  else
      echo "Loại node không hợp lệ, mặc định là VMess (V2ray)."
      NODE_TYPE_STR="V2ray"
  fi

  # Thêm cấu hình node vào biến node_configs
  node_configs="$node_configs
  - PanelType: \"V2board\"
    ApiConfig:
      ApiHost: \"$API_HOST\"
      ApiKey: \"$API_KEY\"
      NodeID: $NODE_ID
      NodeType: $NODE_TYPE_STR
    ControllerConfig:
      ListenIP: 0.0.0.0
      SendIP: 0.0.0.0
      UpdatePeriodic: 60
"
done

# Cài đặt XrayR (tải script cài đặt từ dự án chính thức)
bash <(curl -Ls https://raw.githubusercontent.com/XrayR-project/XrayR-release/master/install.sh)

# Tạo file cấu hình cho XrayR
cat > /etc/XrayR/config.yml <<EOF
Log:
  Level: info

DnsConfigPath: ./dns.json

Nodes:${node_configs}
EOF

# Khởi động lại XrayR để áp dụng cấu hình mới
XrayR restart

echo "✅ XrayR đã được cài đặt thành công!"
