# MyNasDockerS
Try To store the Yaml of my docker in NAS

## 🏗️ 新的資料夾結構 / New Folder Structure

MyNasDockerS 現在採用模組化結構，每個服務都有自己的資料夾：
MyNasDockerS now uses a modular structure with each service having its own folder:

```
MyNasDockerS/
├── docker-compose.yml          # 統一管理檔案 / Unified management file
├── install-all.sh              # 一鍵安裝腳本 / One-click installation script
├── ariang/                     # AriaNg + Aria2 下載管理器
│   ├── docker-compose.yml
│   └── README.md
├── homeassistant/              # Home Assistant 智能家居
│   ├── docker-compose.yml
│   └── README.md
├── immich/                     # Immich 照片管理
│   ├── docker-compose.yml
│   └── README.md
├── jellyfin/                   # Jellyfin 媒體伺服器
│   ├── docker-compose.yml
│   └── README.md
├── navidrome/                  # Navidrome 音樂伺服器
│   ├── docker-compose.yml
│   └── README.md
├── webtube/                    # WebTube 影片下載器
│   ├── docker-compose.yml
│   └── README.md
└── zigbee2mqtt/                # Zigbee2MQTT 橋接器
    ├── docker-compose.yml
    └── README.md
```

## 🚀 使用方法 / Usage

### 統一管理模式 / Unified Management Mode

使用根目錄的 `docker-compose.yml` 統一管理所有服務：
Use the root `docker-compose.yml` to manage all services:

```bash
# 啟動所有服務 / Start all services
docker-compose up -d

# 啟動特定服務 / Start specific service
docker-compose up -d jellyfin

# 停止所有服務 / Stop all services
docker-compose down

# 查看服務狀態 / View service status
docker-compose ps

# 查看服務日誌 / View service logs
docker-compose logs -f jellyfin
```

### 個別服務管理 / Individual Service Management

進入特定服務資料夾進行管理：
Enter specific service folder for management:

```bash
# 進入 Jellyfin 資料夾 / Enter Jellyfin folder
cd jellyfin

# 啟動 Jellyfin / Start Jellyfin
docker-compose up -d

# 停止 Jellyfin / Stop Jellyfin
docker-compose down
```

### 一鍵安裝腳本 / One-Click Installation Script

使用我們的一鍵安裝腳本快速部署所有服務：
Use our one-click installation script to quickly deploy all services:

```bash
chmod +x install-all.sh
./install-all.sh
```

腳本提供以下功能：
The script provides the following features:
- 個別服務安裝 / Individual service installation
- 統一管理模式 / Unified management mode
- 服務狀態監控 / Service status monitoring
- 一鍵更新所有服務 / One-click update all services

## 📋 可用的 Docker Compose 設定檔 / Available Docker Compose Configurations

### 1. 📺 Jellyfin 媒體伺服器 / Jellyfin Media Server
- **檔案**: `jellyfin/docker-compose.yml`
- **說明**: 完整的 Jellyfin 媒體伺服器 Docker Compose 設定
- **詳細文件**: 請參考 `jellyfin/README.md`
- **存取地址**: http://localhost:8096
- **特色功能**:
  - 支援硬體加速 (Intel/NVIDIA GPU)
  - 完整的中文註解說明
  - 適合 NAS 環境的設定
  - 健康檢查和自動重啟
  - 記憶體和 CPU 限制選項

### 2. ⬇️ AriaNg + Aria2 下載管理器 / AriaNg + Aria2 Download Manager
- **檔案**: `ariang/docker-compose.yml`
- **說明**: 高效能的多協議下載管理器，支援 HTTP/HTTPS、FTP、BitTorrent
- **詳細文件**: 請參考 `ariang/README.md`
- **存取地址**: http://localhost:6880
- **特色功能**:
  - 支援多種下載協議
  - 美觀的 Web 管理介面
  - 斷點續傳和多連接下載
  - RPC 遠端控制
  - 完整的中文註解說明

### 3. 🎬 WebTube 影片下載器 / WebTube Video Downloader
- **檔案**: `webtube/docker-compose.yml`
- **說明**: 基於 yt-dlp 的影片下載器，支援 1000+ 網站
- **詳細文件**: 請參考 `webtube/README.md`
- **存取地址**: http://localhost:8081
- **特色功能**:
  - 支援 YouTube、Bilibili、TikTok 等主流平台
  - 高品質影片和音訊下載
  - 自動字幕下載
  - 批次下載和播放清單支援
  - Redis 快取提升效能

### 4. 🎵 Navidrome 音樂伺服器 / Navidrome Music Server
- **檔案**: `navidrome/docker-compose.yml`
- **說明**: 現代化的音樂串流伺服器，支援 Subsonic API
- **詳細文件**: 請參考 `navidrome/README.md`
- **存取地址**: http://localhost:4533
- **特色功能**:
  - 支援多種音樂格式
  - 美觀的 Web 介面
  - 手機 App 支援
  - Last.fm 和 Spotify 整合
  - 多使用者和權限管理

### 5. 🏠 Home Assistant 智能家居 / Home Assistant Smart Home
- **檔案**: `homeassistant/docker-compose.yml`
- **說明**: 完整的智能家居管理平台，支援 1000+ 設備整合
- **詳細文件**: 請參考 `homeassistant/README.md`
- **存取地址**: 
  - Home Assistant: http://localhost:8123
  - InfluxDB: http://localhost:8086
  - Grafana: http://localhost:3000
- **特色功能**:
  - 超過 1000 種設備整合
  - 強大的自動化引擎
  - 響應式 Web 介面
  - InfluxDB 資料儲存
  - Grafana 視覺化監控

### 6. 🔄 Zigbee2MQTT 橋接器 / Zigbee2MQTT Bridge
- **檔案**: `zigbee2mqtt/docker-compose.yml`
- **說明**: Zigbee 到 MQTT 橋接器，支援 1000+ Zigbee 設備
- **詳細文件**: 請參考 `zigbee2mqtt/README.md`
- **存取地址**: 
  - Zigbee2MQTT: http://localhost:8080
  - Node-RED: http://localhost:1880
- **特色功能**:
  - 支援多品牌 Zigbee 設備
  - 視覺化網路地圖
  - 設備 OTA 更新
  - Node-RED 自動化平台
  - 完整的設備管理

### 7. 📷 Immich 照片管理 / Immich Photo Management
- **檔案**: `immich/docker-compose.yml`
- **說明**: 高效能的照片和影片管理平台，支援 AI 功能
- **詳細文件**: 請參考 `immich/README.md`
- **存取地址**: http://localhost:2283
- **特色功能**:
  - 自動備份和同步
  - AI 驅動的照片分類
  - 人臉識別和搜尋
  - 地理位置標記
  - 分享和相簿功能

## 📖 使用方法 / Usage Instructions

### 方法一：統一管理模式 (推薦) / Method 1: Unified Management Mode (Recommended)

```bash
# 1. 啟動所有服務 / Start all services
docker-compose up -d

# 2. 啟動特定服務 / Start specific service
docker-compose up -d jellyfin

# 3. 查看服務狀態 / Check service status
docker-compose ps

# 4. 停止所有服務 / Stop all services
docker-compose down
```

### 方法二：一鍵安裝腳本 / Method 2: One-Click Installation Script

```bash
# 1. 執行安裝腳本 / Run installation script
./install-all.sh

# 2. 選擇要安裝的服務 / Select services to install
# 3. 腳本會自動建立目錄和設定檔 / Script will automatically create directories and config files
```

### 方法三：個別服務管理 / Method 3: Individual Service Management

```bash
# 1. 進入服務資料夾 / Enter service folder
cd jellyfin

# 2. 根據您的環境修改設定 / Modify configuration according to your environment
# 3. 啟動服務 / Start service
docker-compose up -d
```

## 🛠️ 服務管理 / Service Management

### 統一管理方式 / Unified Management

```bash
# 查看所有服務狀態 / Check all services status
docker-compose ps

# 查看特定服務狀態 / Check specific service status
docker-compose ps jellyfin

# 查看服務日誌 / View service logs
docker-compose logs -f jellyfin

# 重啟特定服務 / Restart specific service
docker-compose restart jellyfin

# 更新所有服務 / Update all services
docker-compose pull
docker-compose up -d
```

### 個別服務管理 / Individual Service Management

```bash
# 進入服務資料夾 / Enter service folder
cd jellyfin

# 查看服務狀態 / Check service status
docker-compose ps

# 查看服務日誌 / View service logs
docker-compose logs -f

# 重啟服務 / Restart service
docker-compose restart

# 更新服務 / Update service
docker-compose pull
docker-compose up -d
```

### 停止服務 / Stop Services
```bash
# 停止特定服務 / Stop specific service
docker-compose -f service-name-docker-compose.yml down

# 停止所有服務 / Stop all services
./install-all.sh  # 選擇管理選項 / Select management option
```

### 更新服務 / Update Services
```bash
# 更新映像檔並重啟 / Update images and restart
docker-compose -f service-name-docker-compose.yml pull
docker-compose -f service-name-docker-compose.yml up -d
```

## 🔧 設定須知 / Configuration Notes

### 必要修改項目 / Required Modifications
1. **媒體路徑**: 修改 Jellyfin 和 Navidrome 的媒體目錄路徑
2. **下載路徑**: 修改 AriaNg 和 WebTube 的下載目錄路徑
3. **用戶權限**: 根據您的系統設定 PUID 和 PGID
4. **密碼設定**: 修改所有服務的預設密碼
5. **設備路徑**: 修改 Zigbee2MQTT 的 USB 設備路徑

### 端口對應 / Port Mapping
- **Jellyfin**: 8096
- **AriaNg**: 6880
- **WebTube**: 8081
- **Navidrome**: 4533
- **Home Assistant**: 8123
- **InfluxDB**: 8086
- **Grafana**: 3000
- **Zigbee2MQTT**: 8080
- **Node-RED**: 1880
- **MQTT**: 1883

## 🚨 注意事項 / Important Notes

### 安全建議 / Security Recommendations
- 定期更新 Docker 映像檔
- 使用強密碼保護所有服務
- 設定防火牆規則限制存取
- 定期備份設定檔案和資料

### 系統需求 / System Requirements
- **Docker**: 20.10 或更高版本
- **Docker Compose**: 1.29 或更高版本
- **記憶體**: 建議 4GB 或以上
- **儲存空間**: 建議 100GB 或以上
- **CPU**: 建議 2 核心或以上

### 疑難排解 / Troubleshooting
1. **權限問題**: 確認 PUID 和 PGID 設定正確
2. **端口衝突**: 檢查端口是否被其他服務占用
3. **設備存取**: 確認 USB 設備路徑和權限正確
4. **網路問題**: 檢查防火牆和網路設定

## 📚 相關資源 / Related Resources

- [Docker 官方文件](https://docs.docker.com/)
- [Docker Compose 官方文件](https://docs.docker.com/compose/)
- [Jellyfin 官方文件](https://jellyfin.org/docs/)
- [Home Assistant 官方文件](https://www.home-assistant.io/docs/)
- [Zigbee2MQTT 官方文件](https://www.zigbee2mqtt.io/)

## 🤝 貢獻 / Contributing

歡迎提交 Issue 和 Pull Request 來改善這個專案！
Welcome to submit Issues and Pull Requests to improve this project!

## 📄 授權 / License

本專案採用 MIT 授權 / This project is licensed under the MIT License.
