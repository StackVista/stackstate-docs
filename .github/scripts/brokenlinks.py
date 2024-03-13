import re
import sys
import os

def findlinks(path):
    parts = path.split("/")[:-1]

    rex = """](\\(([^)]+)\\))"""
    pattern = re.compile(rex)
    links = set()
    for line in open(path):
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
            ref_parts = parts
            if (ref[:1] == "/"):
                links.add(ref[1:])
                continue

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

if __name__ == '__main__':
    files = findlinks("SUMMARY.md")
    success = True
    for file in files:
        if not os.path.isfile(file):
            continue

        refs = findlinks(file)
        first = True
        for ref in refs:
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
