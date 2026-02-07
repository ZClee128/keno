# 批量生成头像和占位图

## 🚀 快速开始

### 1. 安装依赖

```bash
cd /Users/Keno/源码/keno
pip3 install Pillow
```

### 2. 生成所有图片

```bash
# 生成头像（16个）
python3 generate_avatars.py

# 生成占位图（3个）
python3 generate_placeholders.py
```

生成的图片会保存在 `generated_avatars/` 目录中。

---

## 📁 生成的文件列表

### 头像文件
- `avatar_default.png` - 默认头像 (D)
- `avatar_guest.png` - 访客头像 (G)
- `avatar_reptilefan.png` - ReptileFan (RF)
- `avatar_snake.png` - Snake (SN)
- `avatar_chameleoncham.png` - ChameleonCham (CC)
- `avatar_turtlepower.png` - TurtlePower (TP)
- `avatar_beardedbuddy.png` - BeardedBuddy (BB)
- `avatar_iguanaiggy.png` - IguanaIggy (II)
- `avatar_frogprince.png` - FrogPrince (FP)
- `avatar_dinodan.png` - DinoDan (DD)
- `avatar_scalysue.png` - ScalySue (SS)
- `avatar_koboldkeeper.png` - KoboldKeeper (KK)
- `avatar_vipervicky.png` - ViperVicky (VV)
- `avatar_gatorgary.png` - GatorGary (GG)
- `avatar_komodoking.png` - KomodoKing (KK)
- `avatar_axolotlally.png` - AxolotlAlly (AA)

### 占位图文件
- `placeholder_reptile_1.png` - 绿色渐变 + 🦎
- `placeholder_reptile_2.png` - 橙色渐变 + 🐍
- `placeholder_reptile_3.png` - 蓝色渐变 + 🐢

---

## 📲 添加到Xcode

### 方法1: 手动添加（推荐）

1. 打开Xcode项目
2. 点击 `Assets.xcassets`
3. 对于每个PNG文件：
   - 右键点击 → `New Image Set`
   - 重命名为对应的文件名（去掉.png扩展名）
   - 拖拽PNG文件到1x槽位

### 方法2: 使用脚本（需要actool）

```bash
# 批量导入（高级用户）
for img in generated_avatars/*.png; do
  name=$(basename "$img" .png)
  echo "Adding $name..."
  # 需要手动配置actool路径
done
```

---

## 🎨 自定义颜色

如果想修改头像颜色，编辑 `generate_avatars.py` 中的 `COLORS` 数组：

```python
COLORS = [
    "#FF6B6B",  # 红色
    "#4ECDC4",  # 青色
    # ... 添加更多颜色
]
```

---

## ✅ 验证

生成并添加到Xcode后，运行应用检查：
- [ ] 所有用户头像正常显示
- [ ] Feed中的占位图正常显示
- [ ] 没有"图片未找到"的警告

---

## 🐛 故障排除

**问题**: `ModuleNotFoundError: No module named 'PIL'`  
**解决**: 运行 `pip3 install Pillow`

**问题**: 生成的图片太大  
**解决**: 修改脚本中的 `AVATAR_SIZE` 或 `IMAGE_WIDTH/HEIGHT`

**问题**: Xcode找不到图片  
**解决**: 确保Image Set名称和代码中的完全一致（区分大小写）
