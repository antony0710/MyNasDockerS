# MyNasDockerS
Try To store the Yaml of my docker in NAS

## 可用的 Docker Compose 設定檔 / Available Docker Compose Configurations

### Jellyfin 媒體伺服器 / Jellyfin Media Server
- **檔案**: `jellyfin-docker-compose.yml`
- **說明**: 完整的 Jellyfin 媒體伺服器 Docker Compose 設定
- **詳細文件**: 請參考 `jellyfin-README.md`
- **特色功能**:
  - 支援硬體加速 (Intel/NVIDIA GPU)
  - 完整的中文註解說明
  - 適合 NAS 環境的設定
  - 健康檢查和自動重啟
  - 記憶體和 CPU 限制選項

## 使用方法
1. 選擇所需的服務設定檔
2. 根據您的環境修改設定
3. 使用 `docker-compose up -d` 啟動服務

## 注意事項
- 請確保修改路徑和權限設定
- 建議先閱讀相關的 README 文件
- 定期備份設定檔案
