# parse_requirements.py
import yaml
import sys

def parse_requirements(yaml_file):
    with open(yaml_file, 'r') as file:
        deps = yaml.safe_load(file)
    
    for dep in deps['requirements']:
        print(f"{dep['name']}=={dep['version']}")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python parse_requirements.py <yaml_file>")
        sys.exit(1)
    
    yaml_file = sys.argv[1]
    parse_requirements(yaml_file)