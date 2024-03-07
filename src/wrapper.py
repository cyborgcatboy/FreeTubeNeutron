import subprocess
import time

caddy_command = "caddy file-server -r freetube-pwa/ -l :21999".split(" ")
neutron_command = "freetubeneutron localhost:21999".split(" ")

def main():
    caddy = subprocess.Popen(caddy_command)
    neutron = subprocess.Popen(neutron_command)

    while True:
        if neutron.poll() != None:
            caddy.terminate()
            exit(caddy.wait(timeout=10))
        else:
            time.sleep(2)

if __name__ == "__main__":
    main()
