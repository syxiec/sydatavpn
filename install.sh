#!/bin/bash
# Cài đặt XrayR với thông tin nhập từ người dùng (hỗ trợ nhiều node)

# Nhập thông tin chung
echo "Nhập tên trang web (Bản quyền 4gquocte.com không cần thêm https):"
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
  echo "Nhập loại node (1: VMess, 2: Trojan):"
  read NODE_TYPE_CHOICE
  
  # Xác định NodeType dựa trên lựa chọn
  if [ "$NODE_TYPE_CHOICE" == "1" ]; then
      NODE_TYPE_STR="V2ray"
  elif [ "$NODE_TYPE_CHOICE" == "2" ]; then
      NODE_TYPE_STR="Trojan"
  else
      echo "Lựa chọn không hợp lệ, mặc định là VMess (V2ray)."
      NODE_TYPE_STR="V2ray"
  fi
  
  echo "Nhập Node ID cho node thứ $i:"
  read NODE_ID

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

# Cài đặt XrayR (sử dụng phiên bản Việt hoá)
bash <(curl -Ls https://raw.githubusercontent.com/DauDau432/XrayR-release/main/install.sh)

# Tạo file cấu hình cho XrayR
cat > /etc/XrayR/config.yml <<EOF
Log:
  Level: info

DnsConfigPath: ./dns.json

Nodes:${node_configs}
EOF

# Khởi động lại XrayR để áp dụng cấu hình mới
XrayR restart

# Kích hoạt dịch vụ XrayR để tự khởi động cùng hệ thống
systemctl enable XrayR

echo "✅ XrayR đã được cài đặt và cấu hình tự khởi động thành công!"
