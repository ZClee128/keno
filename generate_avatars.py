#!/usr/bin/env python3
"""
批量生成头像图片
为所有用户名生成彩色圆形头像，带有首字母缩写
"""

from PIL import Image, ImageDraw, ImageFont
import hashlib
import os

# 配置
OUTPUT_DIR = "./generated_avatars"
AVATAR_SIZE = 200  # 头像尺寸
FONT_SIZE = 80     # 字体大小

# 需要生成的头像列表
AVATARS = [
    "default",
    "guest", 
    "reptilefan",
    "snake",
    # Mock用户头像
    "chameleoncham",
    "turtlepower",
    "beardedbuddy",
    "iguanaiggy",
    "frogprince",
    "dinodan",
    "scalysue",
    "koboldkeeper",
    "vipervicky",
    "gatorgary",
    "komodoking",
    "axolotlally"
]

# 颜色方案（HSL风格的明亮颜色）
COLORS = [
    "#FF6B6B",  # 红色
    "#4ECDC4",  # 青色
    "#45B7D1",  # 蓝色
    "#FFA07A",  # 橙色
    "#98D8C8",  # 薄荷绿
    "#F7DC6F",  # 黄色
    "#BB8FCE",  # 紫色
    "#85C1E9",  # 天蓝色
    "#F8B88B",  # 桃色
    "#ABEBC6",  # 浅绿色
    "#FAD7A0",  # 浅橙色
    "#D7BDE2",  # 淡紫色
]

def get_color_for_name(name):
    """根据名称生成一致的颜色"""
    hash_value = int(hashlib.md5(name.encode()).hexdigest(), 16)
    return COLORS[hash_value % len(COLORS)]

def get_initials(name):
    """获取名称缩写（最多2个字母）"""
    # 特殊处理
    if name == "default":
        return "D"
    if name == "guest":
        return "G"
    
    # 驼峰命名拆分
    words = []
    current_word = name[0].upper()
    
    for char in name[1:]:
        if char.isupper():
            words.append(current_word)
            current_word = char
        else:
            current_word += char
    words.append(current_word)
    
    # 取前两个单词的首字母
    if len(words) >= 2:
        return (words[0][0] + words[1][0]).upper()
    else:
        return name[:2].upper()

def generate_avatar(name, output_path):
    """生成单个头像"""
    # 创建图片
    img = Image.new('RGB', (AVATAR_SIZE, AVATAR_SIZE), 'white')
    draw = ImageDraw.Draw(img)
    
    # 获取颜色
    bg_color = get_color_for_name(name)
    
    # 绘制圆形背景
    draw.ellipse([0, 0, AVATAR_SIZE, AVATAR_SIZE], fill=bg_color)
    
    # 获取缩写
    initials = get_initials(name)
    
    # 尝试使用系统字体，如果失败则使用默认字体
    try:
        # macOS常见字体
        font = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", FONT_SIZE)
    except:
        try:
            font = ImageFont.truetype("/Library/Fonts/Arial.ttf", FONT_SIZE)
        except:
            # 使用默认字体
            font = ImageFont.load_default()
    
    # 计算文字位置（居中）
    bbox = draw.textbbox((0, 0), initials, font=font)
    text_width = bbox[2] - bbox[0]
    text_height = bbox[3] - bbox[1]
    
    text_x = (AVATAR_SIZE - text_width) // 2
    text_y = (AVATAR_SIZE - text_height) // 2 - 5  # 微调垂直位置
    
    # 绘制文字
    draw.text((text_x, text_y), initials, fill='white', font=font)
    
    # 保存图片
    img.save(output_path, 'PNG')
    print(f"✓ Generated: {output_path}")

def main():
    """主函数"""
    # 创建输出目录
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    
    print("🎨 Starting avatar generation...")
    print(f"📁 Output directory: {OUTPUT_DIR}")
    print(f"🖼️  Avatar size: {AVATAR_SIZE}x{AVATAR_SIZE}")
    print(f"📝 Total avatars to generate: {len(AVATARS)}\n")
    
    # 生成所有头像
    for name in AVATARS:
        output_path = os.path.join(OUTPUT_DIR, f"avatar_{name}.png")
        generate_avatar(name, output_path)
    
    print(f"\n✅ Success! Generated {len(AVATARS)} avatars in {OUTPUT_DIR}/")
    print("\n📋 Next steps:")
    print("1. Open Xcode and navigate to Assets.xcassets")
    print("2. For each PNG file in generated_avatars/:")
    print("   - Right-click in Assets.xcassets → New Image Set")
    print("   - Rename to match the filename (e.g., 'avatar_default')")
    print("   - Drag the PNG file into the 1x slot")
    print("3. Build and run your app!")

if __name__ == "__main__":
    main()
