import subprocess

def execute_ssh_commands_with_ssh(username, hostname, commands):
    try:
        ssh_command = f"ssh {username}@{hostname}"

        for command in commands:
            full_command = f"{ssh_command} 'sudo -i {command}'"
            process = subprocess.Popen(full_command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            stdout, stderr = process.communicate()
            print(f"Command: {command}")
            print("Output:")
            print(stdout.decode().strip())
            if stderr:
                print(f"Error: {stderr.decode().strip()}")

    except Exception as e:
        print(f"Error: {str(e)}")

# Пример использования:
if __name__ == "__main__":
    servers = [
        {"username": "username", "hostname": "ip"},
        {"username": "username", "hostname": "ip"},
        {"username": "username", "hostname": "ip"},
        {"username": "username", "hostname": "ip"},
        {"username": "username", "hostname": "ip"},
        {"username": "username", "hostname": "ip"},
        {"username": "username", "hostname": "ip"},
        {"username": "username", "hostname": "ip"},
        {"username": "username", "hostname": "ip"},

        # Добавьте другие серверы с их учетными данными
    ]

    commands_to_execute = [
        "solana-install init v1.16.6",
        "systemctl restart solana",
        # Добавьте другие команды для выполнения
    ]

    for server in servers:
        print(f"Connecting to {server['hostname']} as {server['username']}")
        execute_ssh_commands_with_ssh(server['username'], server['hostname'], commands_to_execute)
