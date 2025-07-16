# Home Assistant Docker Compose 設定指南

## 簡介
Home Assistant 是一個開源的智能家居管理平台，支援超過 1000 種設備和服務的整合。提供自動化、監控和控制功能，讓您建立完整的智能家居系統。

## 主要功能

### 設備整合
- **超過 1000 種整合**: 支援主流智能家居品牌
- **自動發現**: 自動探測網路上的智能設備
- **Z-Wave/Zigbee**: 支援 Z-Wave 和 Zigbee 協議
- **MQTT**: 支援 MQTT 協議設備

### 自動化功能
- **規則引擎**: 強大的自動化規則設定
- **場景控制**: 一鍵切換不同場景
- **時間排程**: 基於時間的自動化觸發
- **狀態監控**: 即時設備狀態監控

### 用戶介面
- **響應式設計**: 支援手機、平板和桌面
- **自訂儀表板**: 可自訂的控制面板
- **主題支援**: 多種主題和外觀選項
- **語音控制**: 支援 Google Assistant、Amazon Alexa

## 服務組件

### 核心服務
- **Home Assistant**: 主要的智能家居管理平台
- **InfluxDB**: 長期資料儲存和分析
- **Grafana**: 資料視覺化和監控面板
- **Mosquitto**: MQTT 訊息代理服務

## 使用方法

### 1. 準備工作
在使用此設定檔之前，請確保：
- 已安裝 Docker 和 Docker Compose
- 準備好存放設定檔的目錄
- 了解您的智能設備和硬體配置

### 2. 修改設定
編輯 `homeassistant-docker-compose.yml` 檔案，修改以下項目：

**時區設定**：
```yaml
environment:
  - TZ=Asia/Taipei  # 替換為您的時區
```

**設備映射**：
```yaml
devices:
  - /dev/ttyUSB0:/dev/ttyUSB0  # 替換為您的 USB 設備
```

**媒體目錄**：
```yaml
volumes:
  - /path/to/your/media:/media  # 替換為您的媒體目錄
```

**資料庫密碼**：
```yaml
environment:
  - DOCKER_INFLUXDB_INIT_PASSWORD=your_secure_password_here
  - DOCKER_INFLUXDB_INIT_ADMIN_TOKEN=your_admin_token_here
```

### 3. 啟動服務
```bash
# 啟動所有服務
docker-compose -f homeassistant-docker-compose.yml up -d

# 查看服務狀態
docker-compose -f homeassistant-docker-compose.yml ps

# 查看 Home Assistant 日誌
docker-compose -f homeassistant-docker-compose.yml logs -f homeassistant
```

### 4. 存取服務
- **Home Assistant**: http://您的伺服器IP:8123
- **InfluxDB**: http://您的伺服器IP:8086
- **Grafana**: http://您的伺服器IP:3000
- **Mosquitto MQTT**: mqtt://您的伺服器IP:1883

## 設定說明

### 端口說明
- `8123`: Home Assistant Web UI 和 API 端口
- `8086`: InfluxDB Web UI 和 API 端口
- `3000`: Grafana Web UI 端口
- `1883`: MQTT 服務端口
- `9001`: MQTT over WebSocket 端口

### 卷映射
- `./homeassistant/config`: Home Assistant 設定檔案
- `./homeassistant/influxdb`: InfluxDB 資料和設定
- `./homeassistant/grafana`: Grafana 資料和設定
- `./homeassistant/mosquitto`: Mosquitto 設定和資料

### 設備存取
- `/dev`: 所有設備檔案存取
- `/dev/ttyUSB0`: USB 串列設備 (Zigbee/Z-Wave)
- `/dev/ttyACM0`: ACM 串列設備

## 初始設定

### 1. Home Assistant 初始設定
1. 開啟瀏覽器，前往 http://您的伺服器IP:8123
2. 建立管理員帳戶
3. 設定位置和時區
4. 完成歡迎精靈

### 2. InfluxDB 設定
1. 開啟瀏覽器，前往 http://您的伺服器IP:8086
2. 使用初始設定的帳戶登入
3. 建立 bucket 用於 Home Assistant 資料
4. 產生 API token 供 Home Assistant 使用

### 3. Grafana 設定
1. 開啟瀏覽器，前往 http://您的伺服器IP:3000
2. 使用 admin/your_password 登入
3. 新增 InfluxDB 資料源
4. 匯入 Home Assistant 儀表板範本

### 4. MQTT 設定
1. 編輯 `./homeassistant/mosquitto/config/mosquitto.conf`
2. 設定使用者認證和權限
3. 在 Home Assistant 中設定 MQTT 整合

## Home Assistant 整合設定

### 1. InfluxDB 整合
在 Home Assistant 的 `configuration.yaml` 中新增：

```yaml
influxdb:
  host: localhost
  port: 8086
  token: your_influxdb_token
  organization: homeassistant
  bucket: homeassistant
  measurement_attr: friendly_name
```

### 2. MQTT 整合
在 Home Assistant 中新增 MQTT 整合：
- Broker: localhost
- Port: 1883
- Username: (如果設定)
- Password: (如果設定)

### 3. 常用整合
```yaml
# 網路設備發現
discovery:

# 系統監控
system_monitor:

# 檔案系統監控
sensor:
  - platform: systemmonitor
    resources:
      - type: disk_use_percent
        arg: /config
      - type: memory_use_percent
      - type: processor_use

# 天氣資訊
weather:
  - platform: openweathermap
    api_key: your_openweathermap_api_key
    name: 當地天氣
```

## 硬體設備設定

### USB 設備識別
```bash
# 列出 USB 設備
lsusb

# 列出串列設備
ls -la /dev/tty*

# 檢查設備資訊
udevadm info -a -n /dev/ttyUSB0
```

### Zigbee 設備設定
1. 連接 Zigbee 適配器到 USB 端口
2. 確認設備路徑 (通常是 /dev/ttyUSB0)
3. 在 Home Assistant 中安裝 ZHA 或 Zigbee2MQTT 整合
4. 設定 Zigbee 協調器

### Z-Wave 設備設定
1. 連接 Z-Wave 適配器到 USB 端口
2. 在 Home Assistant 中安裝 Z-Wave JS 整合
3. 設定 Z-Wave 網路
4. 配對 Z-Wave 設備

## 自動化範例

### 1. 日出日落自動化
```yaml
automation:
  - alias: "日出開燈"
    trigger:
      platform: sun
      event: sunset
    action:
      service: light.turn_on
      target:
        entity_id: light.living_room
```

### 2. 溫度控制
```yaml
automation:
  - alias: "溫度控制"
    trigger:
      platform: numeric_state
      entity_id: sensor.temperature
      above: 25
    action:
      service: climate.set_temperature
      target:
        entity_id: climate.air_conditioner
      data:
        temperature: 22
```

### 3. 安全警報
```yaml
automation:
  - alias: "門窗警報"
    trigger:
      platform: state
      entity_id: binary_sensor.door_sensor
      to: 'on'
    condition:
      condition: state
      entity_id: alarm_control_panel.home_alarm
      state: 'armed_away'
    action:
      service: notify.mobile_app
      data:
        message: "門被打開了！"
```

## 疑難排解

### 常見問題

**1. 設備無法存取**
- 檢查 USB 設備權限
- 確認設備路徑正確
- 重新啟動容器

**2. 整合失敗**
- 檢查網路連線
- 確認 API 金鑰正確
- 查看 Home Assistant 日誌

**3. 效能問題**
- 增加記憶體限制
- 優化資料庫查詢
- 減少不必要的感測器

### 服務管理命令
```bash
# 停止服務
docker-compose -f homeassistant-docker-compose.yml down

# 重啟特定服務
docker-compose -f homeassistant-docker-compose.yml restart homeassistant

# 更新映像檔
docker-compose -f homeassistant-docker-compose.yml pull
docker-compose -f homeassistant-docker-compose.yml up -d

# 檢查設定檔語法
docker-compose -f homeassistant-docker-compose.yml exec homeassistant \
  python -m homeassistant --script check_config --config /config
```

### 資料備份
```bash
# 備份設定檔
tar -czf homeassistant-backup-$(date +%Y%m%d).tar.gz homeassistant/

# 備份資料庫
docker-compose -f homeassistant-docker-compose.yml exec influxdb \
  influx backup /var/lib/influxdb2/backup

# 恢復設定
tar -xzf homeassistant-backup-YYYYMMDD.tar.gz
```

## 進階功能

### 1. 自訂組件
將自訂組件放在 `./homeassistant/config/custom_components/` 目錄中

### 2. 主題設定
在 `./homeassistant/config/themes/` 目錄中新增自訂主題

### 3. 語音控制
整合 Google Assistant 或 Amazon Alexa 進行語音控制

### 4. 行動應用
下載 Home Assistant 行動應用程式進行遠端控制

## 安全建議
- 定期更新 Docker 映像檔
- 使用強密碼保護所有服務
- 啟用 HTTPS 和 SSL 證書
- 設定防火牆規則
- 定期備份設定和資料
- 監控系統資源使用情況
- 限制網路存取權限