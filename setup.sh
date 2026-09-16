#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# BEKEN - bootstrap installer
# Repository layout:
#   faisin/beken/
#     setup.sh
#     adyetubar.zip
#
# setup.sh ini HANYA bootstrap:
# 1. download adyetubar.zip dari repo sendiri
# 2. ekstrak seluruh paket
# 3. jalankan setup.sh utama dari dalam paket
# ============================================================

SAFE_PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
export PATH="${SAFE_PATH}"

REPO_RAW_BASE="https://raw.githubusercontent.com/faisin/beken/main"
PACKAGE_URL="${REPO_RAW_BASE}/adyetubar.zip"

INSTALL_ROOT="/opt/adyetubar"
PACKAGE_DIR="${INSTALL_ROOT}/ady"
PACKAGE_ZIP="${INSTALL_ROOT}/adyetubar.zip"

die() {
  echo "[ERROR] $*" >&2
  exit 1
}

info() {
  echo "[INFO] $*"
}

[[ "${EUID:-$(id -u)}" -eq 0 ]] || die "Jalankan sebagai root."

# Hanya Debian/Ubuntu yang didukung oleh setup utama.
[[ -r /etc/os-release ]] || die "Tidak dapat membaca /etc/os-release."
. /etc/os-release

case "${ID:-}" in
  ubuntu|debian) ;;
  *)
    die "OS tidak didukung oleh installer ini: ${ID:-unknown}"
    ;;
esac

command -v apt-get >/dev/null 2>&1 || die "apt-get tidak ditemukan."

# Bootstrap hanya untuk alat yang dibutuhkan untuk mengambil dan
# mengekstrak paket. Dependency aplikasi tetap ditangani oleh
# setup.sh utama di dalam ZIP.
need_pkg=()
command -v unzip >/dev/null 2>&1 || need_pkg+=(unzip)
if ! command -v curl >/dev/null 2>&1 && ! command -v wget >/dev/null 2>&1; then
  need_pkg+=(curl)
fi

if ((${#need_pkg[@]})); then
  info "Memasang alat bootstrap: ${need_pkg[*]}"
  export DEBIAN_FRONTEND=noninteractive
  apt-get update
  apt-get install -y --no-install-recommends "${need_pkg[@]}"
fi

mkdir -p "${INSTALL_ROOT}"
chmod 755 "${INSTALL_ROOT}"

info "Mengambil paket dari faisin/beken..."
tmp_zip="${PACKAGE_ZIP}.tmp"
rm -f "${tmp_zip}"

if command -v curl >/dev/null 2>&1; then
  curl -fL --retry 3 --connect-timeout 15 --max-time 0 \
    "${PACKAGE_URL}" -o "${tmp_zip}"
else
  wget -O "${tmp_zip}" "${PACKAGE_URL}"
fi

[[ -s "${tmp_zip}" ]] || die "adyetubar.zip kosong atau gagal diunduh."
mv -f "${tmp_zip}" "${PACKAGE_ZIP}"
chmod 644 "${PACKAGE_ZIP}"

# Ekstrak paket bersih agar isi lama tidak tertinggal.
rm -rf "${PACKAGE_DIR}"
mkdir -p "${INSTALL_ROOT}/extract"

rm -rf "${INSTALL_ROOT}/extract"/*
unzip -q -o "${PACKAGE_ZIP}" -d "${INSTALL_ROOT}/extract"

# Paket yang dibuat saat ini memiliki direktori root "ady/".
[[ -d "${INSTALL_ROOT}/extract/ady" ]] \
  || die "Struktur ZIP tidak valid: direktori ady/ tidak ditemukan."

mv "${INSTALL_ROOT}/extract/ady" "${PACKAGE_DIR}"
rm -rf "${INSTALL_ROOT}/extract"

# setup.sh utama melakukan pemeriksaan trust terhadap module tree.
chown -R root:root "${PACKAGE_DIR}"
find "${PACKAGE_DIR}" -type d -exec chmod 755 {} +
find "${PACKAGE_DIR}" -type f -exec chmod 644 {} +

MAIN_SETUP="${PACKAGE_DIR}/setup.sh"
[[ -f "${MAIN_SETUP}" ]] || die "setup.sh utama tidak ditemukan di dalam ZIP."

chmod 755 "${MAIN_SETUP}"

info "Paket berhasil diekstrak."
info "Menjalankan setup.sh utama..."
echo

exec "${MAIN_SETUP}" "$@"
