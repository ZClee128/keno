#!/usr/bin/env python3
"""
批量生成占位图片
生成爬行动物主题的渐变占位图
"""

from PIL import Image, ImageDraw, ImageFont
import os

# 配置
OUTPUT_DIR = "./generated_avatars"
IMAGE_WIDTH = 400
IMAGE_HEIGHT = 600

# 占位图配置
PLACEHOLDERS = [
    {"name": "placeholder_reptile_1", "colors": ["#2E7D32", "#66BB6A"], "emoji": "🦎"},
    {"name": "placeholder_reptile_2", "colors": ["#FF6F00", "#FFB74D"], "emoji": "🐍"},
    {"name": "placeholder_reptile_3", "colors": ["#1976D2", "#64B5F6"], "emoji": "🐢"},
]

def create_gradient(width, height, color1, color2):
    """创建垂直渐变"""
    base = Image.new('RGB', (width, height), color1)
    draw = ImageDraw.Draw(base)
    
    # 将颜色字符串转换为RGB
    r1, g1, b1 = tuple(int(color1[i:i+2], 16) for i in (1, 3, 5))
    r2, g2, b2 = tuple(int(color2[i:i+2], 16) for i in (1, 3, 5))
    
    # 绘制渐变
    for y in range(height):
        ratio = y / height
        r = int(r1 + (r2 - r1) * ratio)
        g = int(g1 + (g2 - g1) * ratio)
        b = int(b1 + (b2 - b1) * ratio)
        draw.line([(0, y), (width, y)], fill=(r, g, b))
    
    return base

def generate_placeholder(config, output_path):
    """生成占位图"""
    # 创建渐变背景
    img = create_gradient(IMAGE_WIDTH, IMAGE_HEIGHT, config["colors"][0], config["colors"][1])
    draw = ImageDraw.Draw(img)
    
    # 添加emoji（如果支持）
    emoji = config["emoji"]
    
    # 尝试使用大字体绘制emoji
    try:
        font = ImageFont.truetype("/System/Library/Fonts/Apple Color Emoji.ttc", 120)
        
        # 计算居中位置
        bbox = draw.textbbox((0, 0), emoji, font=font)
        text_width = bbox[2] - bbox[0]
        text_height = bbox[3] - bbox[1]
        
        text_x = (IMAGE_WIDTH - text_width) // 2
        text_y = (IMAGE_HEIGHT - text_height) // 2
        
        draw.text((text_x, text_y), emoji, font=font, embedded_color=True)
    except:
        # 如果失败，绘制简单文字
        try:
            font = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 80)
        except:
            font = ImageFont.load_default()
        
        text = "REPTILE"
        bbox = draw.textbbox((0, 0), text, font=font)
        text_width = bbox[2] - bbox[0]
        text_height = bbox[3] - bbox[1]
        
        text_x = (IMAGE_WIDTH - text_width) // 2
        text_y = (IMAGE_HEIGHT - text_height) // 2
        
        draw.text((text_x, text_y), text, fill='white', font=font)
    
    # 保存图片
    img.save(output_path, 'PNG')
    print(f"✓ Generated: {output_path}")

def main():
    """主函数"""
    # 创建输出目录
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    
    print("🖼️  Starting placeholder generation...")
    print(f"📁 Output directory: {OUTPUT_DIR}")
    print(f"📐 Image size: {IMAGE_WIDTH}x{IMAGE_HEIGHT}")
    print(f"📝 Total placeholders to generate: {len(PLACEHOLDERS)}\n")
    
    # 生成所有占位图
    for config in PLACEHOLDERS:
        output_path = os.path.join(OUTPUT_DIR, f"{config['name']}.png")
        generate_placeholder(config, output_path)
    
    print(f"\n✅ Success! Generated {len(PLACEHOLDERS)} placeholders in {OUTPUT_DIR}/")

if __name__ == "__main__":
    main()
