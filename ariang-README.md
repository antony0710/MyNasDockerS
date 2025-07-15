# AriaNg + Aria2 Docker Compose 設定指南

## 簡介
AriaNg 是一個現代化的 Aria2 Web UI 前端，結合 Aria2 下載器提供完整的下載管理解決方案。適用於下載各種檔案，包括 HTTP/HTTPS、FTP、BitTorrent 和 Magnet 連結。

## 服務組件

### Aria2 下載器
- **功能**: 高效能多協議下載引擎
- **支援協議**: HTTP/HTTPS, FTP, SFTP, BitTorrent, Magnet
- **特色**: 多連接下載、斷點續傳、RPC 遠端控制

### AriaNg Web UI
- **功能**: 美觀直觀的 Web 管理介面
- **特色**: 響應式設計、即時狀態監控、檔案管理

## 使用方法

### 1. 準備工作
在使用此設定檔之前，請確保：
- 已安裝 Docker 和 Docker Compose
- 準備好存放下載檔案的目錄
- 了解您的系統用戶 ID (PUID) 和群組 ID (PGID)

### 2. 修改設定
編輯 `ariang-docker-compose.yml` 檔案，修改以下項目：

**RPC 密鑰**：
```yaml
environment:
  - RPC_SECRET=your_secret_key_here  # 替換為您的安全密鑰
```

**用戶權限**：
```yaml
environment:
  - PUID=1000  # 替換為您的用戶 ID
  - PGID=1000  # 替換為您的群組 ID
```

**下載目錄**：
```yaml
volumes:
  - ./aria2/downloads:/downloads  # 替換為您的下載目錄路徑
```

### 3. 啟動服務
```bash
# 啟動所有服務
docker-compose -f ariang-docker-compose.yml up -d

# 查看服務狀態
docker-compose -f ariang-docker-compose.yml ps

# 查看服務日誌
docker-compose -f ariang-docker-compose.yml logs -f
```

### 4. 存取服務
- **AriaNg Web UI**: http://您的伺服器IP:6880
- **Aria2 RPC**: http://您的伺服器IP:6800/jsonrpc

## 設定說明

### 環境變數
- `RPC_SECRET`: RPC 連接密鑰，用於安全驗證
- `RPC_PORT`: RPC 服務端口 (預設 6800)
- `LISTEN_PORT`: BitTorrent 監聽端口 (預設 6888)
- `DISK_CACHE`: 磁碟快取大小，提升下載效能
- `IPV6_MODE`: 是否啟用 IPv6 支援

### 端口說明
- `6880`: AriaNg Web UI 存取端口
- `6800`: Aria2 RPC 服務端口
- `6888`: BitTorrent DHT 端口 (TCP/UDP)

### 卷映射
- `./aria2/config`: Aria2 設定檔案存放位置
- `./aria2/downloads`: 下載檔案存放位置

## 首次設定

### 1. 存取 AriaNg Web UI
開啟瀏覽器，前往 http://您的伺服器IP:6880

### 2. 設定 Aria2 RPC 連接
1. 點選「AriaNg 設定」
2. 在「RPC」標籤中設定：
   - 主機: 您的伺服器 IP
   - 端口: 6800
   - 協議: http
   - 密鑰: 您在 docker-compose.yml 中設定的 RPC_SECRET

### 3. 開始下載
- 點選「新增」按鈕
- 輸入下載連結 (HTTP/HTTPS/FTP/Magnet)
- 選擇下載位置和選項
- 點選「開始」

## 進階設定

### 自訂 Aria2 設定
您可以將自訂的 `aria2.conf` 檔案放在 `./aria2/config` 目錄中：

```bash
# 建立設定目錄
mkdir -p ./aria2/config

# 編輯設定檔
nano ./aria2/config/aria2.conf
```

### 效能調整
編輯 docker-compose.yml 中的環境變數：
- `DISK_CACHE`: 增加磁碟快取 (建議 64M-256M)
- 調整 CPU 和記憶體限制

## 疑難排解

### 常見問題

**1. RPC 連接失敗**
- 檢查 RPC_SECRET 是否正確設定
- 確認防火牆設定允許 6800 端口
- 驗證 Aria2 服務是否正常運行

**2. 下載速度慢**
- 增加 `max-connection-per-server` 設定
- 調整 `DISK_CACHE` 大小
- 檢查網路頻寬和連接品質

**3. 檔案權限問題**
- 確認 PUID 和 PGID 設定正確
- 檢查下載目錄的權限設定
- 使用 `chown` 修正目錄權限

### 服務管理命令
```bash
# 停止服務
docker-compose -f ariang-docker-compose.yml down

# 重啟服務
docker-compose -f ariang-docker-compose.yml restart

# 更新映像檔
docker-compose -f ariang-docker-compose.yml pull
docker-compose -f ariang-docker-compose.yml up -d

# 查看資源使用情況
docker stats aria2-pro ariang
```

## 安全建議
- 定期更新 RPC_SECRET 密鑰
- 使用防火牆限制存取來源
- 定期備份設定檔案
- 監控下載活動和磁碟使用情況