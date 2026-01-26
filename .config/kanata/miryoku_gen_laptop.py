#!/usr/bin/env python3
"""
Generate Miryoku Kanata configuration for laptop keyboards.
Everything shifted up one row - bottom alpha row becomes thumb keys.
"""

from pathlib import Path

# Configuration options
ALPHAS = {
    'colemakdh': {
        'name': 'Colemak Mod-DH',
        'layout': ['q', 'w', 'f', 'p', 'b', 'j', 'l', 'u', 'y', "'",
                   'a', 'r', 's', 't', 'g', 'm', 'n', 'e', 'i', 'o',
                   'z', 'x', 'c', 'd', 'v', 'k', 'h', ',', '.', '/']
    },
    'qwerty': {
        'name': 'QWERTY',
        'layout': ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p',
                   'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', "'",
                   'z', 'x', 'c', 'v', 'b', 'n', 'm', ',', '.', '/']
    },
}

PLATFORMS = {
    'mac': {
        'name': 'macOS',
        'undo': 'M-z',
        'redo': 'M-S-z',
        'cut': 'M-x',
        'copy': 'M-c',
        'paste': 'M-v'
    },
}

def format_layout_line(keys):
    """Format a row of keys with proper spacing."""
    return '\t'.join(keys)

def generate_base_layer(alpha_layout):
    """Generate the base layer with home row mods for laptop."""
    layout = ALPHAS[alpha_layout]['layout']

    # Number row becomes top alpha row (Miryoku row 1)
    row1 = [layout[i] for i in range(0, 5)] + [layout[i] for i in range(5, 10)]

    # Top alpha row becomes home row with mods (Miryoku row 2)
    row2_left = [
        f'(tap-hold-release 200 200 {layout[10]} met)',
        f'(tap-hold-release 200 200 {layout[11]} alt)',
        f'(tap-hold-release 200 200 {layout[12]} ctl)',
        f'(tap-hold-release 200 200 {layout[13]} sft)',
        layout[14]
    ]
    row2_right = [
        layout[15],
        f'(tap-hold-release 200 200 {layout[16]} sft)',
        f'(tap-hold-release 200 200 {layout[17]} ctl)',
        f'(tap-hold-release 200 200 {layout[18]} alt)',
        f'(tap-hold-release 200 200 {layout[19]} met)'
    ]

    # Home row becomes bottom row (Miryoku row 3)
    row3 = [
        f'(tap-hold-release 200 200 {layout[20]} (layer-toggle U_BUTTON))',
        f'(tap-hold-release 200 200 {layout[21]} ralt)',
        layout[22], layout[23], layout[24],
        layout[25], layout[26], layout[27],
        f'(tap-hold-release 200 200 {layout[28]} ralt)',
        f'(tap-hold-release 200 200 {layout[29]} (layer-toggle U_BUTTON))'
    ]

    # Bottom row becomes thumbs - using Z X C and M , .
    thumbs = [
        '(tap-hold-release 200 200 esc (layer-toggle U_MEDIA))',
        '(tap-hold-release 200 200 spc (layer-toggle U_NAV))',
        '(tap-hold-release 200 200 tab (layer-toggle U_MOUSE))',
        '(tap-hold-release 200 200 ent (layer-toggle U_SYM))',
        '(tap-hold-release 200 200 bspc (layer-toggle U_NUM))',
        '(tap-hold-release 200 200 del (layer-toggle U_FUN))'
    ]

    lines = []
    lines.append('(deflayer U_BASE')
    lines.append(format_layout_line(row1))
    lines.append(format_layout_line(row2_left + row2_right))
    lines.append(format_layout_line(row3))
    lines.append('\t\t' + '\t'.join(thumbs))
    lines.append(')')
    return '\n'.join(lines)

def generate_nav_layer(platform_data):
    """Generate navigation layer."""
    undo, redo, cut, copy, paste = (
        platform_data['undo'], platform_data['redo'],
        platform_data['cut'], platform_data['copy'], platform_data['paste']
    )

    # Standard: arrows on NEIO (right home row)
    row1_left = ['XX', '(tap-dance 200 (XX (layer-switch U_TAP)))',
                 '(tap-dance 200 (XX (layer-switch U_EXTRA)))',
                 '(tap-dance 200 (XX (layer-switch U_BASE)))', 'XX']
    row1_right = [redo, paste, copy, cut, undo]
    row2_left = ['met', 'alt', 'ctl', 'sft', 'XX']
    row2_right = ['caps', 'left', 'down', 'up', 'right']
    row3_left = ['XX', 'ralt', '(tap-dance 200 (XX (layer-switch U_NUM)))',
                 '(tap-dance 200 (XX (layer-switch U_NAV)))', 'XX']
    row3_right = ['ins', 'home', 'pgdn', 'pgup', 'end']

    thumbs = ['XX', 'XX', 'XX', 'ent', 'bspc', 'del']

    lines = []
    lines.append('(deflayer U_NAV')
    lines.append(format_layout_line(row1_left + row1_right))
    lines.append(format_layout_line(row2_left + row2_right))
    lines.append(format_layout_line(row3_left + row3_right))
    lines.append('\t\t' + '\t'.join(thumbs))
    lines.append(')')
    return '\n'.join(lines)

def generate_config(alpha, platform):
    """Generate complete Kanata configuration for laptop."""
    alpha_data = ALPHAS[alpha]
    platform_data = PLATFORMS[platform]

    undo, redo, cut, copy, paste = (
        platform_data['undo'], platform_data['redo'],
        platform_data['cut'], platform_data['copy'], platform_data['paste']
    )

    config = f''';; Miryoku Kanata Configuration
;;
;; Alpha Layout: {alpha_data['name']}
;; Navigation: Standard navigation (arrows on NEIO)
;; Layers: Standard
;; Platform: {platform_data['name']}
;;
;; Generated from Miryoku specification
;; https://github.com/manna-harbour/miryoku

(defcfg
  process-unmapped-keys yes
  block-unmapped-keys yes
)

;; Source: 36-key layout (shifted up for laptop keyboard)
;; Top row (numbers) → Miryoku row 1
;; QWERTY row → Miryoku row 2 (home row with mods)
;; Home row → Miryoku row 3
;; Bottom corners → Thumb keys
(defsrc
  2 3 4 5 6   7 8 9 0 -
  q w e r t   y u i o p
  a s d f g   h j k l ;
  z x c   m , .
)

;; Base Layer - {alpha_data['name']} with home row mods
{generate_base_layer(alpha)}

;; Extra Layer - QWERTY alternative (switchable via tap-dance)
(deflayer U_EXTRA
q\tw\te\tr\tt\ty\tu\ti\to\tp
(tap-hold-release 200 200 a met)\t(tap-hold-release 200 200 s alt)\t(tap-hold-release 200 200 d ctl)\t(tap-hold-release 200 200 f sft)\tg\th\t(tap-hold-release 200 200 j sft)\t(tap-hold-release 200 200 k ctl)\t(tap-hold-release 200 200 l alt)\t(tap-hold-release 200 200 ' met)
(tap-hold-release 200 200 z (layer-toggle U_BUTTON))\t(tap-hold-release 200 200 x ralt)\tc\tv\tb\tn\tm\t,\t(tap-hold-release 200 200 . ralt)\t(tap-hold-release 200 200 / (layer-toggle U_BUTTON))
\t\t(tap-hold-release 200 200 esc (layer-toggle U_MEDIA))\t(tap-hold-release 200 200 spc (layer-toggle U_NAV))\t(tap-hold-release 200 200 tab (layer-toggle U_MOUSE))\t(tap-hold-release 200 200 ent (layer-toggle U_SYM))\t(tap-hold-release 200 200 bspc (layer-toggle U_NUM))\t(tap-hold-release 200 200 del (layer-toggle U_FUN))
)

;; Tap Layer - No dual-function keys
(deflayer U_TAP
{format_layout_line(alpha_data['layout'][:10])}
{format_layout_line(alpha_data['layout'][10:20])}
{format_layout_line(alpha_data['layout'][20:30])}
\t\tesc\tspc\ttab\tent\tbspc\tdel
)

;; Navigation Layer
{generate_nav_layer(platform_data)}

;; Mouse Layer
(deflayer U_MOUSE
XX\t(tap-dance 200 (XX (layer-switch U_TAP)))\t(tap-dance 200 (XX (layer-switch U_EXTRA)))\t(tap-dance 200 (XX (layer-switch U_BASE)))\tXX\t{redo}\t{paste}\t{copy}\t{cut}\t{undo}
met\talt\tctl\tsft\tXX\tXX\t(movemouse-left 5 1)\t(movemouse-down 5 1)\t(movemouse-up 5 1)\t(movemouse-right 5 1)
XX\tralt\t(tap-dance 200 (XX (layer-switch U_SYM)))\t(tap-dance 200 (XX (layer-switch U_MOUSE)))\tXX\tXX\tXX\tXX\tXX\tXX
\t\tXX\tXX\tXX\tmrgt\tmlft\tmmid
)

;; Button Layer
(deflayer U_BUTTON
{undo}\t{cut}\t{copy}\t{paste}\t{redo}\t{redo}\t{paste}\t{copy}\t{cut}\t{undo}
met\talt\tctl\tsft\tXX\tXX\tsft\tctl\talt\tmet
{undo}\t{cut}\t{copy}\t{paste}\t{undo}\t{undo}\t{paste}\t{copy}\t{cut}\t{undo}
\t\tmmid\tmlft\tmrgt\tmrgt\tmlft\tmmid
)

;; Media Layer
(deflayer U_MEDIA
XX\t(tap-dance 200 (XX (layer-switch U_TAP)))\t(tap-dance 200 (XX (layer-switch U_EXTRA)))\t(tap-dance 200 (XX (layer-switch U_BASE)))\tXX\tXX\tXX\tXX\tXX\tXX
met\talt\tctl\tsft\tXX\tXX\tprev\tvold\tvolu\tnext
XX\tralt\t(tap-dance 200 (XX (layer-switch U_FUN)))\t(tap-dance 200 (XX (layer-switch U_MEDIA)))\tXX\tXX\tXX\tXX\tXX\tXX
\t\tXX\tXX\tXX\tXX\tpp\tmute
)

;; Number Layer
(deflayer U_NUM
[\t7\t8\t9\t]\tXX\t(tap-dance 200 (XX (layer-switch U_BASE)))\t(tap-dance 200 (XX (layer-switch U_EXTRA)))\t(tap-dance 200 (XX (layer-switch U_TAP)))\tXX
;\t4\t5\t6\t=\tXX\tsft\tctl\talt\tmet
`\t1\t2\t3\t\\\tXX\t(tap-dance 200 (XX (layer-switch U_NUM)))\t(tap-dance 200 (XX (layer-switch U_NAV)))\tralt\tXX
\t\t.\t0\t-\tXX\tXX\tXX
)

;; Symbol Layer
(deflayer U_SYM
S-{{\tS-7\tS-8\tS-9\tS-}}\tXX\t(tap-dance 200 (XX (layer-switch U_BASE)))\t(tap-dance 200 (XX (layer-switch U_EXTRA)))\t(tap-dance 200 (XX (layer-switch U_TAP)))\tXX
S-scln\tS-4\tS-5\tS-6\tS-eql\tXX\tsft\tctl\talt\tmet
S-grv\tS-1\tS-2\tS-3\tS-\\\tXX\t(tap-dance 200 (XX (layer-switch U_SYM)))\t(tap-dance 200 (XX (layer-switch U_MOUSE)))\tralt\tXX
\t\tS-9\tS-0\tS-min\tXX\tXX\tXX
)

;; Function Layer
(deflayer U_FUN
f12\tf7\tf8\tf9\t102d\tXX\t(tap-dance 200 (XX (layer-switch U_BASE)))\t(tap-dance 200 (XX (layer-switch U_EXTRA)))\t(tap-dance 200 (XX (layer-switch U_TAP)))\tXX
f11\tf4\tf5\tf6\tslck\tXX\tsft\tctl\talt\tmet
f10\tf1\tf2\tf3\tpause\tXX\t(tap-dance 200 (XX (layer-switch U_FUN)))\t(tap-dance 200 (XX (layer-switch U_MEDIA)))\tralt\tXX
\t\tcomp\tspc\ttab\tXX\tXX\tXX
)
'''

    return config

def main():
    """Generate laptop keyboard configuration."""
    output_dir = Path('.')

    for alpha in ALPHAS.keys():
        filename = f'miryoku-kanata-{alpha}-laptop--mac.kbd'
        filepath = output_dir / filename

        content = generate_config(alpha, 'mac')
        filepath.write_text(content)
        print(f"✓ Generated {filename}")

if __name__ == '__main__':
    main()
