#!/bin/bash

set -e

echo "=== NetworkManager ブリッジネットワーク設定スクリプト ==="
echo ""

# br0が既に存在すれば何もしない
echo "[1/5] 既存のbr0接続をチェック..."
if nmcli connection show br0 &>/dev/null; then
    echo "  br0は既に存在します。設定をスキップします。"
    exit 0
else
    echo "  既存のbr0は見つかりませんでした"
fi

# 既存のブリッジスレーブ接続を削除
echo ""
echo "[2/5] 既存のブリッジスレーブ接続を削除..."
for conn in $(nmcli -t -f NAME connection show | grep "^bridge-slave-"); do
    echo "  削除: $conn"
    nmcli connection delete "$conn"
done

# アクティブな有線インターフェイスを検出
echo ""
echo "[3/5] アクティブな有線インターフェイスを検出..."

# 有線インターフェイスを検索（アクティブなものを優先）
PRIMARY_IF=$(nmcli -t -f DEVICE,TYPE,STATE device | grep "ethernet:connected" | head -n1 | cut -d: -f1)

if [ -z "$PRIMARY_IF" ]; then
    # アクティブな有線がない場合、存在する有線を検索
    PRIMARY_IF=$(nmcli -t -f DEVICE,TYPE device | grep "ethernet" | head -n1 | cut -d: -f1)
fi

if [ -z "$PRIMARY_IF" ]; then
    echo "  エラー: 有線インターフェイスが見つかりません"
    exit 1
fi

echo "  検出: 有線インターフェイス $PRIMARY_IF を使用します"

# ブリッジ接続を作成
echo ""
echo "[4/5] ブリッジ接続を作成..."
nmcli connection add type bridge con-name br0 ifname br0 \
    ipv4.method auto \
    ipv4.dns "94.140.14.14 94.140.15.15" \
    ipv4.ignore-auto-dns yes \
    ipv6.dns "2a10:50c0::ad1:ff 2a10:50c0::ad2:ff" \
    ipv6.ignore-auto-dns yes \
    bridge.stp no

echo "  ブリッジbr0を作成しました"

# 物理インターフェイスをブリッジのスレーブとして追加
echo ""
echo "  物理インターフェイス $PRIMARY_IF をブリッジに接続..."

nmcli connection add type ethernet slave-type bridge \
    con-name bridge-slave-$PRIMARY_IF \
    ifname $PRIMARY_IF \
    master br0

echo "  スレーブ接続を作成しました"

# 既存の物理インターフェイス接続を削除
echo ""
echo "  既存の物理インターフェイス接続を削除..."
for conn in $(nmcli -t -f NAME,DEVICE connection show | grep ":$PRIMARY_IF$" | cut -d: -f1); do
    if [[ ! "$conn" =~ ^bridge-slave- ]] && [ "$conn" != "br0" ]; then
        echo "    削除: $conn"
        nmcli connection delete "$conn" 2>/dev/null || true
    fi
done

# まだアクティブな接続があれば強制的にダウン
for conn in $(nmcli -t -f NAME,DEVICE connection show --active | grep ":$PRIMARY_IF$" | cut -d: -f1); do
    if [[ ! "$conn" =~ ^bridge-slave- ]] && [ "$conn" != "br0" ]; then
        echo "    強制ダウン: $conn"
        nmcli connection down "$conn" 2>/dev/null || true
    fi
done

# 物理インターフェイスのリンクをダウンして再起動
echo ""
echo "  物理インターフェイスをリセット..."
ip link set $PRIMARY_IF down
sleep 1
ip link set $PRIMARY_IF up
sleep 2

# ブリッジスレーブを起動
echo ""
echo "[5/5] ブリッジを起動..."
echo "  ブリッジスレーブを起動..."
nmcli connection up bridge-slave-$PRIMARY_IF

echo "  ブリッジを起動..."
nmcli connection up br0

# DHCPアドレス取得を待つ
echo ""
echo "  DHCPアドレス取得を待機中..."
for i in {1..10}; do
    if ip addr show br0 | grep -q "inet "; then
        echo "  IPアドレスが割り当てられました"
        break
    fi
    echo "    待機中... ($i/10)"
    sleep 2
done

echo ""
echo "=== 設定完了 ==="
echo ""

# 設定結果を表示
echo "=== 設定結果 ==="
echo ""
echo "■ ブリッジ接続情報:"
nmcli connection show br0 | grep -E "(connection.id|connection.interface-name|bridge.stp|ipv4.method|ipv4.dns|ipv4.ignore-auto-dns)"

echo ""
echo "■ ブリッジに接続されたインターフェイス:"
bridge link show 2>/dev/null || echo "  (bridge-utilsがインストールされていません)"

echo ""
echo "■ IPアドレス情報:"
ip addr show br0 | grep -E "(inet |inet6 )"

echo ""
echo "■ DNS設定:"
if command -v resolvectl &>/dev/null; then
    resolvectl status br0 2>/dev/null | grep "DNS Servers:" || echo "  DNS情報を取得できませんでした"
else
    echo "  現在の/etc/resolv.conf:"
    grep "nameserver" /etc/resolv.conf
fi

echo ""
echo "ブリッジネットワークの設定が完了しました！"
