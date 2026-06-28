# -*- mode: python ; coding: utf-8 -*-
import platform

main_a = Analysis(
    ["src/main.py"],
    hiddenimports=["plyer.platforms.win.notification", "util.install.windows", "util.install.linux", "util.install.macos"],
    datas=[
        ("src/resources/black/.", "resources/black"),
        ("src/resources/white/.", "resources/white"),
        ("src/resources/settings.png", "resources"),
    ],
    hookspath=["hooks"],
)

main_pyz = PYZ(main_a.pure, main_a.zipped_data)

main_exe = EXE(
    main_pyz,
    main_a.scripts,
    exclude_binaries=True,
    name="fm_rpc",
    console=False,
    version=r"#VERSION_FILE#" if platform.system() == "Windows" else None,
    icon=r"#ICON_MAIN#",
    contents_directory='.',
)

coll = COLLECT(
    main_exe,
    main_a.binaries,
    main_a.zipfiles,
    main_a.datas,
    upx=True,
    name="fm_rpc",
)

if platform.system() == "Darwin":
    app = BUNDLE(main_exe,
                 name="fm.rpc.app",
                 icon="build/macos/macos_icon.icns",
                 bundle_identifier="net.andro-32.fm_rpc",
                 version=r"#VERSION#",
                 info_plist={
                     "CFBundleVersion": r"#VERSION#",
                     "LSUIElement": True,
                     "LSBackgroundOnly": True
            }
    )
