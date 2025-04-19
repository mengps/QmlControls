TEMPLATE = subdirs

SUBDIRS += \
    GlowCircularImage \
    MagicFish \
    EditorImageHelper \
    FramelessWindow_Win \
    FramelessWindow_All \
    PolygonWindow \
    HistoryEditor \
    VideoOutput \
    FpsItem \
    ColorPicker \
    WaterfallFlow \
    Notification \
    WaveProgress

FramelessWindow_Win.file = FramelessWindow/framelesswindow_win/FramelessWindow.pro
FramelessWindow_All.file = FramelessWindow/framelesswindow_all/FramelessWindow.pro
