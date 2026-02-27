from PIL import Image, ImageDraw

# Create 1024x1024 icon
size = 1024
img = Image.new('RGBA', (size, size), (74, 108, 247, 255))  # #4A6CF7
draw = ImageDraw.Draw(img)

# White circle background
circle_center = (size // 2, size // 2)
circle_radius = int(size * 0.35)
draw.ellipse(
    [circle_center[0] - circle_radius, circle_center[1] - circle_radius,
     circle_center[0] + circle_radius, circle_center[1] + circle_radius],
    fill=(255, 255, 255, 255)
)

# Draw checkmark
check_color = (74, 108, 247, 255)  # #4A6CF7
line_width = 80

# Checkmark points
p1 = (int(size * 0.3), int(size * 0.5))
p2 = (int(size * 0.45), int(size * 0.65))
p3 = (int(size * 0.7), int(size * 0.35))

# Draw lines
draw.line([p1, p2], fill=check_color, width=line_width)
draw.line([p2, p3], fill=check_color, width=line_width)

# Save
img.save('assets/images/app_icon.png')
print(f"Icon saved to assets/images/app_icon.png ({size}x{size})")
