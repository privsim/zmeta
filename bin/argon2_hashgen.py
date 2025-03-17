import argparse
import getpass
import re
from argon2 import PasswordHasher

def validate_password(password):
    # Check the password is at least 12 characters long
    if len(password) < 12:
        print('Warning: Password is less than 12 characters. It is recommended to use a password of at least 12 characters.')

    # Check the password contains at least one number, one lowercase letter, and one uppercase letter
    if not re.search(r'\d', password) or not re.search(r'[a-z]', password) or not re.search(r'[A-Z]', password):
        print('Warning: Password should contain at least one number, one lowercase letter, and one uppercase letter for better security.')

    # Check the password contains only alphanumeric and special characters
    if not re.match(r'^[a-zA-Z0-9!@#$%^&*()]*$', password):
        print('Warning: Password contains invalid characters. It is recommended to use only alphanumeric and !@#$%^&*() characters.')

def hash_password(password, time_cost, memory_cost, parallelism, hash_len, salt_len):
    ph = PasswordHasher(
        time_cost=time_cost,
        memory_cost=memory_cost,
        parallelism=parallelism,
        hash_len=hash_len,
        salt_len=salt_len,
    )
    return ph.hash(password)

def main():
    parser = argparse.ArgumentParser(description='Generate an Argon2 hash of a password.')
    parser.add_argument('--time_cost', type=int, default=2)
    parser.add_argument('--memory_cost', type=int, default=102400)
    parser.add_argument('--parallelism', type=int, default=8)
    parser.add_argument('--hash_len', type=int, default=32)
    parser.add_argument('--salt_len', type=int, default=16)
    args = parser.parse_args()

    password = getpass.getpass(prompt='Enter your password: ', stream=None)

    validate_password(password)

    hash = hash_password(password, args.time_cost, args.memory_cost, args.parallelism, args.hash_len, args.salt_len)
    print(hash)

if __name__ == '__main__':
    main()


