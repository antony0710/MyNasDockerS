#!/bin/bash

# MyNasDockerS 一鍵安裝腳本 / MyNasDockerS One-Click Installation Script
# 此腳本可以快速部署所有 Docker Compose 服務
# This script can quickly deploy all Docker Compose services

# 顏色定義 / Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 函數定義 / Function definitions
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}================================${NC}"
}

# 檢查系統需求 / Check system requirements
check_requirements() {
    print_header "檢查系統需求 / Checking System Requirements"
    
    # 檢查 Docker 是否安裝
    # Check if Docker is installed
    if ! command -v docker &> /dev/null; then
        print_error "Docker 尚未安裝。請先安裝 Docker。"
        print_error "Docker is not installed. Please install Docker first."
        exit 1
    fi
    
    # 檢查 Docker Compose 是否安裝
    # Check if Docker Compose is installed
    if ! command -v docker-compose &> /dev/null; then
        print_error "Docker Compose 尚未安裝。請先安裝 Docker Compose。"
        print_error "Docker Compose is not installed. Please install Docker Compose first."
        exit 1
    fi
    
    # 檢查 Docker 服務是否運行
    # Check if Docker service is running
    if ! systemctl is-active --quiet docker; then
        print_warning "Docker 服務未運行，嘗試啟動..."
        print_warning "Docker service is not running, attempting to start..."
        sudo systemctl start docker
        if [ $? -ne 0 ]; then
            print_error "無法啟動 Docker 服務"
            print_error "Failed to start Docker service"
            exit 1
        fi
    fi
    
    print_success "系統需求檢查完成 / System requirements check completed"
}

# 建立必要目錄 / Create necessary directories
create_directories() {
    print_header "建立必要目錄 / Creating Necessary Directories"
    
    # 服務目錄列表 / Service directory list
    local dirs=(
        "jellyfin/config"
        "jellyfin/cache"
        "aria2/config"
        "aria2/downloads"
        "webtube/downloads"
        "webtube/config"
        "webtube/redis"
        "navidrome/data"
        "navidrome/cache"
        "homeassistant/config"
        "homeassistant/influxdb/data"
        "homeassistant/influxdb/config"
        "homeassistant/grafana/data"
        "homeassistant/grafana/config"
        "homeassistant/mosquitto/config"
        "homeassistant/mosquitto/data"
        "homeassistant/mosquitto/log"
        "zigbee2mqtt/data"
        "zigbee2mqtt/mosquitto/config"
        "zigbee2mqtt/mosquitto/data"
        "zigbee2mqtt/mosquitto/log"
        "zigbee2mqtt/nodered"
    )
    
    # 建立所有目錄 / Create all directories
    for dir in "${dirs[@]}"; do
        mkdir -p "$dir"
        print_info "建立目錄 / Created directory: $dir"
    done
    
    # 設定目錄權限 / Set directory permissions
    chown -R $USER:$USER .
    chmod -R 755 .
    
    print_success "目錄建立完成 / Directory creation completed"
}

# 建立預設設定檔 / Create default configuration files
create_default_configs() {
    print_header "建立預設設定檔 / Creating Default Configuration Files"
    
    # Mosquitto 設定檔 / Mosquitto configuration
    cat > homeassistant/mosquitto/config/mosquitto.conf << EOF
# Mosquitto 設定檔 / Mosquitto configuration file
persistence true
persistence_location /mosquitto/data/
log_dest file /mosquitto/log/mosquitto.log
log_dest stdout

# 允許匿名連接 (生產環境建議啟用認證)
# Allow anonymous connections (authentication recommended for production)
allow_anonymous true

# 監聽端口 / Listen ports
listener 1883
listener 9001
protocol websockets
EOF

    # 複製給 Zigbee2MQTT 使用 / Copy for Zigbee2MQTT use
    cp homeassistant/mosquitto/config/mosquitto.conf zigbee2mqtt/mosquitto/config/

    print_success "預設設定檔建立完成 / Default configuration files created"
}

# 顯示服務選單 / Display service menu
show_menu() {
    print_header "MyNasDockerS 服務選單 / MyNasDockerS Service Menu"
    echo "請選擇要安裝的服務 / Please select services to install:"
    echo ""
    echo "1. Jellyfin (媒體伺服器 / Media Server)"
    echo "2. AriaNg + Aria2 (下載管理器 / Download Manager)"
    echo "3. WebTube (影片下載器 / Video Downloader)"
    echo "4. Navidrome (音樂伺服器 / Music Server)"
    echo "5. Home Assistant (智能家居 / Smart Home)"
    echo "6. Zigbee2MQTT (Zigbee 橋接器 / Zigbee Bridge)"
    echo "7. 安裝所有服務 / Install All Services"
    echo "8. 自訂安裝 / Custom Installation"
    echo "9. 退出 / Exit"
    echo ""
}

# 服務部署函數 / Service deployment functions
deploy_jellyfin() {
    print_info "部署 Jellyfin 媒體伺服器 / Deploying Jellyfin Media Server"
    
    # 提示用戶修改媒體路徑 / Prompt user to modify media paths
    print_warning "請在啟動前修改 jellyfin-docker-compose.yml 中的媒體路徑"
    print_warning "Please modify media paths in jellyfin-docker-compose.yml before starting"
    
    read -p "是否繼續部署？(y/n) / Continue deployment? (y/n): " confirm
    if [[ $confirm == [yY] ]]; then
        docker-compose -f jellyfin-docker-compose.yml up -d
        print_success "Jellyfin 部署完成 / Jellyfin deployment completed"
        print_info "存取地址 / Access URL: http://localhost:8096"
    fi
}

deploy_ariang() {
    print_info "部署 AriaNg + Aria2 下載管理器 / Deploying AriaNg + Aria2 Download Manager"
    
    # 提示用戶修改 RPC 密鑰 / Prompt user to modify RPC secret
    print_warning "請在啟動前修改 ariang-docker-compose.yml 中的 RPC_SECRET"
    print_warning "Please modify RPC_SECRET in ariang-docker-compose.yml before starting"
    
    read -p "是否繼續部署？(y/n) / Continue deployment? (y/n): " confirm
    if [[ $confirm == [yY] ]]; then
        docker-compose -f ariang-docker-compose.yml up -d
        print_success "AriaNg + Aria2 部署完成 / AriaNg + Aria2 deployment completed"
        print_info "存取地址 / Access URL: http://localhost:6880"
    fi
}

deploy_webtube() {
    print_info "部署 WebTube 影片下載器 / Deploying WebTube Video Downloader"
    
    read -p "是否繼續部署？(y/n) / Continue deployment? (y/n): " confirm
    if [[ $confirm == [yY] ]]; then
        docker-compose -f webtube-docker-compose.yml up -d
        print_success "WebTube 部署完成 / WebTube deployment completed"
        print_info "存取地址 / Access URL: http://localhost:8081"
    fi
}

deploy_navidrome() {
    print_info "部署 Navidrome 音樂伺服器 / Deploying Navidrome Music Server"
    
    # 提示用戶修改音樂路徑 / Prompt user to modify music path
    print_warning "請在啟動前修改 navidrome-docker-compose.yml 中的音樂路徑"
    print_warning "Please modify music path in navidrome-docker-compose.yml before starting"
    
    read -p "是否繼續部署？(y/n) / Continue deployment? (y/n): " confirm
    if [[ $confirm == [yY] ]]; then
        docker-compose -f navidrome-docker-compose.yml up -d
        print_success "Navidrome 部署完成 / Navidrome deployment completed"
        print_info "存取地址 / Access URL: http://localhost:4533"
    fi
}

deploy_homeassistant() {
    print_info "部署 Home Assistant 智能家居 / Deploying Home Assistant Smart Home"
    
    # 提示用戶修改密碼 / Prompt user to modify passwords
    print_warning "請在啟動前修改 homeassistant-docker-compose.yml 中的密碼"
    print_warning "Please modify passwords in homeassistant-docker-compose.yml before starting"
    
    read -p "是否繼續部署？(y/n) / Continue deployment? (y/n): " confirm
    if [[ $confirm == [yY] ]]; then
        docker-compose -f homeassistant-docker-compose.yml up -d
        print_success "Home Assistant 部署完成 / Home Assistant deployment completed"
        print_info "存取地址 / Access URLs:"
        print_info "  - Home Assistant: http://localhost:8123"
        print_info "  - InfluxDB: http://localhost:8086"
        print_info "  - Grafana: http://localhost:3000"
    fi
}

deploy_zigbee2mqtt() {
    print_info "部署 Zigbee2MQTT 橋接器 / Deploying Zigbee2MQTT Bridge"
    
    # 檢查 USB 設備 / Check USB devices
    print_info "檢查 USB 設備 / Checking USB devices:"
    ls -la /dev/tty* | grep -E "(USB|ACM)"
    
    print_warning "請確認 Zigbee 適配器已連接並修改 zigbee2mqtt-docker-compose.yml 中的設備路徑"
    print_warning "Please ensure Zigbee adapter is connected and modify device path in zigbee2mqtt-docker-compose.yml"
    
    read -p "是否繼續部署？(y/n) / Continue deployment? (y/n): " confirm
    if [[ $confirm == [yY] ]]; then
        docker-compose -f zigbee2mqtt-docker-compose.yml up -d
        print_success "Zigbee2MQTT 部署完成 / Zigbee2MQTT deployment completed"
        print_info "存取地址 / Access URLs:"
        print_info "  - Zigbee2MQTT: http://localhost:8080"
        print_info "  - Node-RED: http://localhost:1880"
    fi
}

# 部署所有服務 / Deploy all services
deploy_all() {
    print_info "開始部署所有服務 / Starting deployment of all services"
    
    read -p "確認部署所有服務？(y/n) / Confirm deployment of all services? (y/n): " confirm
    if [[ $confirm == [yY] ]]; then
        deploy_jellyfin
        sleep 2
        deploy_ariang
        sleep 2
        deploy_webtube
        sleep 2
        deploy_navidrome
        sleep 2
        deploy_homeassistant
        sleep 2
        deploy_zigbee2mqtt
        
        print_success "所有服務部署完成 / All services deployment completed"
        show_access_info
    fi
}

# 自訂安裝 / Custom installation
custom_install() {
    print_info "自訂安裝模式 / Custom installation mode"
    
    local services=()
    
    echo "請選擇要安裝的服務 (用空格分隔多個選項) / Please select services to install (separate multiple options with spaces):"
    echo "1=Jellyfin 2=AriaNg 3=WebTube 4=Navidrome 5=Home Assistant 6=Zigbee2MQTT"
    read -p "輸入選項 / Enter options: " selections
    
    for selection in $selections; do
        case $selection in
            1) services+=("jellyfin");;
            2) services+=("ariang");;
            3) services+=("webtube");;
            4) services+=("navidrome");;
            5) services+=("homeassistant");;
            6) services+=("zigbee2mqtt");;
        esac
    done
    
    print_info "將安裝以下服務 / Will install the following services: ${services[*]}"
    
    read -p "確認安裝？(y/n) / Confirm installation? (y/n): " confirm
    if [[ $confirm == [yY] ]]; then
        for service in "${services[@]}"; do
            case $service in
                "jellyfin") deploy_jellyfin;;
                "ariang") deploy_ariang;;
                "webtube") deploy_webtube;;
                "navidrome") deploy_navidrome;;
                "homeassistant") deploy_homeassistant;;
                "zigbee2mqtt") deploy_zigbee2mqtt;;
            esac
            sleep 2
        done
        
        print_success "自訂安裝完成 / Custom installation completed"
        show_access_info
    fi
}

# 顯示存取資訊 / Show access information
show_access_info() {
    print_header "服務存取資訊 / Service Access Information"
    
    echo "以下是所有服務的存取地址 / Here are the access URLs for all services:"
    echo ""
    echo "📺 Jellyfin (媒體伺服器): http://localhost:8096"
    echo "⬇️  AriaNg (下載管理器): http://localhost:6880"
    echo "🎬 WebTube (影片下載器): http://localhost:8081"
    echo "🎵 Navidrome (音樂伺服器): http://localhost:4533"
    echo "🏠 Home Assistant (智能家居): http://localhost:8123"
    echo "📊 InfluxDB (資料庫): http://localhost:8086"
    echo "📈 Grafana (監控面板): http://localhost:3000"
    echo "🔄 Zigbee2MQTT (Zigbee 橋接器): http://localhost:8080"
    echo "🔧 Node-RED (自動化平台): http://localhost:1880"
    echo ""
    echo "請確保防火牆允許這些端口的存取 / Please ensure firewall allows access to these ports"
}

# 服務管理函數 / Service management functions
manage_services() {
    print_header "服務管理 / Service Management"
    
    echo "1. 查看所有服務狀態 / View all service status"
    echo "2. 停止所有服務 / Stop all services"
    echo "3. 重啟所有服務 / Restart all services"
    echo "4. 更新所有服務 / Update all services"
    echo "5. 清理未使用的映像檔 / Clean unused images"
    echo "6. 返回主選單 / Return to main menu"
    
    read -p "請選擇 / Please select: " choice
    
    case $choice in
        1) show_service_status;;
        2) stop_all_services;;
        3) restart_all_services;;
        4) update_all_services;;
        5) cleanup_images;;
        6) return;;
    esac
}

show_service_status() {
    print_info "查看服務狀態 / Checking service status"
    
    local compose_files=(
        "jellyfin-docker-compose.yml"
        "ariang-docker-compose.yml"
        "webtube-docker-compose.yml"
        "navidrome-docker-compose.yml"
        "homeassistant-docker-compose.yml"
        "zigbee2mqtt-docker-compose.yml"
    )
    
    for file in "${compose_files[@]}"; do
        if [[ -f "$file" ]]; then
            echo "--- $file ---"
            docker-compose -f "$file" ps
            echo ""
        fi
    done
}

stop_all_services() {
    print_info "停止所有服務 / Stopping all services"
    
    local compose_files=(
        "jellyfin-docker-compose.yml"
        "ariang-docker-compose.yml"
        "webtube-docker-compose.yml"
        "navidrome-docker-compose.yml"
        "homeassistant-docker-compose.yml"
        "zigbee2mqtt-docker-compose.yml"
    )
    
    for file in "${compose_files[@]}"; do
        if [[ -f "$file" ]]; then
            print_info "停止 $file"
            docker-compose -f "$file" down
        fi
    done
    
    print_success "所有服務已停止 / All services stopped"
}

restart_all_services() {
    print_info "重啟所有服務 / Restarting all services"
    
    stop_all_services
    sleep 3
    
    local compose_files=(
        "jellyfin-docker-compose.yml"
        "ariang-docker-compose.yml"
        "webtube-docker-compose.yml"
        "navidrome-docker-compose.yml"
        "homeassistant-docker-compose.yml"
        "zigbee2mqtt-docker-compose.yml"
    )
    
    for file in "${compose_files[@]}"; do
        if [[ -f "$file" ]]; then
            print_info "啟動 $file"
            docker-compose -f "$file" up -d
        fi
    done
    
    print_success "所有服務已重啟 / All services restarted"
}

update_all_services() {
    print_info "更新所有服務 / Updating all services"
    
    local compose_files=(
        "jellyfin-docker-compose.yml"
        "ariang-docker-compose.yml"
        "webtube-docker-compose.yml"
        "navidrome-docker-compose.yml"
        "homeassistant-docker-compose.yml"
        "zigbee2mqtt-docker-compose.yml"
    )
    
    for file in "${compose_files[@]}"; do
        if [[ -f "$file" ]]; then
            print_info "更新 $file"
            docker-compose -f "$file" pull
            docker-compose -f "$file" up -d
        fi
    done
    
    print_success "所有服務已更新 / All services updated"
}

cleanup_images() {
    print_info "清理未使用的映像檔 / Cleaning unused images"
    
    docker image prune -f
    docker system prune -f
    
    print_success "清理完成 / Cleanup completed"
}

# 主程式 / Main program
main() {
    print_header "歡迎使用 MyNasDockerS 一鍵安裝腳本 / Welcome to MyNasDockerS One-Click Installation Script"
    
    # 檢查系統需求 / Check system requirements
    check_requirements
    
    # 建立必要目錄 / Create necessary directories
    create_directories
    
    # 建立預設設定檔 / Create default configuration files
    create_default_configs
    
    # 主選單循環 / Main menu loop
    while true; do
        show_menu
        read -p "請輸入選項 / Please enter option: " choice
        
        case $choice in
            1) deploy_jellyfin;;
            2) deploy_ariang;;
            3) deploy_webtube;;
            4) deploy_navidrome;;
            5) deploy_homeassistant;;
            6) deploy_zigbee2mqtt;;
            7) deploy_all;;
            8) custom_install;;
            9) 
                print_info "感謝使用 MyNasDockerS / Thank you for using MyNasDockerS"
                exit 0
                ;;
            m) manage_services;;
            *) print_error "無效選項 / Invalid option";;
        esac
        
        echo ""
        read -p "按 Enter 鍵繼續... / Press Enter to continue..."
    done
}

# 執行主程式 / Run main program
main "$@"