# Immich Docker Compose 設定指南

## 簡介
Immich 是一個開源的自託管照片和影片管理解決方案，提供先進的 AI 功能，包括臉部識別、物件檢測、智慧搜尋等。它是 Google Photos 的完美替代品，讓您完全控制自己的媒體資料。

## 主要功能

### 媒體管理
- **照片上傳**: 支援多種照片格式 (JPEG, PNG, HEIC, RAW 等)
- **影片支援**: 支援多種影片格式和轉碼
- **自動備份**: 行動裝置自動備份功能
- **重複檢測**: 自動偵測並處理重複的媒體檔案

### AI 功能
- **臉部識別**: 自動識別和標記人物
- **物件檢測**: 識別照片中的物件和場景
- **智慧搜尋**: 基於 AI 的內容搜尋功能
- **地理位置**: 基於 GPS 資料的地圖檢視

### 多用戶支援
- **用戶管理**: 支援多個用戶帳戶
- **相簿共享**: 與其他用戶共享相簿
- **權限控制**: 細粒度的權限設定
- **個人化設定**: 每個用戶的個人化介面

## 服務組件

### 核心服務
- **Immich Server**: 主要的 Web 伺服器和 API 服務
- **Immich Machine Learning**: AI 功能處理服務
- **PostgreSQL**: 資料庫服務，儲存中繼資料
- **Redis**: 快取服務，提升效能

## 系統需求

### 硬體需求
- **CPU**: 多核心處理器 (建議 4 核心以上)
- **記憶體**: 最少 4GB RAM (建議 8GB 以上)
- **儲存空間**: 依照媒體資料量決定
- **GPU**: 可選，用於加速 AI 處理

### 軟體需求
- **Docker**: 版本 20.10 或更新
- **Docker Compose**: 版本 2.0 或更新
- **作業系統**: Linux, macOS, Windows (with WSL2)

## 使用方法

### 1. 準備工作
在使用此設定檔之前，請確保：
- 已安裝 Docker 和 Docker Compose
- 有足夠的儲存空間存放媒體檔案
- 設定適當的備份策略

### 2. 修改設定
編輯 `immich-docker-compose.yml` 檔案，修改以下項目：

**JWT 密鑰**：
```yaml
environment:
  - JWT_SECRET=your-jwt-secret-key-here  # 替換為安全的密鑰
```

**資料庫密碼**：
```yaml
environment:
  - DB_PASSWORD=postgres  # 替換為安全的密碼
  - POSTGRES_PASSWORD=postgres  # 同上
```

**時區設定**：
```yaml
environment:
  - TZ=Asia/Taipei  # 替換為您的時區
```

### 3. 建立必要目錄
```bash
# 建立資料儲存目錄
mkdir -p ./immich/upload
mkdir -p ./immich/config
mkdir -p ./immich/postgres
mkdir -p ./immich/redis
mkdir -p ./immich/model-cache
mkdir -p ./immich/shared

# 設定適當的權限
chmod 755 ./immich/upload
chmod 755 ./immich/config
```

### 4. 啟動服務
```bash
# 啟動所有服務
docker-compose -f immich-docker-compose.yml up -d

# 查看服務狀態
docker-compose -f immich-docker-compose.yml ps

# 查看 Immich 伺服器日誌
docker-compose -f immich-docker-compose.yml logs -f immich-server
```

### 5. 存取服務
- **Immich Web UI**: http://您的伺服器IP:2283
- **API 文件**: http://您的伺服器IP:2283/api/docs

## 初始設定

### 1. 建立管理員帳戶
1. 開啟瀏覽器，前往 http://您的伺服器IP:2283
2. 首次存取時會要求建立管理員帳戶
3. 填寫管理員資訊：
   - 電子郵件
   - 密碼
   - 姓名

### 2. 系統設定
1. 登入管理員帳戶
2. 進入「管理」→「系統設定」
3. 設定以下項目：
   - 儲存設定
   - 機器學習設定
   - 通知設定
   - 外部程式庫設定

### 3. 用戶管理
1. 進入「管理」→「用戶管理」
2. 新增用戶帳戶
3. 設定用戶配額和權限
4. 發送邀請連結

## 設定說明

### 環境變數
- `DB_HOSTNAME`: 資料庫主機名稱
- `DB_USERNAME`: 資料庫用戶名稱
- `DB_PASSWORD`: 資料庫密碼
- `DB_DATABASE_NAME`: 資料庫名稱
- `REDIS_HOSTNAME`: Redis 主機名稱
- `IMMICH_MACHINE_LEARNING_URL`: 機器學習服務 URL
- `JWT_SECRET`: JWT 密鑰，用於用戶認證

### 端口說明
- `2283`: Immich Web UI 存取端口
- `3001`: Immich 伺服器內部端口
- `3003`: 機器學習服務內部端口
- `5432`: PostgreSQL 資料庫內部端口
- `6379`: Redis 快取服務內部端口

### 卷映射
- `./immich/upload`: 上傳的照片和影片儲存位置
- `./immich/config`: 應用程式設定檔儲存位置
- `./immich/postgres`: PostgreSQL 資料庫檔案
- `./immich/redis`: Redis 快取檔案
- `./immich/model-cache`: AI 模型快取位置

## 媒體上傳

### Web 上傳
1. 登入 Immich Web UI
2. 點選「上傳」按鈕
3. 選擇照片或影片檔案
4. 等待上傳完成和處理

### 行動裝置上傳
1. 下載 Immich 行動應用程式
2. 設定伺服器連接資訊
3. 啟用自動備份功能
4. 選擇要備份的相簿

### 批次上傳
```bash
# 使用 Immich CLI 工具
docker run -it --rm \
  -v /path/to/photos:/media \
  ghcr.io/immich-app/immich-cli:latest \
  upload --server http://your-server:2283 --key your-api-key /media
```

## 進階功能

### 臉部識別設定
1. 進入「管理」→「機器學習」
2. 啟用臉部識別功能
3. 設定臉部識別模型
4. 開始處理現有照片

### 物件檢測設定
1. 進入「管理」→「機器學習」
2. 啟用物件檢測功能
3. 設定檢測模型
4. 配置檢測閾值

### 智慧搜尋
1. 在搜尋欄位輸入關鍵字
2. 搜尋人物、物件、地點
3. 使用日期範圍篩選
4. 儲存常用搜尋條件

### 相簿管理
```bash
# 建立相簿
# 透過 Web UI 或 API 建立

# 共享相簿
# 在相簿設定中啟用共享功能
```

## 備份策略

### 資料備份
```bash
# 備份 PostgreSQL 資料庫
docker-compose -f immich-docker-compose.yml exec immich-postgres pg_dump -U postgres immich > immich_backup.sql

# 備份媒體檔案
tar -czf immich_media_backup.tar.gz ./immich/upload/

# 備份設定檔
tar -czf immich_config_backup.tar.gz ./immich/config/
```

### 自動備份腳本
```bash
#!/bin/bash
# 自動備份腳本

BACKUP_DIR="/backup/immich"
DATE=$(date +%Y%m%d_%H%M%S)

# 建立備份目錄
mkdir -p $BACKUP_DIR

# 備份資料庫
docker-compose -f immich-docker-compose.yml exec -T immich-postgres pg_dump -U postgres immich > $BACKUP_DIR/immich_db_$DATE.sql

# 備份媒體檔案
tar -czf $BACKUP_DIR/immich_media_$DATE.tar.gz ./immich/upload/

# 清理舊備份
find $BACKUP_DIR -name "*.sql" -mtime +7 -delete
find $BACKUP_DIR -name "*.tar.gz" -mtime +7 -delete
```

## 疑難排解

### 常見問題

**1. 上傳失敗**
- 檢查檔案格式是否支援
- 確認儲存空間是否足夠
- 檢查檔案權限設定
- 查看伺服器日誌

**2. AI 功能無法使用**
- 確認機器學習服務是否正常運行
- 檢查模型是否下載完成
- 確認系統資源是否足夠
- 重新啟動機器學習服務

**3. 效能問題**
- 增加系統記憶體
- 使用 SSD 儲存
- 調整 PostgreSQL 設定
- 啟用 Redis 快取

**4. 資料庫連線問題**
- 檢查 PostgreSQL 服務狀態
- 確認資料庫密碼正確
- 檢查網路連接設定
- 查看資料庫日誌

### 除錯命令
```bash
# 查看 Immich 伺服器日誌
docker-compose -f immich-docker-compose.yml logs -f immich-server

# 查看機器學習服務日誌
docker-compose -f immich-docker-compose.yml logs -f immich-machine-learning

# 查看資料庫日誌
docker-compose -f immich-docker-compose.yml logs -f immich-postgres

# 檢查資料庫連線
docker-compose -f immich-docker-compose.yml exec immich-postgres psql -U postgres -d immich -c "SELECT version();"

# 檢查 Redis 狀態
docker-compose -f immich-docker-compose.yml exec immich-redis redis-cli ping
```

### 效能優化
```yaml
# PostgreSQL 效能調整
environment:
  - POSTGRES_INITDB_ARGS='--data-checksums'
  - shared_preload_libraries=pg_stat_statements
  - max_connections=100
  - shared_buffers=256MB
  - effective_cache_size=1GB
  - maintenance_work_mem=64MB
  - checkpoint_completion_target=0.9
  - wal_buffers=16MB
  - default_statistics_target=100
```

## 維護作業

### 定期維護
1. **更新 Docker 映像檔**
   ```bash
   docker-compose -f immich-docker-compose.yml pull
   docker-compose -f immich-docker-compose.yml up -d
   ```

2. **清理未使用的資源**
   ```bash
   docker system prune -a
   ```

3. **資料庫維護**
   ```bash
   # 重建索引
   docker-compose -f immich-docker-compose.yml exec immich-postgres psql -U postgres -d immich -c "REINDEX DATABASE immich;"
   
   # 清理統計資料
   docker-compose -f immich-docker-compose.yml exec immich-postgres psql -U postgres -d immich -c "ANALYZE;"
   ```

### 監控建議
- 監控儲存空間使用率
- 追蹤系統資源使用情況
- 定期檢查應用程式日誌
- 設定自動備份驗證
- 監控用戶活動和存取模式

## 安全建議
- 使用強密碼保護所有帳戶
- 定期更新 Docker 映像檔
- 啟用 HTTPS 加密連接
- 設定適當的網路防火牆
- 定期備份重要資料
- 限制管理員權限
- 啟用雙因素認證 (如果支援)
- 定期稽核用戶權限和存取記錄