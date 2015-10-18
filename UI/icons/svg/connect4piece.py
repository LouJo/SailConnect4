#!/usb/bin/python3

header = '''<?xml version="1.0" standalone="no"?>
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
<svg width="4cm" height="4cm" viewBox="0 0 1000 1000" xmlns="http://www.w3.org/2000/svg" version="1.1">

<title>Connect 4 piece</title>
'''

bottom = '''</svg>'''



def piece(colorFill, colorStroke, rays, name):
    global header, bottom
    fout = open(name, "w")
    print(header, file=fout)
    print('<circle cx="500" cy="500" r="490" fill="', colorFill, '" stroke="', colorStroke ,'" stroke-width="20" />', sep="", file=fout)
    for r in rays:
        print('<circle cx="500" cy="500" r="', r ,'" fill-opacity="0" stroke="', colorStroke ,'" stroke-width="20" />', sep="", file=fout)
    print(bottom, file=fout)
    fout.close()


rays = [320, 360, 400]

piece("#F3B81C", "#C48C09", rays, "yellow.svg")
piece("#DA2227", "#AE1A22", rays, "red.svg")
