# 文字列操作関数
def replace_strings(text, pattern, replacement):
    for _ in range(100000):
        text = text.replace(pattern, replacement)
    return text

# 大量の文字列を生成し操作
text = "A" * 1000000  # 100万文字の"A"
result = replace_strings(text, "A", "B")
