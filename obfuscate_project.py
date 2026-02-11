import os

# Configuration
ROOT_DIR = '/Users/lizhicong/Desktop/海外/Keno/源码/wldo'
OLD_PREFIX = 'WLD'
NEW_PREFIX = 'WLD'

# Specific Mappings (Old -> New)
# These will be applied first, before generic prefix replacement
CLASS_MAPPINGS = {
    'WLDAuthService': 'WLDAuthService',
    'WLDChatHandler': 'WLDChatHandler',
    'WLDFeedController': 'WLDFeedController',
    'WLDStorageWorker': 'WLDStorageWorker',
    'WLDInitialData': 'WLDInitialData',
    'WLDAppConfig': 'WLDAppConfig',
    'WLDBitmapFetcher': 'WLDBitmapFetcher',
    'WLDProfile': 'WLDProfile',
    'WLDArticle': 'WLDArticle',
    'WLDChatItem': 'WLDChatItem',
    'WLDMainTab': 'WLDMainTab',
    'WLDLoginView': 'WLDLoginView',
    'wldo': 'wldo', # Project name replacement if needed, but risky for entitlement/bundle id. let's stick to safe class renames first.
}

# generic replacement for other WLD* classes
# We will do this by looking for 'WLD' followed by an uppercase letter

def replace_text_in_file(file_path):
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
    except UnicodeDecodeError:
        try:
             with open(file_path, 'r', encoding='latin-1') as f:
                content = f.read()
        except:
            print(f"Skipping binary or unreadable file: {file_path}")
            return

    new_content = content
    
    # 1. Apply specific mappings
    for old, new in CLASS_MAPPINGS.items():
        new_content = new_content.replace(old, new)
    
    # 2. Apply generic prefix replacement
    # Be careful not to replace substrings indiscriminately, but 'WLD' is quite specific as a prefix in this context.
    # To be safer, we can just do a simple replace since we are renaming the prefix.
    # However, strict prefix replacement is 'WLD' -> 'WLD'
    new_content = new_content.replace(OLD_PREFIX, NEW_PREFIX)

    if new_content != content:
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(new_content)
        print(f"Updated content in: {file_path}")

def rename_file(root, filename):
    old_path = os.path.join(root, filename)
    name, ext = os.path.splitext(filename)
    
    new_name = name
    
    # 1. Check specific mappings
    if name in CLASS_MAPPINGS:
        new_name = CLASS_MAPPINGS[name]
    else:
        # 2. Check generic prefix
        if name.startswith(OLD_PREFIX):
            new_name = name.replace(OLD_PREFIX, NEW_PREFIX, 1)
            
    if new_name != name:
        new_filename = new_name + ext
        new_path = os.path.join(root, new_filename)
        os.rename(old_path, new_path)
        print(f"Renamed: {filename} -> {new_filename}")

def process_directory(root_dir):
    # 1. Replace text in files
    for root, dirs, files in os.walk(root_dir):
        if 'Pods' in root or '.git' in root or 'build' in root:
            continue
            
        for file in files:
            file_path = os.path.join(root, file)
            # Skip hidden files
            if file.startswith('.'):
                continue
            
            # Allow text replacement in all non-hidden files
            # if file.endswith(('.swift', '.xml', '.plist', '.xib', '.storyboard', '.pbxproj', '.h', '.m', '.json')):
            if True:
                replace_text_in_file(file_path)

    # 2. Rename files (Post-order traversal would be safer for directories, but here we just do files first)
    # We need to handle directory renaming too if any directories start with WLD
    
    for root, dirs, files in os.walk(root_dir, topdown=False): # Bottom up
        if 'Pods' in root or '.git' in root or 'build' in root:
            continue

        for file in files:
            rename_file(root, file)
            
        for dir_name in dirs:
             if dir_name.startswith(OLD_PREFIX):
                new_dir_name = dir_name.replace(OLD_PREFIX, NEW_PREFIX, 1)
                os.rename(os.path.join(root, dir_name), os.path.join(root, new_dir_name))
                print(f"Renamed Directory: {dir_name} -> {new_dir_name}")

if __name__ == "__main__":
    print("Starting Obfuscation...")
    process_directory(ROOT_DIR)
    print("Obfuscation Complete.")
