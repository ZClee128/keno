#!/usr/bin/env python3
"""
生成专业美观的头像 - 渐变背景 + 图标风格
"""

from PIL import Image, ImageDraw, ImageFont
import hashlib
import os
import math

OUTPUT_DIR = "./generated_avatars_v2"
AVATAR_SIZE = 300

# 配色方案 - 现代渐变色
GRADIENT_COLORS = [
    {"start": "#667eea", "end": "#764ba2", "name": "purple_dream"},
    {"start": "#f093fb", "end": "#f5576c", "name": "pink_sunset"},
    {"start": "#4facfe", "end": "#00f2fe", "name": "ocean_blue"},
    {"start": "#43e97b", "end": "#38f9d7", "name": "mint_fresh"},
    {"start": "#fa709a", "end": "#fee140", "name": "warm_flame"},
    {"start": "#30cfd0", "end": "#330867", "name": "deep_ocean"},
    {"start": "#a8edea", "end": "#fed6e3", "name": "soft_pastel"},
    {"start": "#ff9a56", "end": "#ff6a95", "name": "sunset_glow"},
    {"start": "#96fbc4", "end": "#f9f586", "name": "spring_green"},
    {"start": "#fbc2eb", "end": "#a6c1ee", "name": "candy_sky"},
]

AVATARS = [
    {"name": "default", "emoji": "👤", "gradient": 0},
    {"name": "guest", "emoji": "👋", "gradient": 1},
    {"name": "photogpro", "emoji": "📷", "gradient": 2},
    {"name": "cosplayqueen", "emoji": "👗", "gradient": 3},
    {"name": "aimodel", "emoji": "🤖", "gradient": 4},
    {"name": "fashionista", "emoji": "👠", "gradient": 5},
    {"name": "streetstyle", "emoji": "🧢", "gradient": 6},
    {"name": "studiolife", "emoji": "💡", "gradient": 7},
    {"name": "voguevibes", "emoji": "✨", "gradient": 8},
    {"name": "lensmaster", "emoji": "🔭", "gradient": 9},
    {"name": "trendyootd", "emoji": "🧥", "gradient": 0},
    {"name": "chicstyle", "emoji": "🕶️", "gradient": 1},
    {"name": "neonlights", "emoji": "🚥", "gradient": 2},
    {"name": "vintagegrams", "emoji": "🎞️", "gradient": 3},
    {"name": "polaroid", "emoji": "📸", "gradient": 4},
    {"name": "animefan", "emoji": "🎌", "gradient": 5},
    {"name": "kawaiicosplay", "emoji": "🎀", "gradient": 6},
    {"name": "darkacademia", "emoji": "📜", "gradient": 7},
    {"name": "y2kaesthetic", "emoji": "🦋", "gradient": 8},
    {"name": "gothicstyle", "emoji": "🦇", "gradient": 9},
    {"name": "minimalist", "emoji": "🤍", "gradient": 0},
    {"name": "couture", "emoji": "🧵", "gradient": 1},
    {"name": "runway", "emoji": "💃", "gradient": 2},
    {"name": "editorial", "emoji": "📰", "gradient": 3},
    {"name": "makeupartist", "emoji": "💄", "gradient": 4},
    {"name": "hairstylist", "emoji": "✂️", "gradient": 5},
    {"name": "creativedir", "emoji": "🎬", "gradient": 6},
    {"name": "lightingpro", "emoji": "☀️", "gradient": 7}
]

def hex_to_rgb(hex_color):
    """Convert hex color to RGB tuple"""
    hex_color = hex_color.lstrip('#')
    return tuple(int(hex_color[i:i+2], 16) for i in (0, 2, 4))

def create_radial_gradient(width, height, color1, color2):
    """Create radial gradient background"""
    img = Image.new('RGB', (width, height))
    draw = ImageDraw.Draw(img)
    
    r1, g1, b1 = hex_to_rgb(color1)
    r2, g2, b2 = hex_to_rgb(color2)
    
    center_x, center_y = width // 2, height // 2
    max_radius = math.sqrt(center_x**2 + center_y**2)
    
    for y in range(height):
        for x in range(width):
            # Calculate distance from center
            dx = x - center_x
            dy = y - center_y
            distance = math.sqrt(dx*dx + dy*dy)
            ratio = min(distance / max_radius, 1.0)
            
            # Interpolate color
            r = int(r1 + (r2 - r1) * ratio)
            g = int(g1 + (g2 - g1) * ratio)
            b = int(b1 + (b2 - b1) * ratio)
            
            img.putpixel((x, y), (r, g, b))
    
    return img

def add_circular_mask(img):
    """Add circular mask to make avatar round"""
    size = img.size
    mask = Image.new('L', size, 0)
    draw = ImageDraw.Draw(mask)
    draw.ellipse([0, 0, size[0], size[1]], fill=255)
    
    output = Image.new('RGBA', size, (255, 255, 255, 0))
    output.paste(img, (0, 0))
    output.putalpha(mask)
    return output

def generate_avatar(config, output_path):
    """Generate professional avatar with gradient and emoji"""
    gradient = GRADIENT_COLORS[config["gradient"]]
    
    # Create gradient background
    img = create_radial_gradient(AVATAR_SIZE, AVATAR_SIZE, 
                                 gradient["start"], gradient["end"])
    
    # Add circular mask
    img = add_circular_mask(img) # Try to add emoji
    try:
        # Create a larger temporary image for emoji
        emoji_img = Image.new('RGBA', (AVATAR_SIZE, AVATAR_SIZE), (0, 0, 0, 0))
        draw = ImageDraw.Draw(emoji_img)
        
        # Try Apple Color Emoji font
        font = ImageFont.truetype("/System/Library/Fonts/Apple Color Emoji.ttc", 150)
        
        # Calculate position
        emoji = config["emoji"]
        bbox = draw.textbbox((0, 0), emoji, font=font)
        text_width = bbox[2] - bbox[0]
        text_height = bbox[3] - bbox[1]
        
        text_x = (AVATAR_SIZE - text_width) // 2
        text_y = (AVATAR_SIZE - text_height) // 2 - 10
        
        # Draw emoji
        draw.text((text_x, text_y), emoji, font=font, embedded_color=True)
        
        # Composite emoji onto gradient
        img = Image.alpha_composite(img.convert('RGBA'), emoji_img)
    except Exception as e:
        print(f"  Note: Emoji rendering failed for {config['name']}, using text fallback")
        # Fallback: draw text
        draw = ImageDraw.Draw(img)
        try:
            font = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 80)
        except:
            font = ImageFont.load_default()
        
        text = config["name"][:2].upper()
        bbox = draw.textbbox((0, 0), text, font=font)
        text_width = bbox[2] - bbox[0]
        text_height = bbox[3] - bbox[1]
        
        text_x = (AVATAR_SIZE - text_width) // 2
        text_y = (AVATAR_SIZE - text_height) // 2
        
        draw.text((text_x, text_y), text, fill=(255, 255, 255, 230), font=font)
    
    # Save
    img.save(output_path, 'PNG')
    print(f"✓ {config['name']}")

def main():
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    
    print("🎨 Generating Professional Avatars (v2)...")
    print(f"📁 Output: {OUTPUT_DIR}/\n")
    
    for config in AVATARS:
        output_path = os.path.join(OUTPUT_DIR, f"avatar_{config['name']}.png")
        generate_avatar(config, output_path)
    
    print(f"\n✅ Generated {len(AVATARS)} professional avatars!")
    print(f"📂 Location: {OUTPUT_DIR}/")

if __name__ == "__main__":
    main()
