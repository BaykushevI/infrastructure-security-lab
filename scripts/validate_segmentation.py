import yaml
import subprocess

def ping_host(ip):
    try:
        subprocess.check_output(
            ["ping", "-c", "1", "-W", "1", ip],
            stderr=subprocess.DEVNULL
        )
        return True
    except subprocess.CalledProcessError:
        return False
    
def test_rule(source_label, target_ip, should_connect):
    print(f"Testing {source_label} -> {target_ip}")
    result = ping_host(target_ip)

    if result == should_connect:
        print("PASS\n")
    else:
        print("FAIL\n")

if __name__ == "__main__":
    print("Segmentation validation framework ready.")