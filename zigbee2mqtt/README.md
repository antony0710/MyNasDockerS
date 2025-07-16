# Zigbee2MQTT Docker Compose 設定指南

## 簡介
Zigbee2MQTT 是一個開源的 Zigbee 到 MQTT 橋接器，允許您使用 MQTT 協議控制 Zigbee 設備，無需依賴廠商的雲端服務。支援超過 1000 種 Zigbee 設備，提供本地化的智能家居解決方案。

## 主要功能

### Zigbee 設備支援
- **廣泛相容性**: 支援超過 1000 種 Zigbee 設備
- **多品牌支援**: 小米、IKEA、Philips、Tuya 等主流品牌
- **設備類型**: 燈泡、開關、感測器、門鎖、窗簾等
- **即時控制**: 低延遲的設備控制和狀態回報

### MQTT 整合
- **標準協議**: 使用 MQTT 協議進行設備通訊
- **Home Assistant 整合**: 無縫整合 Home Assistant
- **Node-RED 支援**: 支援 Node-RED 自動化平台
- **API 介面**: 提供 RESTful API 和 WebSocket

### 網路管理
- **網路地圖**: 視覺化 Zigbee 網路拓撲
- **設備管理**: 設備配對、移除和重新命名
- **OTA 更新**: 支援設備韌體無線更新
- **網路優化**: 自動路由優化和網路修復

## 服務組件

### 核心服務
- **Zigbee2MQTT**: 主要的 Zigbee 到 MQTT 橋接服務
- **Mosquitto**: MQTT 訊息代理服務
- **Node-RED**: 可選的自動化平台

## 硬體需求

### 支援的 Zigbee 適配器
- **Texas Instruments CC2652R/CC2531**: 推薦使用
- **ConBee/ConBee II**: Dresden Elektronik 出品
- **Sonoff Zigbee Bridge**: 刷機後使用
- **HUSBZB-1**: Nortek 雙協議適配器

### 推薦硬體
- **Sonoff Zigbee 3.0 USB Dongle Plus**: 性價比高
- **TI CC2652R**: 最佳效能和相容性
- **ConBee II**: 穩定可靠，商業級

## 使用方法

### 1. 準備工作
在使用此設定檔之前，請確保：
- 已安裝 Docker 和 Docker Compose
- 已連接 Zigbee 適配器到 USB 端口
- 確認 Zigbee 適配器設備路徑

### 2. 查找 Zigbee 適配器
```bash
# 列出 USB 設備
lsusb

# 查找串列設備
ls -la /dev/tty*

# 查找 USB 串列適配器
ls -la /dev/serial/by-id/
```

### 3. 修改設定
編輯 `zigbee2mqtt-docker-compose.yml` 檔案，修改以下項目：

**用戶權限**：
```yaml
environment:
  - PUID=1000  # 替換為您的用戶 ID
  - PGID=1000  # 替換為您的群組 ID
```

**Zigbee 適配器設備路徑**：
```yaml
devices:
  - /dev/ttyUSB0:/dev/ttyUSB0  # 替換為您的實際設備路徑
```

**MQTT 伺服器設定**：
```yaml
environment:
  - ZIGBEE2MQTT_CONFIG_MQTT_SERVER=mqtt://mqtt-broker:1883
```

### 4. 啟動服務
```bash
# 啟動所有服務
docker-compose -f zigbee2mqtt-docker-compose.yml up -d

# 查看服務狀態
docker-compose -f zigbee2mqtt-docker-compose.yml ps

# 查看 Zigbee2MQTT 日誌
docker-compose -f zigbee2mqtt-docker-compose.yml logs -f zigbee2mqtt
```

### 5. 存取服務
- **Zigbee2MQTT Web UI**: http://您的伺服器IP:8080
- **Node-RED**: http://您的伺服器IP:1880
- **MQTT Broker**: mqtt://您的伺服器IP:1883

## 設定說明

### 環境變數
- `ZIGBEE2MQTT_CONFIG_SERIAL_PORT`: Zigbee 適配器設備路徑
- `ZIGBEE2MQTT_CONFIG_MQTT_SERVER`: MQTT 伺服器地址
- `ZIGBEE2MQTT_CONFIG_FRONTEND_PORT`: Web UI 端口
- `ZIGBEE2MQTT_CONFIG_ADVANCED_LOG_LEVEL`: 日誌級別

### 端口說明
- `8080`: Zigbee2MQTT Web UI 存取端口
- `1883`: MQTT 服務端口
- `9001`: MQTT over WebSocket 端口
- `1880`: Node-RED Web UI 端口

### 卷映射
- `./zigbee2mqtt/data`: Zigbee2MQTT 設定和資料
- `./zigbee2mqtt/mosquitto`: Mosquitto 設定和資料
- `./zigbee2mqtt/nodered`: Node-RED 流程和設定

## 初始設定

### 1. 存取 Zigbee2MQTT Web UI
1. 開啟瀏覽器，前往 http://您的伺服器IP:8080
2. 檢查 Zigbee 適配器狀態
3. 查看網路資訊和設定

### 2. 設定 MQTT 認證 (可選)
編輯 `./zigbee2mqtt/mosquitto/config/mosquitto.conf`：

```conf
# 啟用認證
password_file /mosquitto/config/pwfile

# 設定 ACL
acl_file /mosquitto/config/acl

# 啟用 WebSocket
listener 9001
protocol websockets
```

建立密碼檔案：
```bash
# 進入 Mosquitto 容器
docker-compose -f zigbee2mqtt-docker-compose.yml exec mqtt-broker sh

# 建立使用者
mosquitto_passwd -c /mosquitto/config/pwfile admin
```

### 3. 配對 Zigbee 設備
1. 在 Web UI 中點選「Permit join」
2. 將 Zigbee 設備設為配對模式
3. 等待設備出現在設備列表中
4. 設定設備名稱和選項

## 設備管理

### 設備配對
1. 啟用配對模式：點選「Permit join」
2. 設備配對：依照設備說明書進行配對
3. 設備重命名：在設備列表中重新命名設備
4. 設定選項：調整設備特定選項

### 設備移除
1. 在設備列表中選擇要移除的設備
2. 點選「Remove」按鈕
3. 確認移除操作

### 設備控制
```bash
# 透過 MQTT 控制設備
mosquitto_pub -h localhost -t "zigbee2mqtt/light_living_room/set" -m '{"state": "ON"}'

# 查看設備狀態
mosquitto_sub -h localhost -t "zigbee2mqtt/light_living_room"
```

## 進階設定

### 自訂配置檔案
編輯 `./zigbee2mqtt/data/configuration.yaml`：

```yaml
# Zigbee2MQTT 設定
homeassistant: true
permit_join: false
mqtt:
  base_topic: zigbee2mqtt
  server: mqtt://mqtt-broker:1883
  user: admin
  password: your_password

# 序列埠設定
serial:
  port: /dev/ttyUSB0
  baudrate: 115200
  rtscts: false

# 前端設定
frontend:
  port: 8080
  host: 0.0.0.0

# 進階設定
advanced:
  log_level: info
  pan_id: 0x1a62
  channel: 11
  network_key: GENERATE
  availability_timeout: 60
  last_seen: ISO_8601
```

### 設備特定設定
```yaml
# 設備別名和選項
devices:
  '0x00158d0003267478':
    friendly_name: 'living_room_temperature'
    retain: true
    availability_timeout: 60
    debounce: 0.1
    
  '0x00158d000326747a':
    friendly_name: 'bedroom_switch'
    retain: false
    legacy: false
```

### 群組設定
```yaml
# 建立設備群組
groups:
  '1':
    friendly_name: living_room_lights
    devices:
      - 0x00158d0003267478
      - 0x00158d000326747a
```

## Home Assistant 整合

### 自動發現
在 Zigbee2MQTT 設定中啟用 Home Assistant 整合：

```yaml
homeassistant: true
```

### 手動設定
在 Home Assistant 的 `configuration.yaml` 中：

```yaml
mqtt:
  broker: localhost
  port: 1883
  username: admin
  password: your_password
  discovery: true
  discovery_prefix: homeassistant

# 自動化範例
automation:
  - alias: "Zigbee 設備離線警告"
    trigger:
      platform: mqtt
      topic: zigbee2mqtt/bridge/logging
    condition:
      condition: template
      value_template: "{{ 'offline' in trigger.payload_json.message }}"
    action:
      service: notify.mobile_app
      data:
        message: "{{ trigger.payload_json.message }}"
```

## 疑難排解

### 常見問題

**1. 設備無法配對**
- 確認配對模式已啟用
- 檢查設備是否在支援清單中
- 重置設備後重新配對
- 檢查 Zigbee 適配器是否正常工作

**2. 設備頻繁離線**
- 檢查 Zigbee 網路訊號強度
- 增加路由器設備
- 調整設備位置
- 更新設備韌體

**3. MQTT 連線問題**
- 檢查 MQTT 伺服器狀態
- 確認認證資訊正確
- 檢查網路連線
- 查看 MQTT 日誌

### 除錯命令
```bash
# 查看 Zigbee2MQTT 日誌
docker-compose -f zigbee2mqtt-docker-compose.yml logs -f zigbee2mqtt

# 查看 MQTT 訊息
mosquitto_sub -h localhost -t "zigbee2mqtt/bridge/logging"

# 檢查設備狀態
mosquitto_sub -h localhost -t "zigbee2mqtt/+/availability"

# 重啟 Zigbee 協調器
mosquitto_pub -h localhost -t "zigbee2mqtt/bridge/request/restart" -m ""
```

### 效能優化
```yaml
# 調整 Zigbee2MQTT 設定
advanced:
  # 減少日誌量
  log_level: warn
  
  # 優化網路設定
  channel: 11
  transmit_power: 5
  
  # 快取設定
  cache_state: true
  cache_state_persistent: true
  
  # 網路掃描
  network_key_distribute: true
```

## 網路管理

### 網路地圖
1. 在 Web UI 中查看「Map」頁面
2. 分析設備連接狀況
3. 識別網路弱點
4. 優化設備位置

### 設備韌體更新
1. 在 Web UI 中查看「OTA」頁面
2. 檢查可用更新
3. 選擇設備進行更新
4. 監控更新進度

### 網路備份
```bash
# 備份網路設定
cp ./zigbee2mqtt/data/coordinator_backup.json ./backup/
cp ./zigbee2mqtt/data/configuration.yaml ./backup/

# 恢復網路設定
cp ./backup/coordinator_backup.json ./zigbee2mqtt/data/
cp ./backup/configuration.yaml ./zigbee2mqtt/data/
```

## 安全建議
- 定期更新 Docker 映像檔
- 使用強密碼保護 MQTT 服務
- 啟用 MQTT 認證和 ACL
- 定期備份設定檔案
- 監控設備狀態和網路活動
- 使用防火牆限制存取
- 定期檢查設備韌體更新