# Navidrome Docker Compose 設定指南

## 簡介
Navidrome 是一個現代化的音樂串流伺服器，支援 Subsonic/Airsonic API，提供美觀的 Web 介面和手機應用程式支援。適合建立個人音樂庫和家庭音樂串流服務。

## 主要功能

### 音樂管理
- **多格式支援**: MP3, FLAC, OGG, M4A, AAC, WMA 等
- **智能掃描**: 自動掃描和組織音樂庫
- **標籤支援**: 支援 ID3 標籤和封面圖片
- **播放清單**: 支援 M3U, PLS 播放清單

### 串流功能
- **即時轉碼**: 動態轉碼以適應不同設備
- **多使用者**: 支援多用戶和權限管理
- **離線播放**: 支援音樂下載和離線播放
- **搜尋功能**: 強大的搜尋和篩選功能

### 外部整合
- **Last.fm**: 歌曲記錄和推薦
- **Spotify**: 音樂資訊和封面圖片
- **手機應用**: 支援多種 Subsonic 客戶端

## 使用方法

### 1. 準備工作
在使用此設定檔之前，請確保：
- 已安裝 Docker 和 Docker Compose
- 準備好音樂檔案目錄
- 了解您的系統用戶 ID (PUID) 和群組 ID (PGID)

### 2. 修改設定
編輯 `navidrome-docker-compose.yml` 檔案，修改以下項目：

**用戶權限**：
```yaml
environment:
  - PUID=1000  # 替換為您的用戶 ID
  - PGID=1000  # 替換為您的群組 ID
```

**音樂目錄**：
```yaml
volumes:
  - /path/to/your/music:/music:ro  # 替換為您的音樂目錄路徑
```

**外部服務整合**：
```yaml
environment:
  # Last.fm 整合
  - ND_LASTFM_APIKEY=your_lastfm_api_key
  - ND_LASTFM_SECRET=your_lastfm_secret
  
  # Spotify 整合
  - ND_SPOTIFY_ID=your_spotify_client_id
  - ND_SPOTIFY_SECRET=your_spotify_client_secret
```

### 3. 啟動服務
```bash
# 啟動服務
docker-compose -f navidrome-docker-compose.yml up -d

# 查看服務狀態
docker-compose -f navidrome-docker-compose.yml ps

# 查看服務日誌
docker-compose -f navidrome-docker-compose.yml logs -f navidrome
```

### 4. 存取服務
- **Navidrome Web UI**: http://您的伺服器IP:4533

## 設定說明

### 環境變數
- `ND_MUSICFOLDER`: 音樂檔案目錄路徑
- `ND_SCANSCHEDULE`: 音樂庫掃描間隔時間
- `ND_LOGLEVEL`: 日誌級別 (error/warn/info/debug/trace)
- `ND_SESSIONTIMEOUT`: 用戶會話超時時間
- `ND_DEFAULTTHEME`: 預設主題 (Dark/Light/Auto)
- `ND_DEFAULTLANGUAGE`: 預設語言

### 端口說明
- `4533`: Navidrome Web UI 和 API 存取端口

### 卷映射
- `/music`: 音樂檔案目錄 (唯讀)
- `./navidrome/data`: 資料庫和設定檔案存放位置
- `./navidrome/cache`: 快取檔案存放位置

## 初始設定

### 1. 首次登入
1. 開啟瀏覽器，前往 http://您的伺服器IP:4533
2. 建立管理員帳戶
3. 設定管理員密碼
4. 完成初始設定

### 2. 音樂庫掃描
1. 確保音樂檔案已放置在指定目錄中
2. 服務會自動掃描音樂檔案
3. 您可以在設定中手動觸發掃描

### 3. 用戶管理
1. 進入「設定」→「用戶」
2. 建立新用戶帳戶
3. 設定用戶權限和配額

## 手機應用程式

### 推薦的 Subsonic 客戶端
**Android**:
- **DSub**: 功能完整的 Subsonic 客戶端
- **Ultrasonic**: 開源 Subsonic 客戶端
- **Substreamer**: 簡潔易用的客戶端

**iOS**:
- **play:Sub**: 功能豐富的 iOS 客戶端
- **Amperfy**: 現代化的 iOS 音樂應用
- **Substreamer**: 跨平台客戶端

### 客戶端設定
1. 伺服器地址: http://您的伺服器IP:4533
2. 用戶名: 您的 Navidrome 用戶名
3. 密碼: 您的 Navidrome 密碼

## 進階設定

### 外部資料庫 (PostgreSQL)
如果您需要更高的效能，可以啟用 PostgreSQL 資料庫：

1. 取消註解 docker-compose.yml 中的 PostgreSQL 服務
2. 設定資料庫連接參數：
```yaml
environment:
  - ND_DBPATH=postgres://navidrome:your_password@postgres:5432/navidrome?sslmode=disable
```

### 反向代理設定
如果使用 Nginx 或 Apache 反向代理：

```yaml
environment:
  - ND_BASEURL=/navidrome  # 設定基礎 URL
```

### 轉碼設定
調整音訊轉碼設定以適應不同設備：

```yaml
environment:
  - ND_TRANSCODINGCACHESIZE=100MB  # 轉碼快取大小
  - ND_IMAGECACHESIZE=100MB        # 圖片快取大小
```

## 音樂檔案組織

### 建議的目錄結構
```
/music/
├── Artist1/
│   ├── Album1/
│   │   ├── 01 - Song1.mp3
│   │   ├── 02 - Song2.mp3
│   │   └── cover.jpg
│   └── Album2/
│       ├── 01 - Song3.flac
│       └── cover.jpg
└── Artist2/
    └── Album3/
        ├── 01 - Song4.m4a
        └── folder.jpg
```

### 標籤建議
- 確保 ID3 標籤完整 (Artist, Album, Title, Track)
- 使用一致的標籤格式
- 包含封面圖片 (cover.jpg, folder.jpg 或嵌入式)

## 疑難排解

### 常見問題

**1. 音樂檔案無法掃描**
- 檢查檔案權限和 PUID/PGID 設定
- 確認音樂目錄路徑正確
- 查看掃描日誌了解錯誤原因

**2. 轉碼失敗**
- 確認 FFmpeg 已正確安裝
- 檢查音訊格式是否支援
- 調整轉碼設定參數

**3. 外部整合無法運作**
- 檢查 API 金鑰設定
- 確認網路連線正常
- 查看服務日誌了解錯誤

### 服務管理命令
```bash
# 停止服務
docker-compose -f navidrome-docker-compose.yml down

# 重啟服務
docker-compose -f navidrome-docker-compose.yml restart

# 更新映像檔
docker-compose -f navidrome-docker-compose.yml pull
docker-compose -f navidrome-docker-compose.yml up -d

# 重新掃描音樂庫
docker-compose -f navidrome-docker-compose.yml exec navidrome /app/navidrome --scaninterval 0
```

### 資料備份
```bash
# 備份資料庫和設定
tar -czf navidrome-backup-$(date +%Y%m%d).tar.gz navidrome/

# 恢復資料
tar -xzf navidrome-backup-YYYYMMDD.tar.gz
```

## 效能調整

### 掃描設定
```yaml
environment:
  - ND_SCANSCHEDULE=@every 6h  # 每6小時掃描一次
  - ND_WATCHFORFOLDERSCHANGES=true  # 監控資料夾變化
```

### 快取設定
```yaml
environment:
  - ND_TRANSCODINGCACHESIZE=500MB  # 增加轉碼快取
  - ND_IMAGECACHESIZE=200MB        # 增加圖片快取
```

### 資源限制
根據您的系統調整資源限制：

```yaml
deploy:
  resources:
    limits:
      cpus: '2.0'    # 增加 CPU 限制
      memory: 1G     # 增加記憶體限制
```

## 安全建議
- 定期更新 Docker 映像檔
- 使用強密碼保護帳戶
- 啟用 HTTPS (通過反向代理)
- 定期備份設定和資料庫
- 監控系統資源使用情況