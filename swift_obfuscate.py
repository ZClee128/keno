#!/usr/bin/env python3
"""
Swift Method Name Obfuscator
----------------------------
Usage:
    python3 swift_obfuscate.py <target_directory> [--prefix PREFIX] [--dry-run] [--map-file MAP_JSON]

Arguments:
    target_directory   Path to directory containing .swift files to obfuscate
    --prefix           Prefix for obfuscated names (default: 'ox')
    --dry-run          Preview changes without modifying files
    --map-file         Path to save/load a JSON mapping file (default: obfuscation_map.json beside target dir)
    --skip             Comma-separated additional method names to skip

Examples:
    python3 swift_obfuscate.py ./wldo/cc
    python3 swift_obfuscate.py ./wldo/cc --prefix zz --map-file ./my_map.json
    python3 swift_obfuscate.py ./AnotherProject/src --map-file ./my_map.json  # reuse same map
"""

import os
import re
import sys
import json
import random
import string
import argparse
from pathlib import Path

# ─── System Swift / UIKit methods to NEVER obfuscate ────────────────────────
SYSTEM_METHODS = {
    # Swift & Foundation lifecycle
    "viewDidLoad", "viewWillAppear", "viewWillDisappear", "viewDidAppear",
    "viewDidDisappear", "viewDidLayoutSubviews", "viewWillLayoutSubviews",
    "awakeFromNib", "prepareForReuse", "init", "deinit", "copy", "mutableCopy",
    "application", "applicationDidFinishLaunching", "applicationWillTerminate",
    "applicationDidBecomeActive", "applicationWillResignActive",
    "applicationDidEnterBackground", "applicationWillEnterForeground",
    # UITableView / UICollectionView
    "numberOfSections", "numberOfRowsInSection", "cellForRowAt", "heightForRowAt",
    "didSelectRowAt", "numberOfItemsInSection", "cellForItemAt", "sizeForItemAt",
    # URLSession / Networking
    "urlSession", "dataTask", "resume",
    # StoreKit
    "productsRequest", "paymentQueue", "request", "requestDidFinish",
    # Notification / Delegate patterns  
    "messaging", "userContentController", "userNotificationCenter",
    # UIKit
    "show", "dismiss", "present", "push", "pop",
    # General Swift
    "encode", "decode", "hash", "isEqual", "description", "debugDescription",
    "willSet", "didSet", "get", "set",
}

def random_name(prefix: str, length: int = 8) -> str:
    """Generate a random obfuscated name like ox_a3Fk9mXz"""
    chars = string.ascii_letters + string.digits
    suffix = ''.join(random.choices(chars, k=length))
    return f"{prefix}_{suffix}"

def extract_method_names(directory: str) -> set:
    """Extract all func names from .swift files, excluding system methods."""
    method_names = set()
    pattern = re.compile(r'\bfunc\s+([a-zA-Z_][a-zA-Z0-9_]*)\s*[\(<]')
    
    for path in Path(directory).rglob("*.swift"):
        text = path.read_text(encoding='utf-8', errors='ignore')
        for match in pattern.finditer(text):
            name = match.group(1)
            if name not in SYSTEM_METHODS and not name.startswith('_'):
                method_names.add(name)
    
    return method_names

def build_mapping(method_names: set, prefix: str, existing_map: dict = None) -> dict:
    """Build or extend a name -> obfuscated_name mapping."""
    mapping = dict(existing_map) if existing_map else {}
    used_values = set(mapping.values())
    
    for name in sorted(method_names):
        if name not in mapping:
            # Generate a unique random name
            candidate = random_name(prefix)
            while candidate in used_values:
                candidate = random_name(prefix)
            mapping[name] = candidate
            used_values.add(candidate)
    
    return mapping

def apply_obfuscation(directory: str, mapping: dict, dry_run: bool = False) -> int:
    """Apply obfuscation mapping to all .swift files. Returns number of files modified."""
    modified = 0
    
    # Sort by length desc to avoid partial replacement (longer names first)
    sorted_pairs = sorted(mapping.items(), key=lambda x: len(x[0]), reverse=True)
    
    for path in Path(directory).rglob("*.swift"):
        original = path.read_text(encoding='utf-8', errors='ignore')
        modified_text = original
        
        for original_name, obfuscated_name in sorted_pairs:
            # Only replace when the name is used as a function call or declaration
            # Uses word boundary patterns to avoid partial matches
            pattern = re.compile(r'\b' + re.escape(original_name) + r'\b')
            modified_text = pattern.sub(obfuscated_name, modified_text)
        
        if modified_text != original:
            if not dry_run:
                path.write_text(modified_text, encoding='utf-8')
            modified += 1
            print(f"  {'[DRY RUN] Would modify' if dry_run else 'Modified'}: {path.name}")
    
    return modified

def main():
    parser = argparse.ArgumentParser(description="Swift Method Name Obfuscator")
    parser.add_argument("directory", help="Target directory containing .swift files")
    parser.add_argument("--prefix", default="ox", help="Prefix for obfuscated names (default: ox)")
    parser.add_argument("--dry-run", action="store_true", help="Preview changes without modifying files")
    parser.add_argument("--map-file", default=None, help="Path to save/load JSON mapping file")
    parser.add_argument("--skip", default="", help="Comma-separated extra method names to skip")
    args = parser.parse_args()

    target_dir = os.path.abspath(args.directory)
    if not os.path.isdir(target_dir):
        print(f"❌ Error: '{target_dir}' is not a valid directory.")
        sys.exit(1)

    # Add user-specified skip names
    if args.skip:
        for name in args.skip.split(","):
            SYSTEM_METHODS.add(name.strip())

    # Determine map file path
    map_file = args.map_file or os.path.join(os.path.dirname(target_dir), "obfuscation_map.json")

    # Load existing map if present
    existing_map = {}
    if os.path.exists(map_file):
        with open(map_file, 'r') as f:
            existing_map = json.load(f)
        print(f"📂 Loaded existing mapping from: {map_file} ({len(existing_map)} entries)")

    print(f"\n🔍 Scanning .swift files in: {target_dir}")
    method_names = extract_method_names(target_dir)
    new_names = method_names - set(existing_map.keys())
    print(f"   Found {len(method_names)} unique method names ({len(new_names)} new, {len(method_names) - len(new_names)} already mapped)")

    # Build mapping
    mapping = build_mapping(method_names, args.prefix, existing_map)

    # Save map
    if not args.dry_run:
        with open(map_file, 'w') as f:
            json.dump(mapping, f, indent=2, sort_keys=True)
        print(f"\n💾 Mapping saved to: {map_file}")

    # Print sample
    print(f"\n📋 Sample mapping (first 10):")
    for i, (orig, obf) in enumerate(list(mapping.items())[:10]):
        print(f"   {orig:40s} → {obf}")

    # Apply
    print(f"\n{'🔍 [DRY RUN] ' if args.dry_run else ''}⚙️  Applying obfuscation...")
    count = apply_obfuscation(target_dir, mapping, dry_run=args.dry_run)
    print(f"\n✅ {'Would modify' if args.dry_run else 'Modified'} {count} file(s).")

    if args.dry_run:
        print("\n💡 Run without --dry-run to apply changes.")
    else:
        print(f"\n🗺️  Obfuscation map: {map_file}")
        print("   Keep this file safe — you'll need it to reverse-engineer or extend the obfuscation.")

if __name__ == "__main__":
    main()
