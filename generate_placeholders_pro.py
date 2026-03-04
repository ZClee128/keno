#!/usr/bin/env python3
"""
生成专业美观的爬行动物占位图 - 使用真实感渐变和纹理
"""

from PIL import Image, ImageDraw, ImageFont, ImageFilter
import os
import random

OUTPUT_DIR = "./generated_avatars_v2"
IMAGE_WIDTH = 400
IMAGE_HEIGHT = 600

# 专业配色方案 (Cosplay/Photography/Fashion)
PLACEHOLDER_CONFIGS = [
    {
        "name": "placeholder_fashion_1",
        "colors": ["#1A1A1D", "#4E4E50", "#6F2232"],  # Dark Fashion
        "pattern": "gradient",
        "emoji": "📸",
        "title": "FASHION"
    },
    {
        "name": "placeholder_cosplay_1", 
        "colors": ["#C3B1E1", "#A89F91", "#8C7A6B"],  # Soft Pastel 
        "pattern": "gradient",
        "emoji": "👗",
        "title": "COSPLAY"
    },
    {
        "name": "placeholder_portrait_1",
        "colors": ["#F5F5DC", "#E6E6FA", "#FFF0F5"],  # Light Portrait
        "pattern": "gradient",
        "emoji": "✨",
        "title": "PORTRAIT"
    },
]

def hex_to_rgb(hex_color):
    hex_color = hex_color.lstrip('#')
    return tuple(int(hex_color[i:i+2], 16) for i in (0, 2, 4))

def create_multi_gradient(width, height, colors):
    """Create smooth multi-color gradient"""
    img = Image.new('RGB', (width, height))
    draw = ImageDraw.Draw(img)
    
    num_colors = len(colors)
    segment_height = height // (num_colors - 1)
    
    for segment in range(num_colors - 1):
        r1, g1, b1 = hex_to_rgb(colors[segment])
        r2, g2, b2 = hex_to_rgb(colors[segment + 1])
        
        start_y = segment * segment_height
        end_y = (segment + 1) * segment_height
        
        for y in range(start_y, min(end_y, height)):
            ratio = (y - start_y) / segment_height
            r = int(r1 + (r2 - r1) * ratio)
            g = int(g1 + (g2 - g1) * ratio)
            b = int(b1 + (b2 - b1) * ratio)
            draw.line([(0, y), (width, y)], fill=(r, g, b))
    
    return img

def add_texture_pattern(img, pattern_type="scales"):
    """Add subtle texture pattern"""
    overlay = Image.new('RGBA', img.size, (255, 255, 255, 0))
    draw = ImageDraw.Draw(overlay)
    
    if pattern_type == "scales":
        # Draw subtle scale pattern
        for y in range(0, img.height, 40):
            for x in range(0, img.width, 40):
                # Hexagonal scale pattern
                offset = 20 if (y // 40) % 2 else 0
                draw.ellipse([x + offset - 15, y - 15, x + offset + 15, y + 15], 
                           outline=(255, 255, 255, 30), width=2)
    
    return Image.alpha_composite(img.convert('RGBA'), overlay)

def generate_placeholder(config, output_path):
    """Generate professional placeholder image"""
    # Create gradient
    img = create_multi_gradient(IMAGE_WIDTH, IMAGE_HEIGHT, config["colors"])
    
    # Add subtle texture
    if config.get("pattern") == "scales":
        img = add_texture_pattern(img, "scales")
    else:
        img = img.convert('RGBA')
    
    # Convert to RGBA for overlays
    if img.mode != 'RGBA':
        img = img.convert('RGBA')
    
    # Add center content
    overlay = Image.new('RGBA', img.size, (0, 0, 0, 0))
    draw = ImageDraw.Draw(overlay)
    
    # Add emoji (large, centered)
    try:
        font_emoji = ImageFont.truetype("/System/Library/Fonts/Apple Color Emoji.ttc", 120)
        emoji = config["emoji"]
        bbox = draw.textbbox((0, 0), emoji, font=font_emoji)
        emoji_width = bbox[2] - bbox[0]
        emoji_x = (IMAGE_WIDTH - emoji_width) // 2
        emoji_y = IMAGE_HEIGHT // 2 - 100
        
        draw.text((emoji_x, emoji_y), emoji, font=font_emoji, embedded_color=True)
    except:
        pass
    
    # Add title text
    try:
        font_title = ImageFont.truetype("/System/Library/Fonts/SF-Pro-Display-Bold.otf", 48)
    except:
        try:
            font_title = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 48)
        except:
            font_title = ImageFont.load_default()
    
    title = config["title"]
    bbox = draw.textbbox((0, 0), title, font=font_title)
    title_width = bbox[2] - bbox[0]
    title_x = (IMAGE_WIDTH - title_width) // 2
    title_y = IMAGE_HEIGHT // 2 + 60
    
    # Add text shadow
    draw.text((title_x + 2, title_y + 2), title, fill=(0, 0, 0, 80), font=font_title)
    # Main text
    draw.text((title_x, title_y), title, fill=(255, 255, 255, 250), font=font_title)
    
    # Composite
    img = Image.alpha_composite(img, overlay)
    
    # Apply subtle blur for professional look
    img = img.filter(ImageFilter.SMOOTH)
    
    # Save
    img.save(output_path, 'PNG', quality=95)
    print(f"✓ {config['name']}")

def main():
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    
    print("🖼️  Generating Professional Placeholders (v2)...")
    print(f"📁 Output: {OUTPUT_DIR}/\n")
    
    for config in PLACEHOLDER_CONFIGS:
        output_path = os.path.join(OUTPUT_DIR, f"{config['name']}.png")
        generate_placeholder(config, output_path)
    
    print(f"\n✅ Generated {len(PLACEHOLDER_CONFIGS)} professional placeholders!")
    print(f"📂 Location: {OUTPUT_DIR}/")

if __name__ == "__main__":
    main()
