# Jellyfin Docker Compose 設定指南

## 簡介
Jellyfin 是一個開源的媒體伺服器軟體，可以讓您在家中或辦公室建立自己的媒體中心。此 Docker Compose 設定檔提供了完整的 Jellyfin 部署方案。

## 使用方法

### 1. 準備工作
在使用此設定檔之前，請確保：
- 已安裝 Docker 和 Docker Compose
- 準備好存放媒體檔案的目錄
- 了解您的系統用戶 ID (PUID) 和群組 ID (PGID)

### 2. 修改設定
編輯 `jellyfin-docker-compose.yml` 檔案，修改以下項目：

**媒體目錄路徑**：
```yaml
volumes:
  - /path/to/your/movies:/movies:ro      # 替換為您的電影目錄路徑
  - /path/to/your/tv:/tv:ro              # 替換為您的電視劇目錄路徑
  - /path/to/your/music:/music:ro        # 替換為您的音樂目錄路徑
  - /path/to/your/photos:/photos:ro      # 替換為您的照片目錄路徑
```

**用戶權限**：
```yaml
environment:
  - PUID=1000  # 替換為您的用戶 ID
  - PGID=1000  # 替換為您的群組 ID
```

**時區設定**：
```yaml
environment:
  - TZ=Asia/Taipei  # 替換為您的時區
```

### 3. 啟動服務
```bash
docker-compose -f jellyfin-docker-compose.yml up -d
```

### 4. 存取 Jellyfin
- 開啟網頁瀏覽器
- 前往 `http://您的伺服器IP:8096`
- 按照設定精靈完成初始設定

## 重要設定說明

### 網路模式
預設使用 `host` 網路模式，提供最佳效能。如果需要更好的網路隔離，可以：
1. 註解掉 `network_mode: host`
2. 取消註解 `ports` 部分

### 硬體加速
如果您的系統支援硬體加速：
- **Intel GPU**：取消註解 `devices` 部分
- **NVIDIA GPU**：取消註解 `runtime` 和相關環境變量

### 儲存空間
建議的目錄結構：
```
./jellyfin/
├── config/          # 設定檔案
├── cache/           # 快取檔案
└── logs/            # 日誌檔案
```

## 疑難排解

### 權限問題
如果遇到檔案權限問題：
```bash
# 檢查當前用戶 ID
id -u

# 檢查當前群組 ID
id -g

# 設定正確的權限
sudo chown -R 1000:1000 ./jellyfin/
```

### 埠口衝突
如果 8096 埠口被占用：
```yaml
ports:
  - "8097:8096"  # 使用其他埠口
```

### 記憶體使用
如果系統記憶體不足，可以取消註解記憶體限制設定：
```yaml
deploy:
  resources:
    limits:
      memory: 2G  # 根據系統調整
```

## 維護指令

### 檢查服務狀態
```bash
docker-compose -f jellyfin-docker-compose.yml ps
```

### 查看日誌
```bash
docker-compose -f jellyfin-docker-compose.yml logs -f jellyfin
```

### 重啟服務
```bash
docker-compose -f jellyfin-docker-compose.yml restart jellyfin
```

### 停止服務
```bash
docker-compose -f jellyfin-docker-compose.yml down
```

### 更新 Jellyfin
```bash
docker-compose -f jellyfin-docker-compose.yml pull
docker-compose -f jellyfin-docker-compose.yml up -d
```

## 支援的媒體格式
Jellyfin 支援多種媒體格式，包括：
- **影片**：MP4, MKV, AVI, MOV, WMV
- **音訊**：MP3, FLAC, AAC, OGG, WMA
- **圖片**：JPEG, PNG, GIF, BMP, TIFF

## 注意事項
- 請確保媒體檔案目錄有足夠的讀取權限
- 建議定期備份設定檔案
- 監控系統資源使用情況
- 保持 Jellyfin 版本更新以獲得最新功能和安全修復