# WebTube Docker Compose 設定指南

## 簡介
WebTube (基於 MeTube) 是一個現代化的 YouTube 和其他影片平台下載器，提供美觀的 Web 介面。基於強大的 yt-dlp 引擎，支援數百個影片平台的下載。

## 主要功能

### 影片下載
- **多平台支援**: YouTube, Vimeo, TikTok, Bilibili 等 1000+ 網站
- **品質選擇**: 支援各種解析度和格式選擇
- **批次下載**: 支援播放清單和頻道下載
- **斷點續傳**: 支援暫停和恢復下載

### 音訊提取
- **格式轉換**: 支援 MP3, AAC, FLAC, OGG 等格式
- **品質調整**: 可選擇音訊品質和位元率
- **標籤資訊**: 自動提取歌曲標籤和封面

### 字幕支援
- **多語言字幕**: 支援自動和手動字幕下載
- **字幕格式**: 支援 SRT, VTT, ASS 等格式
- **嵌入選項**: 可選擇嵌入或單獨存儲字幕

## 使用方法

### 1. 準備工作
在使用此設定檔之前，請確保：
- 已安裝 Docker 和 Docker Compose
- 準備好存放下載檔案的目錄
- 了解您的系統用戶 ID (PUID) 和群組 ID (PGID)

### 2. 修改設定
編輯 `webtube-docker-compose.yml` 檔案，修改以下項目：

**用戶權限**：
```yaml
environment:
  - PUID=1000  # 替換為您的用戶 ID
  - PGID=1000  # 替換為您的群組 ID
```

**下載目錄**：
```yaml
volumes:
  - ./webtube/downloads:/downloads  # 替換為您的下載目錄路徑
```

**下載品質設定**：
```yaml
environment:
  - DOWNLOAD_QUALITY='best'  # 可選: best, worst, bestvideo+bestaudio
```

### 3. 啟動服務
```bash
# 啟動所有服務
docker-compose -f webtube-docker-compose.yml up -d

# 查看服務狀態
docker-compose -f webtube-docker-compose.yml ps

# 查看服務日誌
docker-compose -f webtube-docker-compose.yml logs -f webtube
```

### 4. 存取服務
- **WebTube Web UI**: http://您的伺服器IP:8081

## 設定說明

### 環境變數
- `DOWNLOAD_QUALITY`: 下載品質設定 (best/worst/bestvideo+bestaudio)
- `OUTPUT_TEMPLATE`: 輸出檔案名稱模板
- `AUDIO_FORMAT`: 音訊轉換格式 (mp3/aac/flac/ogg)
- `MAX_DOWNLOADS`: 最大併發下載數
- `DARK_MODE`: 啟用暗黑主題

### 端口說明
- `8081`: WebTube Web UI 存取端口

### 卷映射
- `./webtube/downloads`: 下載檔案存放位置
- `./webtube/config`: 設定檔案存放位置
- `./webtube/redis`: Redis 快取資料存放位置

## 使用指南

### 1. 存取 WebTube Web UI
開啟瀏覽器，前往 http://您的伺服器IP:8081

### 2. 下載影片
1. 在 URL 欄位中輸入影片連結
2. 選擇下載品質和格式
3. 點選「下載」按鈕
4. 監控下載進度

### 3. 下載音訊
1. 輸入影片連結
2. 選擇「僅音訊」選項
3. 選擇音訊格式 (MP3/AAC/FLAC)
4. 開始下載

### 4. 批次下載
1. 輸入播放清單或頻道連結
2. 選擇要下載的影片
3. 設定下載選項
4. 開始批次下載

## 進階設定

### 自訂 yt-dlp 選項
您可以透過 `YTDL_OPTIONS` 環境變數自訂 yt-dlp 選項：

```yaml
environment:
  - YTDL_OPTIONS='{
      "writesubtitles": true,
      "writeautomaticsub": true,
      "subtitleslangs": ["zh-TW", "zh-CN", "en"],
      "format": "best[height<=720]"
    }'
```

### 檔案名稱模板
自訂下載檔案的命名規則：

```yaml
environment:
  # 按頻道分類
  - OUTPUT_TEMPLATE='%(uploader)s/%(title)s.%(ext)s'
  
  # 按日期分類
  - OUTPUT_TEMPLATE='%(upload_date)s/%(title)s.%(ext)s'
  
  # 包含更多資訊
  - OUTPUT_TEMPLATE='%(uploader)s - %(title)s [%(id)s].%(ext)s'
```

### 效能優化
#### 啟用 Redis 快取
Redis 服務已包含在配置中，可提升重複下載的效能。

#### 調整併發數
```yaml
environment:
  - MAX_DOWNLOADS=5  # 增加併發下載數 (建議 3-5)
```

#### 資源限制
根據您的系統調整 CPU 和記憶體限制：

```yaml
deploy:
  resources:
    limits:
      cpus: '4.0'      # 增加 CPU 限制
      memory: 4G       # 增加記憶體限制
```

## 支援的網站
WebTube 支援超過 1000 個影片網站，包括：
- **影片平台**: YouTube, Vimeo, Dailymotion, Twitch
- **社群媒體**: TikTok, Instagram, Twitter, Facebook
- **中文平台**: Bilibili, YouKu, iQiyi, Douyin
- **教育平台**: Coursera, edX, Khan Academy
- **新聞媒體**: CNN, BBC, NBC, ABC

## 疑難排解

### 常見問題

**1. 下載失敗**
- 檢查影片連結是否正確
- 確認影片是否為私人或地區限制
- 查看容器日誌了解錯誤原因

**2. 檔案權限問題**
- 確認 PUID 和 PGID 設定正確
- 檢查下載目錄的權限設定
- 使用 `chown` 修正目錄權限

**3. 下載速度慢**
- 檢查網路連線品質
- 調整最大併發下載數
- 啟用 Redis 快取提升效能

### 服務管理命令
```bash
# 停止服務
docker-compose -f webtube-docker-compose.yml down

# 重啟服務
docker-compose -f webtube-docker-compose.yml restart

# 更新映像檔
docker-compose -f webtube-docker-compose.yml pull
docker-compose -f webtube-docker-compose.yml up -d

# 查看資源使用情況
docker stats webtube webtube-redis
```

### 日誌查看
```bash
# 即時查看日誌
docker-compose -f webtube-docker-compose.yml logs -f webtube

# 查看最近的日誌
docker-compose -f webtube-docker-compose.yml logs --tail=100 webtube
```

## 安全建議
- 定期更新 Docker 映像檔
- 使用防火牆限制存取來源
- 定期清理暫存檔案
- 監控磁碟空間使用情況
- 遵守相關平台的使用條款