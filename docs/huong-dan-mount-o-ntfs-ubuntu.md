# Hướng dẫn Mount ổ NTFS (ổ D) trên Ubuntu

## Bối cảnh
- Máy dual boot Windows + Ubuntu
- Ổ DATA (`/dev/nvme0n1p4`) định dạng NTFS không tự mount được

---

## Bước 1: Cài driver NTFS

```bash
sudo apt update
sudo apt install ntfs-3g
```

---

## Bước 2: Kiểm tra tên ổ

```bash
lsblk -f
```

> Tìm dòng có `TYPE="ntfs"` và label tương ứng (ví dụ: `DATA`), ghi lại tên ổ (ví dụ: `/dev/nvme0n1p4`) và UUID.

```bash
sudo blkid
```

> Lấy UUID của ổ DATA, ví dụ: `UUID="2462DD4A62DD20FA"`

---

## Bước 3: Mount ổ thủ công (lần đầu)

```bash
sudo mkdir -p /mnt/data
sudo mount -t ntfs-3g /dev/nvme0n1p4 /mnt/data
```

> Nếu báo lỗi "hibernated" (Windows chưa tắt hoàn toàn):
> ```bash
> sudo ntfsfix /dev/nvme0n1p4
> ```

---

## Bước 4: Hiện ổ trong sidebar Files (Nautilus)

```bash
sudo mkdir -p /media/$USER/DATA
sudo mount --bind /mnt/data /media/$USER/DATA
```

> Đóng và mở lại Files — ổ DATA sẽ hiện ở sidebar.

---

## Bước 5: Tự động mount mỗi lần khởi động

Thêm vào `/etc/fstab`:

```bash
echo 'UUID=2462DD4A62DD20FA /mnt/data ntfs-3g defaults,uid=1000,gid=1000,umask=022 0 0' | sudo tee -a /etc/fstab

echo '/mnt/data /media/$USER/DATA none bind 0 0' | sudo tee -a /etc/fstab
```

Kiểm tra fstab hoạt động đúng:

```bash
sudo mount -a
```

---

## Lưu ý quan trọng

| Vấn đề | Giải pháp |
|---|---|
| Windows bật Fast Startup | Vào Windows → Power Options → tắt "Turn on fast startup" → Shutdown hẳn |
| Ổ bị lock do hibernate | Chạy `sudo ntfsfix /dev/nvme0n1p4` |
| UUID khác máy | Dùng `sudo blkid` để lấy UUID đúng của máy đó |
| Tên user khác | Thay `may3` hoặc dùng `$USER` cho tự động |

---

## Thông tin máy tham khảo (may3-X99-F8)

| Ổ | Thiết bị | UUID | Mount point |
|---|---|---|---|
| EFI | nvme0n1p1 | 02DE-44F2 | /boot/efi |
| WINDOWS (C:) | nvme0n1p3 | BE74E35074E30A4B | /run/media/may3/WINDOWS |
| DATA (D:) | nvme0n1p4 | 2462DD4A62DD20FA | /mnt/data |
| Ubuntu | nvme0n1p6 | fe192362-... | / |

> Script tự động: `../mount-ntfs.sh`
