#!/data/data/com.termux/files/usr/bin/bash
# Non-destructive network timings using the Android-configured resolver.
# bash perf/termux-netbench.sh
set -uo pipefail
if ! command -v curl >/dev/null 2>&1; then
  echo "Install curl with: pkg install curl" >&2
  exit 2
fi
printf 'SM-A175N network timings (seconds; lower is better). DNS is Android-configured.\n'
for url in 'https://www.cloudflare.com/cdn-cgi/trace' 'https://www.google.com/generate_204' 'https://github.com/'; do
  printf '\n%s\n' "$url"
  for family in -4 -6; do
    if [ "$family" = -4 ]; then label=IPv4; else label=IPv6; fi
    printf '%s\n' "$label"
    for n in 1 2 3; do
      curl "$family" --silent --show-error --location --output /dev/null \
        --connect-timeout 6 --max-time 15 \
        --write-out '  connects=%{num_connects} dns=%{time_namelookup} tcp=%{time_connect} tls=%{time_appconnect} ttfb=%{time_starttransfer} total=%{time_total} ip=%{remote_ip} code=%{http_code}\n' \
        "$url" || echo '  Request failed (endpoint inaccessible or address family unavailable).'
    done
  done
done
echo 'DNS choice changes lookup times, not mobile/Wi-Fi bandwidth. Benchmark real downloads separately.'
