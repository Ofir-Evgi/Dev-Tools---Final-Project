# Joomla Docker Project

## Setup

Make scripts executable:
```bash
chmod +x setup.sh backup.sh restore.sh cleanup.sh
```

Start environment:
```bash
./setup.sh
```

Access:
- Site: http://localhost:8080
- Admin: http://localhost:8080/administrator
- Login: `demoadmin` / `secretpassword`

## Setup + Backup

```bash
chmod +x *.sh
./setup.sh
./backup.sh
```

## Setup + Restore

```bash
chmod +x *.sh
./setup.sh
./restore.sh
```