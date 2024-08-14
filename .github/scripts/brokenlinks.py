import re
import sys
import os

def findrefs(path, line):
    parts = path.split("/")[:-1]

    rex = """](\\(([^)\\s]+)[\\)\\s])"""
    pattern = re.compile(rex)
    links = set()
    matches = re.findall(pattern, line)
    for m in matches:
        ref = m[1]
        if ref[:4] == 'http':
            continue
        hash_idx = ref.find('#')
        if hash_idx > 0:
            ref = ref[:hash_idx]
        elif hash_idx == 0:
            continue
        if ref[-1:] == '/':
            ref = ref + 'README.md'
        if (ref[:1] == "/"):
            links.add(ref[1:])
            continue

        ref_parts = parts
        while ref[:3] == "../":
            ref = ref[3:]
            ref_parts = ref_parts[:-1]
        if ref[:2] == "./":
            ref = ref[2:]
        # print(m[1], ref, ref_parts)
        if len(ref_parts) > 0:
            links.add("/".join(ref_parts) + "/" + ref)
        else:
            links.add(ref)
    return links

def findlinks(path):
    links = set()
    for line in open(path):
        links.update(findrefs(path, line))

    return links

def run_tests():
    success = True
    for path, line, links in [
        ("test.md", "something ](/ref.md) other", {"ref.md"}),
        ("test.md", "something ](/ref.md \"Text\") other", {"ref.md"}),
        ("dir/test.md", "something ](../ref.md) other", {"ref.md"}),
        ("dir/sub/test.md", "something ](../../ref.md) other", {"ref.md"}),
        ("dir/sub/test.md", "something ](../ref.md) other", {"dir/ref.md"}),
        ("test.md", "something ](dir/) other", {"dir/README.md"}),
        ("test.md", "something ](http://ref/) other", set()),
        ("test.md", "[A](a.md) [B](b.md)", {"a.md", "b.md"}),
    ]:
        actual = findrefs(path, line)
        if not actual == links:
            print(f"Expected {links}, got {actual} for")
            print(f"  {path}: \"\"\"{line}\"\"\"")
            success = False

    return 0 if success else -1

if __name__ == '__main__':
    if len(sys.argv) > 1 and sys.argv[1] == "test":
        print("TESTING")
        exit(run_tests())
    files = findlinks("SUMMARY.md")
    success = True
    for file in sorted(files):
        if not os.path.isfile(file):
            if not file[:8] == "dynamic/":
                print(f"{file} does not exist")
            continue

        refs = findlinks(file)
        first = True
        for ref in sorted(refs):
            if ref[-1:] == '/':
                ref = ref + 'README.md'
            if ref[:9] == ".gitbook/":
                if not os.path.isfile(ref):
                    print(f"  {ref}")
                    success = False
            elif ref not in files:
                if first:
                    print(f"{file}")
                    first = False
                print(f"  {ref}")
                success = False
    if not success:
        sys.exit(1)
