import re
import sys

text = sys.stdin.read()

# Mask 192.168.A.B -> 192.168.X.B
text = re.sub(r"\b192\.168\.\d{1,3}\.(\d{1,3})\b", r"192.168.X.\1", text)

# Mask MAC addresses aa:bb:cc:dd:ee:ff -> aa:bb:cc:XX:XX:XX
text = re.sub(
    r"\b([0-9a-fA-F]{2}:[0-9a-fA-F]{2}:[0-9a-fA-F]{2}):([0-9a-fA-F]{2}):([0-9a-fA-F]{2}):([0-9a-fA-F]{2})\b",
    r"\1:XX:XX:XX",
    text,
)

# Remove service version fingerprints from Nmap "-sV" output lines.
# Keep: "<port>/<proto>  open  <service>"
text = re.sub(
    r"(?m)^(\d+/(?:tcp|udp)\s+open\s+\S+)\s+.*$",
    r"\1",
    text
)

sys.stdout.write(text)