# wan-ip-checker

A lightweight Docker container that monitors your public WAN IP address and exposes it as a Prometheus metric via node_exporter's textfile collector.

Disclaimer: About 50% of this code and readme was created with assistance using AI! 

## How It Works

1. The container runs a Python script on a configurable interval
2. It checks your current public IP via `checkip.dyndns.com`
3. Compares it against the last known IP
4. Writes a `.prom` file to a shared volume that node_exporter picks up
5. Prometheus scrapes the metric, and Grafana can alert on changes

## Metric

```
wan_ip_change{ip="x.x.x.x"} 0   # 0 = no change, 1 = changed
```

## Usage

### Docker Run

```bash
docker run -d \
  --name wan-ip-checker \
  -e CHECK_INTERVAL_SECONDS=3600 \
  -v /textfiles:/wan_ip_checker/textfiles \
  ggamerzz/wan-ip-checker:latest
```

### Docker Compose

```yaml
wan-ip-checker:
  image: ggamerzz/wan-ip-checker:latest
  container_name: wan-ip-checker
  restart: unless-stopped
  environment:
    - CHECK_INTERVAL_SECONDS=3600
  volumes:
    - /textfiles:/wan_ip_checker/textfiles
```

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `CHECK_INTERVAL_SECONDS` | `3600` | How often to check the WAN IP (in seconds) |

## Node Exporter Setup

Make sure node_exporter is configured to read from the same textfiles directory:

```
--collector.textfile.directory=/textfiles
```

## Prometheus Alert Example

```yaml
rules:
  - alert: WANIPChanged
    expr: wan_ip_change > 0
    annotations:
      summary: WAN IP has changed!
      description: 'New WAN IP: {{ $labels.ip }}'
```

## Docker Hub

[ggamerzz/wan-ip-checker](https://hub.docker.com/r/ggamerzz/wan-ip-checker)

## Source

The Python script used in this image lives here:  
[GGamerzz/Wan-IP-Changes-Script](https://github.com/GGamerzz/Wan-IP-Changes-Script)
