import subprocess

try:
    pid = subprocess.Popen(['get_species_taxids.sh','-n','Eubacteria','>','eubacteria.taxid'])
    print("[+] spawned new process: {}".format(pid.pid))
    signal = pid.communicate()
    print("[*] waiting for get_species_taxids.sh to finish: {}".format(signal))
except Exception as e:
    print("[-] Exception occured: {}".format(e))